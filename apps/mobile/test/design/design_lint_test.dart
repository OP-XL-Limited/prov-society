import 'package:flutter_test/flutter_test.dart';

import '../../tool/design_lint.dart';

List<String> rules(String src, [String path = 'lib/features/x/a.dart']) =>
    lintSource(path, src).map((v) => v.rule).toList();

void main() {
  test('DS-01 flags raw Color( outside tokens', () {
    expect(rules('final c = Color(0xFF000000);'), ['raw-color']);
  });
  test('DS-01 flags Colors. outside tokens', () {
    expect(rules('final c = Colors.red;'), ['material-colors']);
  });
  test('DS-01 flags Curves. outside tokens', () {
    expect(rules('curve: Curves.easeIn,'), ['curves']);
  });
  test('DS-01 flags literal font families', () {
    expect(rules("TextStyle(fontFamily: 'Roboto')"), ['literal-font']);
  });
  test('DS-04 flags Icons., CupertinoIcons. and Icon(', () {
    expect(rules('Icons.add'), ['icon-font']);
    expect(rules('CupertinoIcons.home'), ['icon-font']);
    expect(rules('const Icon(x)'), ['icon-font']);
  });
  test('DS-01 flags material and cupertino imports', () {
    expect(
      rules("import 'package:flutter/material.dart';"),
      ['material-import'],
    );
  });
  test('NAV-01 flags BottomNavigationBar and other default widgets', () {
    expect(rules('BottomNavigationBar('), ['default-material-widget']);
    expect(rules('ElevatedButton('), ['default-material-widget']);
    expect(rules('CircularProgressIndicator('), ['default-material-widget']);
  });
  test('DS-01 allows the tokens folder', () {
    expect(
      rules('Color(0xFF000000)', 'apps/mobile/lib/design/tokens/colors.dart'),
      isEmpty,
    );
  });
  test('DS-01 does not flag token-named widgets or comments', () {
    expect(rules('PsCard('), isEmpty);
    expect(rules('// Colors.red is banned'), isEmpty);
    expect(rules('PsColors.ink'), isEmpty);
  });
}
