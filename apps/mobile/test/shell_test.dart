import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provenance_society/app/app.dart';
import 'package:provenance_society/core/haptics.dart';
import 'package:provenance_society/design/components/ps_glass.dart';
import 'package:provenance_society/design/components/ps_grain.dart';
import 'package:provenance_society/design/components/ps_tab_bar.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';

import 'support/pump_ps.dart';

class _RecordingHaptics implements PsHaptics {
  final calls = <String>[];

  @override
  Future<void> light() async => calls.add('light');

  @override
  Future<void> medium() async => calls.add('medium');

  @override
  Future<void> heavy() async => calls.add('heavy');
}

const tabs = ['Today', 'Vault', 'Society', 'Wanted', 'Me'];

/// The tab button itself, not the label text inside its excluded subtree.
Finder tab(String label) => find.byWidgetPredicate(
  (w) =>
      w is Semantics &&
      (w.properties.button ?? false) &&
      w.properties.label == label,
);

void main() {
  testWidgets('NAV-01 shows five tabs in order', (tester) async {
    await pumpPsApp(tester);
    final bar = tester.widget<PsTabBar>(find.byType(PsTabBar));
    expect(bar.items.map((i) => i.label), tabs);
  });

  testWidgets('DS-02 each theme paints its own ink ground', (tester) async {
    for (final mode in PsThemeMode.values) {
      await pumpPsApp(tester, mode: mode);
      final ground = tester.widget<ColoredBox>(
        find.byType(ColoredBox).first,
      );
      expect(ground.color, PsTheme.paletteOf(mode).ink);
    }
    expect(
      PsTheme.paletteOf(PsThemeMode.nocturne).ink,
      isNot(PsTheme.paletteOf(PsThemeMode.atelier).ink),
    );
  });

  testWidgets('NAV-01 uses no stock navigation bar', (tester) async {
    await pumpPsApp(tester);
    expect(find.byType(material.BottomNavigationBar), findsNothing);
    expect(find.byType(material.NavigationBar), findsNothing);
    expect(find.byType(PsTabBar), findsOneWidget);
  });

  testWidgets('NAV-01 bar is smoked glass with blur and grain', (tester) async {
    await pumpPsApp(tester);
    final glass = find.descendant(
      of: find.byType(PsTabBar),
      matching: find.byType(PsGlass),
    );
    expect(glass, findsOneWidget);
    expect(
      find.descendant(of: glass, matching: find.byType(BackdropFilter)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: glass, matching: find.byType(PsGrain)),
      findsOneWidget,
    );
  });

  testWidgets('NAV-01 floats above content with a gutter', (tester) async {
    await pumpPsApp(tester);
    final rect = tester.getRect(find.byType(PsTabBar));
    expect(rect.bottom, lessThanOrEqualTo(852));
    final glass = tester.getRect(find.byType(PsGlass));
    expect(glass.left, 20);
    expect(glass.right, 393 - 20);
  });

  testWidgets('NAV-01 tapping a tab switches screens', (tester) async {
    await pumpPsApp(tester);
    expect(find.text('Nothing worn yet.'), findsOneWidget);
    await tester.tap(tab('Vault'));
    await tester.pumpAndSettle();
    expect(find.text('The shelves are empty.'), findsOneWidget);
    await tester.tap(tab('Society'));
    await tester.pumpAndSettle();
    expect(find.text('Membership by invitation.'), findsOneWidget);
    await tester.tap(tab('Wanted'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing sought.'), findsOneWidget);
    await tester.tap(tab('Me'));
    await tester.pumpAndSettle();
    expect(find.text('Your profile is sealed.'), findsOneWidget);
  });

  testWidgets('NAV-01 selecting a tab gives one light haptic', (tester) async {
    final haptics = _RecordingHaptics();
    await pumpPsApp(
      tester,
      overrides: [hapticsProvider.overrideWithValue(haptics)],
    );
    await tester.tap(tab('Vault'));
    await tester.pumpAndSettle();
    expect(haptics.calls, ['light']);
    // Re-selecting the current tab is silent.
    await tester.tap(tab('Vault'));
    await tester.pumpAndSettle();
    expect(haptics.calls, ['light']);
  });

  testWidgets('ENG-05 every tab is at least 44 pt and labelled', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpPsApp(tester);
    for (final label in tabs) {
      final finder = tab(label);
      expect(finder, findsOneWidget, reason: label);
      final size = tester.getSize(finder);
      expect(size.width, greaterThanOrEqualTo(44), reason: label);
      expect(size.height, greaterThanOrEqualTo(44), reason: label);
      expect(
        tester.getSemantics(finder),
        matchesSemantics(
          label: label,
          isButton: true,
          hasTapAction: true,
          hasSelectedState: true,
          isSelected: label == 'Today',
        ),
      );
    }
    handle.dispose();
  });

  testWidgets('PSY-05 the shell carries no badges or counters', (tester) async {
    await pumpPsApp(tester);
    expect(find.byType(material.Badge), findsNothing);
    final bar = tester.widget<PsTabBar>(find.byType(PsTabBar));
    expect(bar.items.length, 5);
  });

  testWidgets('DS-05 reduced motion keeps tab changes a crossfade', (
    tester,
  ) async {
    await pumpPsApp(tester, reduceMotion: true);
    expect(PsTheme.reducedMotion(tester.element(find.byType(PsTabBar))), true);
    await tester.tap(tab('Vault'));
    await tester.pump(const Duration(milliseconds: 60));
    expect(find.byType(SlideTransition), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('The shelves are empty.'), findsOneWidget);
  });

  for (final mode in PsThemeMode.values) {
    for (final scale in [1.0, 2.0]) {
      final tag = '${mode.name}_x${scale.toStringAsFixed(0)}';
      for (final (index, name) in tabs.indexed) {
        testWidgets('DS-02 $name screen golden in $tag', (tester) async {
          await pumpPsApp(tester, mode: mode, textScale: scale);
          if (index > 0) {
            await tester.tap(tab(name));
            await tester.pumpAndSettle();
          }
          expect(tester.takeException(), isNull);
          await expectLater(
            find.byType(PsApp),
            matchesGoldenFile(
              'goldens/shell_${name.toLowerCase()}_$tag.png',
            ),
          );
        });
      }
    }
  }
}
