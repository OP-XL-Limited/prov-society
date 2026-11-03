// Design lint (SPEC section 11, rule 4). Fails on raw colours, Material
// colours, curves, icon fonts, literal fonts and visible stock Material
// widgets anywhere under lib/ except lib/design/tokens/.
//
// Usage: dart run tool/design_lint.dart [lib-dir]
import 'dart:io';

class Violation {
  const Violation(this.file, this.line, this.rule, this.text);

  final String file;
  final int line;
  final String rule;
  final String text;

  @override
  String toString() => '$file:$line  [$rule]  ${text.trim()}';
}

final _rules = <String, RegExp>{
  'raw-color': RegExp(r'(?<![A-Za-z0-9_])Color\('),
  'material-colors': RegExp(r'(?<![A-Za-z0-9_])Colors\.'),
  'curves': RegExp(r'(?<![A-Za-z0-9_])Curves\.'),
  'icon-font': RegExp(
    r'(?<![A-Za-z0-9_])(Icons|CupertinoIcons)\.|IconData\(|\bIcon\(',
  ),
  'literal-font': RegExp(r'''fontFamily:\s*['"]'''),
  'material-import': RegExp(
    r'''import\s+['"]package:flutter/(material|cupertino)\.dart['"]''',
  ),
  'default-material-widget': RegExp(
    '(?<![A-Za-z0-9_])(MaterialApp|CupertinoApp|Scaffold|AppBar|'
    'BottomNavigationBar|NavigationBar|ElevatedButton|TextButton|'
    'OutlinedButton|FilledButton|IconButton|FloatingActionButton|Card|'
    'AlertDialog|SimpleDialog|SnackBar|Chip|ActionChip|FilterChip|'
    'ChoiceChip|TextField|TextFormField|CircularProgressIndicator|'
    'LinearProgressIndicator|Switch|Checkbox|Radio|Slider|ListTile|Drawer|'
    'Divider|PopupMenuButton|DropdownButton|BottomSheet|CupertinoButton|'
    r'CupertinoAlertDialog|CupertinoSwitch|CupertinoTextField)\(',
  ),
};

/// Pure function so tests can prove each rule fires.
List<Violation> lintSource(String path, String source) {
  if (path.replaceAll(r'\', '/').contains('lib/design/tokens/')) return [];
  final out = <Violation>[];
  final lines = source.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trimLeft().startsWith('//')) continue;
    for (final rule in _rules.entries) {
      if (rule.value.hasMatch(line)) {
        out.add(Violation(path, i + 1, rule.key, line));
      }
    }
  }
  return out;
}

Future<void> main(List<String> args) async {
  final dir = Directory(args.isNotEmpty ? args.first : 'lib');
  final violations = <Violation>[];
  await for (final e in dir.list(recursive: true)) {
    if (e is! File || !e.path.endsWith('.dart')) continue;
    if (e.path.endsWith('.g.dart') ||
        e.path.endsWith('.freezed.dart') ||
        e.path.contains('lib/l10n/gen/')) {
      continue;
    }
    violations.addAll(lintSource(e.path, await e.readAsString()));
  }
  if (violations.isEmpty) {
    stdout.writeln('design lint: clean');
    return;
  }
  violations.forEach(stderr.writeln);
  stderr.writeln('design lint: ${violations.length} violation(s)');
  exitCode = 1;
}
