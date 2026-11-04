import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/components/ps_grain.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/tokens/space.dart';

/// Smoked-glass panel (SPEC 3.4): blur, grain and a 1px top highlight.
class PsGlass extends StatelessWidget {
  const PsGlass({
    required this.child,
    this.radius = PsRadius.panel,
    this.blur = 18,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final Widget child;
  final double radius;
  final double blur;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final palette = PsTheme.of(context).palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(color: palette.smoke.withValues(alpha: 0.72)),
            ),
            const Positioned.fill(child: PsGrain()),
            Positioned(
              top: 0,
              left: radius,
              right: radius,
              height: 1,
              child: ColoredBox(
                color: palette.vellum.withValues(alpha: 0.18),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(color: palette.hairline),
                ),
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}
