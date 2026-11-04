import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/components/app_icon_shapes.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/tokens/colors.dart';

export 'package:provenance_society/design/components/app_icon_shapes.dart'
    show AppIconKind;

/// Palette tints for icons (SPEC 3.3).
enum AppIconTint { verdigris, oxblood, resin, vellum }

extension on PsTheme {
  Color tintColor(AppIconTint tint) => switch (tint) {
    AppIconTint.verdigris => palette.verdigris,
    AppIconTint.oxblood => palette.oxblood,
    AppIconTint.resin => palette.resin,
    // Vellum is the dark text colour in Atelier, which would render the
    // glyph flat black. Warm ash keeps the lacquer lighting visible.
    AppIconTint.vellum =>
      mode == PsThemeMode.atelier ? palette.ash : palette.vellum,
  };
}

/// The single entry point for every icon in the app. Placeholder 3D-style
/// glyphs are drawn here; final Blender renders and Rive files swap in behind
/// this widget without touching any screen (SPEC 3.3, phase 10).
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.kind, {
    this.size = 28,
    this.tint = AppIconTint.verdigris,
    this.semanticLabel,
    super.key,
  });

  final AppIconKind kind;
  final double size;
  final AppIconTint tint;

  /// Null marks the icon decorative and hides it from screen readers.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = PsTheme.of(context);
    final palette = theme.palette;
    final icon = SizedBox.square(
      dimension: size,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _IconPainter(shapeFor(kind), palette, theme.tintColor(tint)),
        ),
      ),
    );
    if (semanticLabel == null) return ExcludeSemantics(child: icon);
    return Semantics(label: semanticLabel, image: true, child: icon);
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.shape, this.palette, this.base);

  final IconShape shape;
  final PsPalette palette;
  final Color base;

  Color _lightness(Color c, double delta) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + delta).clamp(0.0, 1.0)).toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final scale = Matrix4.diagonal3Values(s, s, 1).storage;
    final body = shape.body.transform(scale);
    final bounds = body.getBounds();

    canvas
      // Drop shadow.
      ..drawPath(
        body.shift(Offset(0, s * 0.045)),
        Paint()
          ..color = palette.shadow.withValues(alpha: 0.5)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.04),
      )
      // Lit body: light from the upper left.
      ..drawPath(
        body,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_lightness(base, 0.14), base, _lightness(base, -0.2)],
            stops: const [0, 0.5, 1],
          ).createShader(bounds),
      );

    // Set-in details.
    final cutPaint = Paint()..color = Color.lerp(base, palette.shadow, 0.55)!;
    for (final cut in shape.cuts) {
      canvas.drawPath(cut.transform(scale), cutPaint);
    }
    final linePaint = Paint()
      ..color = palette.onAccent.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.05
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final line in shape.lines) {
      canvas.drawPath(line.transform(scale), linePaint);
    }

    // Rim and specular highlight, clipped to the body.
    canvas
      ..save()
      ..clipPath(body)
      ..drawPath(
        body,
        Paint()
          ..color = palette.onAccent.withValues(alpha: 0.32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.03,
      )
      ..drawOval(
        Rect.fromLTWH(
          bounds.left + bounds.width * 0.08,
          bounds.top + bounds.height * 0.04,
          bounds.width * 0.62,
          bounds.height * 0.3,
        ),
        Paint()
          ..shader =
              RadialGradient(
                colors: [
                  palette.onAccent.withValues(alpha: 0.5),
                  palette.onAccent.withValues(alpha: 0),
                ],
              ).createShader(
                Rect.fromLTWH(
                  bounds.left,
                  bounds.top,
                  bounds.width * 0.8,
                  bounds.height * 0.4,
                ),
              ),
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.shape != shape || old.palette != palette || old.base != base;
}
