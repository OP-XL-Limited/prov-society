import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provenance_society/app/app.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/tokens/colors.dart';

void main() {
  for (final mode in PsThemeMode.values) {
    testWidgets('DS-02 boot screen renders in ${mode.name}', (tester) async {
      await tester.pumpWidget(PsApp(mode: mode));
      await tester.pump();
      expect(find.text('Membership by invitation.'), findsOneWidget);
      final box = tester.widget<ColoredBox>(find.byType(ColoredBox).last);
      final expected = mode == PsThemeMode.nocturne
          ? PsPalette.nocturne.ink
          : PsPalette.atelier.ink;
      expect(box.color, expected);
    });
  }
}
