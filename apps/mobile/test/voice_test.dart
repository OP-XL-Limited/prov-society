import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final arb =
      jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
          as Map<String, dynamic>;
  final strings = {
    for (final e in arb.entries)
      if (!e.key.startsWith('@') && e.value is String) e.key: e.value as String,
  };

  test('PSY-08 copy has no exclamation marks or emoji', () {
    final emoji = RegExp(
      r'[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}\u{2B00}-\u{2BFF}]',
      unicode: true,
    );
    for (final e in strings.entries) {
      expect(e.value.contains('!'), isFalse, reason: e.key);
      expect(emoji.hasMatch(e.value), isFalse, reason: e.key);
    }
  });

  test('PSY-08 copy avoids the words the house does not use', () {
    final banned = RegExp(
      r'\b(app|users?|download|deal|discount|hack|amazing|awesome|'
      r'game-changer)\b',
      caseSensitive: false,
    );
    for (final e in strings.entries) {
      expect(banned.hasMatch(e.value), isFalse, reason: e.key);
    }
  });

  test('PSY-08 no copy mentions prices, values or location', () {
    final banned = RegExp(r'\b(price|value|worth|location|\$)\b|\$');
    for (final e in strings.entries) {
      expect(banned.hasMatch(e.value.toLowerCase()), isFalse, reason: e.key);
    }
  });
}
