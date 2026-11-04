import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provenance_society/design/components/app_icon.dart';
import 'package:provenance_society/design/components/app_icon_shapes.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';

Widget host(PsThemeMode mode, Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: PsTheme(mode: mode, child: child),
);

void main() {
  test('DS-04 the required icon set of 17 is defined', () {
    expect(AppIconKind.values.map((k) => k.name).toSet(), {
      'vault',
      'bottle',
      'seal',
      'rankCrest',
      'recognition',
      'exhibition',
      'blindCircle',
      'wanted',
      'provenanceChain',
      'nfcCap',
      'compliment',
      'calendarWear',
      'dropletLevel',
      'sampleVial',
      'inviteKey',
      'walletCard',
      'settings',
    });
  });

  test('DS-04 every icon has a body that fits the unit square', () {
    for (final kind in AppIconKind.values) {
      final bounds = shapeFor(kind).body.getBounds();
      expect(bounds.isEmpty, isFalse, reason: kind.name);
      expect(bounds.left, greaterThanOrEqualTo(0), reason: kind.name);
      expect(bounds.top, greaterThanOrEqualTo(0), reason: kind.name);
      expect(bounds.right, lessThanOrEqualTo(1), reason: kind.name);
      expect(bounds.bottom, lessThanOrEqualTo(1), reason: kind.name);
    }
  });

  for (final mode in PsThemeMode.values) {
    testWidgets('DS-04 icon sheet golden in ${mode.name}', (tester) async {
      tester.view
        ..devicePixelRatio = 2
        ..physicalSize = const Size(1000, 760);
      addTearDown(tester.view.reset);
      final palette = PsTheme.paletteOf(mode);
      await tester.pumpWidget(
        host(
          mode,
          ColoredBox(
            color: palette.ink,
            child: Center(
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  for (final (i, kind) in AppIconKind.values.indexed)
                    AppIcon(
                      kind,
                      size: 64,
                      tint: AppIconTint.values[i % AppIconTint.values.length],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(ColoredBox).first,
        matchesGoldenFile('goldens/icons_${mode.name}.png'),
      );
    });
  }

  testWidgets('DS-04 no icon-font glyphs are used by AppIcon', (tester) async {
    await tester.pumpWidget(
      host(
        PsThemeMode.nocturne,
        const AppIcon(AppIconKind.bottle, semanticLabel: 'Bottle'),
      ),
    );
    expect(find.byType(material.Icon), findsNothing);
    expect(find.byType(Text), findsNothing);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('ENG-05 labelled icons are announced, decorative ones are not', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        PsThemeMode.nocturne,
        const Column(
          children: [
            AppIcon(AppIconKind.seal, semanticLabel: 'Verified seal'),
            AppIcon(AppIconKind.vault),
          ],
        ),
      ),
    );
    expect(find.bySemanticsLabel('Verified seal'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(AppIcon).first),
      matchesSemantics(label: 'Verified seal', isImage: true),
    );
    handle.dispose();
  });
}
