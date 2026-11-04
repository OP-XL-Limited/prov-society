// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Active theme. Defaults to Nocturne; `--dart-define=PS_THEME=atelier`
/// starts in Atelier for screenshot review. Settings (ME-04) drives it later.

@ProviderFor(ThemeController)
final themeControllerProvider = ThemeControllerProvider._();

/// Active theme. Defaults to Nocturne; `--dart-define=PS_THEME=atelier`
/// starts in Atelier for screenshot review. Settings (ME-04) drives it later.
final class ThemeControllerProvider
    extends $NotifierProvider<ThemeController, PsThemeMode> {
  /// Active theme. Defaults to Nocturne; `--dart-define=PS_THEME=atelier`
  /// starts in Atelier for screenshot review. Settings (ME-04) drives it later.
  ThemeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeControllerHash();

  @$internal
  @override
  ThemeController create() => ThemeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PsThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PsThemeMode>(value),
    );
  }
}

String _$themeControllerHash() => r'0960d6b4341d5bff374cb7d54e5417993fbdb9ba';

/// Active theme. Defaults to Nocturne; `--dart-define=PS_THEME=atelier`
/// starts in Atelier for screenshot review. Settings (ME-04) drives it later.

abstract class _$ThemeController extends $Notifier<PsThemeMode> {
  PsThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PsThemeMode, PsThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PsThemeMode, PsThemeMode>,
              PsThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
