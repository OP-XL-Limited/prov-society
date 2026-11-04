import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/tokens/motion.dart';

/// Detail sheets rise like a drawer while the screen behind scales down a
/// little (SPEC 3.5). With reduced motion on, this becomes a crossfade
/// (DS-05).
Widget psDrawerTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  if (PsTheme.reducedMotion(context)) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: PsMotion.settle),
      child: child,
    );
  }
  final slide = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: animation, curve: PsMotion.drawer));
  final recede = Tween<double>(begin: 1, end: 0.94).animate(
    CurvedAnimation(parent: secondaryAnimation, curve: PsMotion.drawer),
  );
  return ScaleTransition(
    scale: recede,
    child: SlideTransition(position: slide, child: child),
  );
}

/// Crossfades between tabs. Heavy and deliberate: slow to start, soft to
/// land. Under reduced motion it is still a crossfade, never a slide.
class PsTabFade extends StatefulWidget {
  const PsTabFade({required this.index, required this.child, super.key});

  final int index;
  final Widget child;

  @override
  State<PsTabFade> createState() => _PsTabFadeState();
}

class _PsTabFadeState extends State<PsTabFade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: PsMotion.ui,
    value: 1,
  );

  @override
  void didUpdateWidget(PsTabFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: CurvedAnimation(parent: _controller, curve: PsMotion.settle),
    child: widget.child,
  );
}
