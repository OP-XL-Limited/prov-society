import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Goldens are drawn with bundled fonts, but font rasterisation differs a
/// little between macOS and Linux CI. Allow a small pixel difference so the
/// suite still fails on any real layout or colour change.
const goldenTolerance = 0.01;

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
