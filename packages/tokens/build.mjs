// Generates Dart token classes and the Tailwind theme from tokens.json (WEBD-03).
// Usage: node packages/tokens/build.mjs [--check]
import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const root = resolve(here, '../..');
const tokens = JSON.parse(readFileSync(resolve(here, 'tokens.json'), 'utf8'));
const check = process.argv.includes('--check');

const HEADER = 'GENERATED FILE. Edit packages/tokens/tokens.json and run `npm run tokens`.';
const cap = (s) => s[0].toUpperCase() + s.slice(1);
const argb = (hex, alpha = 1) => {
  const a = Math.round(alpha * 255).toString(16).padStart(2, '0').toUpperCase();
  return `0x${a}${hex.slice(1).toUpperCase()}`;
};
const names = ['ink', 'smoke', 'lacquer', 'vellum', 'ash', 'verdigris', 'oxblood', 'resin', 'onAccent', 'shadow'];

function resolveColor(theme, name) {
  const c = tokens.color[theme][name];
  if (typeof c === 'string') return { hex: c, alpha: 1 };
  return { hex: tokens.color[theme][c.base], alpha: c.alpha };
}

// ---- Dart ----
function dartColors() {
  const theme = (t) =>
    [...names, 'hairline']
      .map((n) => {
        const { hex, alpha } = resolveColor(t, n);
        return `    ${n}: Color(${argb(hex, alpha)}),`;
      })
      .join('\n');
  return `// ${HEADER}
// dart format off
import 'dart:ui';

/// Named colour tokens for one theme. Roles are identical in both themes:
/// [ink] is the page background and [vellum] is primary text.
class PsPalette {
  const PsPalette({
${[...names, 'hairline'].map((n) => `    required this.${n},`).join('\n')}
  });

${[...names, 'hairline'].map((n) => `  final Color ${n};`).join('\n')}

  static const nocturne = PsPalette(
${theme('nocturne')}
  );

  static const atelier = PsPalette(
${theme('atelier')}
  );
}
`;
}

function dartRarity() {
  const entries = Object.entries(tokens.rarity);
  return `// ${HEADER}
// dart format off
enum PsRarity {
${entries
  .map(([k, v]) => `  ${k}(label: '${v.label}', colorToken: '${v.color}', seal: '${v.seal}'),`)
  .join('\n')}
  ;

  const PsRarity({required this.label, required this.colorToken, required this.seal});

  /// Human name. Tier is never carried by colour alone (ENG-05).
  final String label;

  /// Palette token name, or 'iridescent' for the shader tier.
  final String colorToken;

  /// Seal silhouette name, so tiers differ by shape as well as colour.
  final String seal;

  bool get isIridescent => colorToken == 'iridescent';
}

/// Palette tokens the iridescent tier drifts between.
const psIridescentDrift = <String>[${tokens.rarity.numberedLimited.drift.map((d) => `'${d}'`).join(', ')}];
`;
}

function dartType() {
  const fam = tokens.type.family;
  const styles = Object.entries(tokens.type.scale)
    .map(([k, s]) => {
      const feats = [];
      if (s.tabular) feats.push("FontFeature.tabularFigures()");
      return `  static const ${k} = PsTextSpec(
    family: PsFonts.${s.family},
    size: ${s.size},
    height: ${s.height},
    tracking: ${s.tracking},
    weight: ${s.weight},
    features: [${feats.join(', ')}],
    uppercase: ${s.uppercase ? 'true' : 'false'},
  );`;
    })
    .join('\n\n');
  return `// ${HEADER}
// dart format off
import 'dart:ui';

abstract final class PsFonts {
  static const display = '${fam.display}';
  static const text = '${fam.text}';
}

/// Colour-free text spec. Apply a palette colour in the theme layer.
class PsTextSpec {
  const PsTextSpec({
    required this.family,
    required this.size,
    required this.height,
    required this.tracking,
    required this.weight,
    required this.features,
    this.uppercase = false,
  });

  final String family;
  final double size;
  final double height;

  /// Letter spacing in em.
  final double tracking;
  final int weight;
  final List<FontFeature> features;

  /// Labels are set in uppercase with wide tracking. The fonts have no
  /// small-caps feature, so this is the honest equivalent (SPEC 3.2).
  final bool uppercase;
}

abstract final class PsType {
${styles}
}
`;
}

