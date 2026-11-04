// GENERATED FILE. Edit packages/tokens/tokens.json and run `npm run tokens`.
// dart format off
import 'dart:ui';

abstract final class PsFonts {
  static const display = 'Fraunces';
  static const text = 'Inter Tight';
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
  static const displayXL = PsTextSpec(
    family: PsFonts.display,
    size: 44,
    height: 1.05,
    tracking: -0.03,
    weight: 400,
    features: [],
    uppercase: false,
  );

  static const displayL = PsTextSpec(
    family: PsFonts.display,
    size: 32,
    height: 1.1,
    tracking: -0.02,
    weight: 400,
    features: [],
    uppercase: false,
  );

  static const titleM = PsTextSpec(
    family: PsFonts.display,
    size: 22,
    height: 1.2,
    tracking: -0.01,
    weight: 400,
    features: [],
    uppercase: false,
  );

  static const bodyM = PsTextSpec(
    family: PsFonts.text,
    size: 16,
    height: 1.5,
    tracking: 0,
    weight: 400,
    features: [],
    uppercase: false,
  );

  static const labelS = PsTextSpec(
    family: PsFonts.text,
    size: 11,
    height: 1.3,
    tracking: 0.12,
    weight: 500,
    features: [],
    uppercase: true,
  );

  static const numeralL = PsTextSpec(
    family: PsFonts.text,
    size: 28,
    height: 1.1,
    tracking: -0.01,
    weight: 300,
    features: [FontFeature.tabularFigures()],
    uppercase: false,
  );
}
