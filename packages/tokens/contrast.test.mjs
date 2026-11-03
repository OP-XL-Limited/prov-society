// DS-03 Contrast: every listed text/surface pair meets WCAG AA in both themes.
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const tokens = JSON.parse(readFileSync(resolve(dirname(fileURLToPath(import.meta.url)), 'tokens.json'), 'utf8'));

const lin = (c) => {
  const s = c / 255;
  return s <= 0.03928 ? s / 12.92 : ((s + 0.055) / 1.055) ** 2.4;
};
const lum = (hex) => {
  const [r, g, b] = [1, 3, 5].map((i) => lin(parseInt(hex.slice(i, i + 2), 16)));
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
};
const ratio = (a, b) => {
  const [hi, lo] = [lum(a), lum(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
};

for (const theme of ['nocturne', 'atelier']) {
  for (const { fg, bg, min } of tokens.contrast.pairs) {
    test(`DS-03 ${theme}: ${fg} on ${bg} meets ${min}:1`, () => {
      const r = ratio(tokens.color[theme][fg], tokens.color[theme][bg]);
      assert.ok(r >= min, `${theme} ${fg}/${bg} is ${r.toFixed(2)}:1`);
    });
  }
}

test('DS-01 hairline is derived from vellum, not a free colour', () => {
  for (const theme of ['nocturne', 'atelier']) {
    assert.equal(tokens.color[theme].hairline.base, 'vellum');
  }
});
