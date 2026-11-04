import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Goldens are drawn with bundled fonts, but glyph rasterisation differs a
/// little between macOS (where they are recorded) and Linux CI. Measured on
/// the first CI run: 0% to 0.5% at default text size and 1.1% to 1.3% at 2x,
/// where body text covers more pixels. 2% still fails on a missing hero
/// icon (about 3.7% of the screen) or any colour or layout change; finer
/// structure is covered by the semantics and widget tests.
const goldenTolerance = 0.02;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final base = goldenFileComparator as LocalFileComparator;
  goldenFileComparator = _TolerantComparator(
    Uri.parse('${base.basedir}flutter_test_config.dart'),
  );
  await testMain();
}

class _TolerantComparator extends LocalFileComparator {
  _TolerantComparator(super.testFile);

  @override
  Future<bool> compare(List<int> imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= goldenTolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
