import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/tokens/colors.dart';
import 'package:provenance_society/design/tokens/type.dart';

enum PsThemeMode { nocturne, atelier }

/// Resolves tokens for the active theme. Screens read from here and never
/// branch on the theme mode themselves.
class PsTheme extends InheritedWidget {
  const PsTheme({required this.mode, required super.child, super.key});

  final PsThemeMode mode;

  PsPalette get palette => paletteOf(mode);

  static PsPalette paletteOf(PsThemeMode mode) =>
      mode == PsThemeMode.nocturne ? PsPalette.nocturne : PsPalette.atelier;

  /// Builds a text style from a token spec. Fonts are variable, so weight and
  /// (for the display serif) optical size are set as axes.
  TextStyle style(PsTextSpec spec, {Color? color}) => TextStyle(
    fontFamily: spec.family,
    fontSize: spec.size,
    height: spec.height,
    letterSpacing: spec.size * spec.tracking,
    fontWeight: FontWeight.values[(spec.weight ~/ 100) - 1],
    fontVariations: [
      FontVariation('wght', spec.weight.toDouble()),
      if (spec.family == PsFonts.display)
        FontVariation('opsz', spec.size.clamp(9, 144).toDouble()),
    ],
    fontFeatures: spec.features,
    color: color ?? palette.vellum,
    decoration: TextDecoration.none,
  );

  static PsTheme of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<PsTheme>();
    assert(theme != null, 'PsTheme missing above this widget.');
    return theme!;
  }

  /// True when the OS asks for reduced motion (DS-05).
  static bool reducedMotion(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  @override
  bool updateShouldNotify(PsTheme oldWidget) => mode != oldWidget.mode;
}
