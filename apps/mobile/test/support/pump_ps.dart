import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:provenance_society/app/app.dart';
import 'package:provenance_society/design/components/ps_grain.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/theme/theme_controller.dart';

/// iPhone 16 logical size and safe areas.
const _size = Size(393, 852);
const _top = 59.0;
const _bottom = 34.0;

Future<void> loadPsFonts() async {
  for (final (family, path) in [
    ('Fraunces', 'assets/fonts/Fraunces.ttf'),
    ('Inter Tight', 'assets/fonts/InterTight.ttf'),
  ]) {
    final loader = FontLoader(family)..addFont(rootBundle.load(path));
    await loader.load();
  }
}

/// Configures the test view like an iPhone, with optional text scale and
/// reduced motion, then mounts the real app.
Future<ProviderContainer> pumpPsApp(
  WidgetTester tester, {
  PsThemeMode mode = PsThemeMode.nocturne,
  double textScale = 1,
  bool reduceMotion = false,
  List<Override> overrides = const [],
}) async {
  const dpr = 3.0;
  tester.view
    ..devicePixelRatio = dpr
    ..physicalSize = _size * dpr
    ..padding = const FakeViewPadding(top: _top * dpr, bottom: _bottom * dpr)
    ..viewPadding = const FakeViewPadding(
      top: _top * dpr,
      bottom: _bottom * dpr,
    );
  tester.platformDispatcher
    ..textScaleFactorTestValue = textScale
    ..accessibilityFeaturesTestValue = FakeAccessibilityFeatures(
      disableAnimations: reduceMotion,
    );
  addTearDown(() {
    tester.view
      ..resetPhysicalSize()
      ..resetDevicePixelRatio()
      ..resetPadding()
      ..resetViewPadding();
    tester.platformDispatcher
      ..clearTextScaleFactorTestValue()
      ..clearAccessibilityFeaturesTestValue();
  });

  await loadPsFonts();
  await tester.runAsync(() => PsGrainTexture.load(mode));

  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  container.read(themeControllerProvider.notifier).select(mode);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const PsApp()),
  );
  await tester.pumpAndSettle();
  return container;
}
