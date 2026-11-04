import 'dart:math' as math;
import 'dart:ui';

/// Every icon in the required set (SPEC 3.3).
enum AppIconKind {
  vault,
  bottle,
  seal,
  rankCrest,
  recognition,
  exhibition,
  blindCircle,
  wanted,
  provenanceChain,
  nfcCap,
  compliment,
  calendarWear,
  dropletLevel,
  sampleVial,
  inviteKey,
  walletCard,
  settings,
}

/// A glyph in the unit square: a lit [body], darker [cuts] set into it and
/// light [lines] drawn on top.
class IconShape {
  const IconShape({
    required this.body,
    this.cuts = const [],
    this.lines = const [],
  });

  final Path body;
  final List<Path> cuts;
  final List<Path> lines;
}

Path _rr(double l, double t, double r, double b, double rad) =>
    Path()..addRRect(RRect.fromLTRBR(l, t, r, b, Radius.circular(rad)));

Path _circle(double cx, double cy, double r) =>
    Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));

Path _poly(List<double> xy) {
  final p = Path()..moveTo(xy[0], xy[1]);
  for (var i = 2; i < xy.length; i += 2) {
    p.lineTo(xy[i], xy[i + 1]);
  }
  return p..close();
}

Path _star(double cx, double cy, double r) {
  final p = Path();
  for (var i = 0; i < 10; i++) {
    final a = -math.pi / 2 + i * math.pi / 5;
    final rad = i.isEven ? r : r * 0.42;
    final x = cx + rad * math.cos(a);
    final y = cy + rad * math.sin(a);
    i == 0 ? p.moveTo(x, y) : p.lineTo(x, y);
  }
  return p..close();
}

Path _union(List<Path> parts) => parts.reduce(
  (a, b) => Path.combine(PathOperation.union, a, b),
);

Path _gear() {
  final p = Path();
  const teeth = 8;
  for (var i = 0; i < teeth; i++) {
    final base = i * 2 * math.pi / teeth;
    const step = 2 * math.pi / teeth;
    final pts = [
      (base - step * 0.30, 0.31),
      (base - step * 0.16, 0.43),
      (base + step * 0.16, 0.43),
      (base + step * 0.30, 0.31),
    ];
    for (final (a, r) in pts) {
      final x = 0.5 + r * math.cos(a);
      final y = 0.5 + r * math.sin(a);
      i == 0 && a == pts.first.$1 ? p.moveTo(x, y) : p.lineTo(x, y);
    }
  }
  return p..close();
}

Path _scallop() {
  final p = Path();
  const n = 160;
  for (var i = 0; i <= n; i++) {
    final a = i * 2 * math.pi / n;
    final r = 0.40 + 0.04 * math.cos(12 * a);
    final x = 0.5 + r * math.cos(a);
    final y = 0.5 + r * math.sin(a);
    i == 0 ? p.moveTo(x, y) : p.lineTo(x, y);
  }
  return p..close();
}

Path _arc(double cx, double cy, double r) => Path()
  ..addArc(
    Rect.fromCircle(center: Offset(cx, cy), radius: r),
    math.pi * 1.15,
    math.pi * 0.7,
  );

