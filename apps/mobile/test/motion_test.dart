import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provenance_society/design/motion/ps_transitions.dart';
import 'package:provenance_society/design/tokens/motion.dart';

import 'support/pump_ps.dart';

Widget _host({required bool reduce, required Animation<double> a}) =>
    MediaQuery(
      data: MediaQueryData(disableAnimations: reduce),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) => psDrawerTransition(
            context,
            a,
            const AlwaysStoppedAnimation(0),
            const SizedBox(),
          ),
        ),
      ),
    );

void main() {
  testWidgets('NAV-02 drawer transition slides up and recedes the screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(reduce: false, a: const AlwaysStoppedAnimation(0.5)),
    );
    expect(find.byType(SlideTransition), findsOneWidget);
    expect(find.byType(ScaleTransition), findsOneWidget);
    expect(find.byType(FadeTransition), findsNothing);
  });

  testWidgets('DS-05 reduced motion turns the drawer into a crossfade', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(reduce: true, a: const AlwaysStoppedAnimation(0.5)),
    );
    expect(find.byType(FadeTransition), findsOneWidget);
    expect(find.byType(SlideTransition), findsNothing);
    expect(find.byType(ScaleTransition), findsNothing);
  });

  test('DS-01 motion tokens match SPEC 3.5', () {
    expect(PsMotion.settle, const Cubic(0.2, 0, 0, 1));
    expect(PsMotion.drawer, const Cubic(0.32, 0.72, 0, 1));
    expect(PsMotion.ui, const Duration(milliseconds: 280));
    expect(PsMotion.hero, const Duration(milliseconds: 520));
    expect(PsMotion.ceremony, const Duration(milliseconds: 900));
  });

  testWidgets('DS-05 the OS reduced motion flag reaches the app', (
    tester,
  ) async {
    await pumpPsApp(tester, reduceMotion: true);
    final ctx = tester.element(find.byType(Directionality).first);
    expect(MediaQuery.disableAnimationsOf(ctx), isTrue);
  });
}
