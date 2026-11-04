// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'haptics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(haptics)
final hapticsProvider = HapticsProvider._();

final class HapticsProvider
    extends $FunctionalProvider<PsHaptics, PsHaptics, PsHaptics>
    with $Provider<PsHaptics> {
  HapticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hapticsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hapticsHash();

  @$internal
  @override
  $ProviderElement<PsHaptics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PsHaptics create(Ref ref) {
    return haptics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PsHaptics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PsHaptics>(value),
    );
  }
}

String _$hapticsHash() => r'f8c4eea2abae914f010d7d827b41c65b38d0af7f';