function dartMotion() {
  const c = tokens.motion.curve;
  const d = tokens.motion.durationMs;
  return `// ${HEADER}
// dart format off
import 'package:flutter/animation.dart';

abstract final class PsMotion {
  static const settle = Cubic(${c.settle.join(', ')});
  static const drawer = Cubic(${c.drawer.join(', ')});

  static const ui = Duration(milliseconds: ${d.ui});
  static const hero = Duration(milliseconds: ${d.hero});
  static const ceremony = Duration(milliseconds: ${d.ceremony});
}
`;
}

function dartSpace() {
  const sp = Object.entries(tokens.space).map(([k, v]) => `  static const double ${k} = ${v};`).join('\n');
  const rd = Object.entries(tokens.radius).map(([k, v]) => `  static const double ${k} = ${v};`).join('\n');
  return `// ${HEADER}
// dart format off
abstract final class PsSpace {
${sp}
  static const double minTouchTarget = ${tokens.layout.minTouchTarget};
  static const double gutter = ${tokens.layout.gutter};
}

abstract final class PsRadius {
${rd}
}
`;
}

// ---- Web ----
function webCss() {
  const block = (sel, t) =>
    `${sel} {\n${[...names, 'hairline']
      .map((n) => {
        const { hex, alpha } = resolveColor(t, n);
        const r = parseInt(hex.slice(1, 3), 16), g = parseInt(hex.slice(3, 5), 16), b = parseInt(hex.slice(5, 7), 16);
        return `  --ps-${n}: ${alpha === 1 ? hex : `rgb(${r} ${g} ${b} / ${alpha})`};`;
      })
      .join('\n')}\n}`;
  return `/* ${HEADER} */
${block(':root', 'nocturne')}

${block('[data-theme="atelier"]', 'atelier')}
`;
}

function webTheme() {
  const lines = [];
  for (const n of [...names, 'hairline']) lines.push(`  --color-${n}: var(--ps-${n});`);
  lines.push(`  --font-display: "${tokens.type.family.display}", Georgia, serif;`);
  lines.push(`  --font-text: "${tokens.type.family.text}", system-ui, sans-serif;`);
  for (const [k, c] of Object.entries(tokens.motion.curve)) lines.push(`  --ease-${k}: cubic-bezier(${c.join(', ')});`);
  for (const [k, v] of Object.entries(tokens.motion.durationMs)) lines.push(`  --duration-${k}: ${v}ms;`);
  for (const [k, s] of Object.entries(tokens.type.scale)) {
    lines.push(`  --text-${k}: ${s.size / 16}rem;`);
    lines.push(`  --text-${k}--line-height: ${s.height};`);
    lines.push(`  --text-${k}--letter-spacing: ${s.tracking}em;`);
    lines.push(`  --text-${k}--font-weight: ${s.weight};`);
  }
  for (const [k, v] of Object.entries(tokens.radius)) lines.push(`  --radius-${k}: ${v}px;`);
  return `\n@theme inline {\n${lines.join('\n')}\n}\n`;
}

const outputs = {
  'apps/mobile/lib/design/tokens/colors.dart': dartColors(),
  'apps/mobile/lib/design/tokens/rarity.dart': dartRarity(),
  'apps/mobile/lib/design/tokens/type.dart': dartType(),
  'apps/mobile/lib/design/tokens/motion.dart': dartMotion(),
  'apps/mobile/lib/design/tokens/space.dart': dartSpace(),
  'apps/admin/src/design/tokens.css': webCss() + webTheme(),
};

let stale = 0;
for (const [rel, content] of Object.entries(outputs)) {
  const p = resolve(root, rel);
  if (check) {
    if (!existsSync(p) || readFileSync(p, 'utf8') !== content) {
      console.error(`stale: ${rel}`);
      stale++;
    }
  } else {
    mkdirSync(dirname(p), { recursive: true });
    writeFileSync(p, content);
    console.log(`wrote ${rel}`);
  }
}
if (stale) process.exit(1);
