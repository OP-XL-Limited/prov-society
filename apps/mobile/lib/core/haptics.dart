import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'haptics.g.dart';

/// Haptic vocabulary (SPEC 3.5): light for selection, medium for logging a
/// wear, heavy only for verification and rank-up (PSY-06).
abstract class PsHaptics {
  Future<void> light();
  Future<void> medium();
  Future<void> heavy();
}

class SystemHaptics implements PsHaptics {
  const SystemHaptics();

  @override
  Future<void> light() => HapticFeedback.selectionClick();

  @override
  Future<void> medium() => HapticFeedback.mediumImpact();

  @override
  Future<void> heavy() => HapticFeedback.heavyImpact();
}

@Riverpod(keepAlive: true)
PsHaptics haptics(Ref ref) => const SystemHaptics();