IconShape shapeFor(AppIconKind kind) => switch (kind) {
  AppIconKind.vault => IconShape(
    body: _rr(0.1, 0.1, 0.9, 0.9, 0.1),
    cuts: [_rr(0.2, 0.2, 0.8, 0.8, 0.05)],
    lines: [
      // Combination dial.
      Path()..addOval(
        Rect.fromCircle(center: const Offset(0.5, 0.5), radius: 0.13),
      ),
      // Door handle.
      Path()
        ..moveTo(0.7, 0.42)
        ..lineTo(0.7, 0.58),
    ],
  ),
  AppIconKind.bottle => IconShape(
    body: _union([
      _rr(0.38, 0.06, 0.62, 0.17, 0.03),
      _rr(0.43, 0.15, 0.57, 0.3, 0.03),
      _rr(0.24, 0.28, 0.76, 0.93, 0.1),
    ]),
    cuts: [_rr(0.34, 0.5, 0.66, 0.74, 0.03)],
  ),
  AppIconKind.seal => IconShape(
    body: _scallop(),
    cuts: [_circle(0.5, 0.5, 0.26)],
    lines: [
      Path()
        ..moveTo(0.38, 0.51)
        ..lineTo(0.47, 0.6)
        ..lineTo(0.64, 0.4),
    ],
  ),
  AppIconKind.rankCrest => IconShape(
    body: Path()
      ..moveTo(0.5, 0.06)
      ..lineTo(0.86, 0.2)
      ..lineTo(0.86, 0.5)
      ..cubicTo(0.86, 0.74, 0.68, 0.88, 0.5, 0.95)
      ..cubicTo(0.32, 0.88, 0.14, 0.74, 0.14, 0.5)
      ..lineTo(0.14, 0.2)
      ..close(),
    cuts: [
      _poly([0.5, 0.28, 0.63, 0.5, 0.5, 0.72, 0.37, 0.5]),
    ],
  ),
  AppIconKind.recognition => IconShape(
    body: _union([
      _circle(0.5, 0.38, 0.28),
      _poly([0.3, 0.6, 0.2, 0.94, 0.38, 0.84, 0.47, 0.95, 0.5, 0.6]),
      _poly([0.7, 0.6, 0.8, 0.94, 0.62, 0.84, 0.53, 0.95, 0.5, 0.6]),
    ]),
    cuts: [_star(0.5, 0.38, 0.16)],
  ),
  AppIconKind.exhibition => IconShape(
    body: _union([
      _rr(0.1, 0.12, 0.9, 0.76, 0.04),
      _rr(0.44, 0.74, 0.56, 0.9, 0.02),
      _rr(0.3, 0.88, 0.7, 0.95, 0.02),
    ]),
    cuts: [_rr(0.19, 0.21, 0.81, 0.67, 0.02)],
    lines: [
      Path()
        ..moveTo(0.26, 0.58)
        ..lineTo(0.42, 0.4)
        ..lineTo(0.54, 0.52)
        ..lineTo(0.64, 0.38)
        ..lineTo(0.76, 0.58),
    ],
  ),
  AppIconKind.blindCircle => IconShape(
    body: _circle(0.5, 0.5, 0.4),
    cuts: [
      Path.combine(
        PathOperation.difference,
        _circle(0.5, 0.5, 0.26),
        _circle(0.6, 0.45, 0.22),
      ),
    ],
  ),
  AppIconKind.wanted => IconShape(
    body: _poly([0.24, 0.08, 0.76, 0.08, 0.76, 0.94, 0.5, 0.74, 0.24, 0.94]),
    cuts: [
      _poly([0.5, 0.22, 0.6, 0.36, 0.5, 0.5, 0.4, 0.36]),
    ],
  ),
  AppIconKind.provenanceChain => IconShape(
    body: _union([
      _rr(0.05, 0.32, 0.58, 0.68, 0.17),
      _rr(0.42, 0.32, 0.95, 0.68, 0.17),
    ]),
    cuts: [
      _rr(0.14, 0.43, 0.46, 0.57, 0.07),
      _rr(0.54, 0.43, 0.86, 0.57, 0.07),
    ],
  ),
  AppIconKind.nfcCap => IconShape(
    body: _union([
      _rr(0.3, 0.1, 0.7, 0.3, 0.06),
      _rr(0.18, 0.26, 0.82, 0.93, 0.12),
    ]),
    // Signal arcs sit on the cap so they stay legible on any ground.
    lines: [_arc(0.5, 0.78, 0.1), _arc(0.5, 0.78, 0.2), _arc(0.5, 0.78, 0.3)],
  ),
  AppIconKind.compliment => IconShape(
    body: _union([
      _rr(0.08, 0.14, 0.92, 0.7, 0.16),
      _poly([0.24, 0.64, 0.18, 0.9, 0.52, 0.68]),
    ]),
    cuts: [
      _circle(0.32, 0.42, 0.06),
      _circle(0.5, 0.42, 0.06),
      _circle(0.68, 0.42, 0.06),
    ],
  ),
  AppIconKind.calendarWear => IconShape(
    body: _rr(0.1, 0.16, 0.9, 0.9, 0.1),
    cuts: [
      _rr(0.1, 0.16, 0.9, 0.36, 0.08),
      for (final y in [0.54, 0.72])
        for (final x in [0.3, 0.5, 0.7]) _circle(x, y, 0.045),
    ],
    lines: [
      Path()
        ..moveTo(0.32, 0.08)
        ..lineTo(0.32, 0.24)
        ..moveTo(0.68, 0.08)
        ..lineTo(0.68, 0.24),
    ],
  ),
  AppIconKind.dropletLevel => IconShape(
    body: Path()
      ..moveTo(0.5, 0.06)
      ..cubicTo(0.5, 0.06, 0.2, 0.44, 0.2, 0.64)
      ..cubicTo(0.2, 0.82, 0.34, 0.94, 0.5, 0.94)
      ..cubicTo(0.66, 0.94, 0.8, 0.82, 0.8, 0.64)
      ..cubicTo(0.8, 0.44, 0.5, 0.06, 0.5, 0.06)
      ..close(),
    lines: [
      Path()
        ..moveTo(0.27, 0.64)
        ..cubicTo(0.36, 0.57, 0.42, 0.71, 0.5, 0.64)
        ..cubicTo(0.58, 0.57, 0.64, 0.71, 0.73, 0.64),
    ],
  ),
  AppIconKind.sampleVial => IconShape(
    body: _union([
      _rr(0.4, 0.06, 0.6, 0.19, 0.03),
      _rr(0.44, 0.17, 0.56, 0.27, 0.02),
      _rr(0.34, 0.25, 0.66, 0.94, 0.1),
    ]),
    cuts: [_rr(0.39, 0.56, 0.61, 0.89, 0.06)],
  ),
  AppIconKind.inviteKey => IconShape(
    body: _union([
      _circle(0.27, 0.5, 0.21),
      _rr(0.4, 0.45, 0.93, 0.56, 0.03),
      _rr(0.72, 0.54, 0.8, 0.72, 0.015),
      _rr(0.84, 0.54, 0.92, 0.66, 0.015),
    ]),
    cuts: [_circle(0.27, 0.5, 0.09)],
  ),
  AppIconKind.walletCard => IconShape(
    body: _rr(0.06, 0.2, 0.94, 0.8, 0.08),
    cuts: [_rr(0.16, 0.34, 0.38, 0.5, 0.03)],
    lines: [
      Path()
        ..moveTo(0.16, 0.66)
        ..lineTo(0.6, 0.66),
    ],
  ),
  AppIconKind.settings => IconShape(
    body: _gear(),
    cuts: [_circle(0.5, 0.5, 0.14)],
  ),
};
