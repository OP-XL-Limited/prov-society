/// Build-time configuration, injected with --dart-define-from-file (OPS-01).
/// Only the Supabase anon key and public SDK keys may appear here (SECX-03).
class PsEnv {
  const PsEnv({
    required this.environment,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.revenueCatIosKey,
    required this.revenueCatAndroidKey,
    required this.forceMocks,
  });

  factory PsEnv.fromEnvironment() => const PsEnv(
    environment: String.fromEnvironment('PS_ENV', defaultValue: 'local'),
    supabaseUrl: String.fromEnvironment('PS_SUPABASE_URL'),
    supabaseAnonKey: String.fromEnvironment('PS_SUPABASE_ANON_KEY'),
    revenueCatIosKey: String.fromEnvironment('PS_REVENUECAT_IOS_KEY'),
    revenueCatAndroidKey: String.fromEnvironment('PS_REVENUECAT_ANDROID_KEY'),
    forceMocks: bool.fromEnvironment('PS_USE_MOCKS', defaultValue: true),
  );

  final String environment;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String revenueCatIosKey;
  final String revenueCatAndroidKey;
  final bool forceMocks;

  bool get hasBackend => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Backend features fall back to mock repositories until keys exist, and
  /// every such fallback is listed in docs/PROGRESS.md.
  bool get useBackendMocks => forceMocks || !hasBackend;

  bool get useBillingMocks =>
      forceMocks || revenueCatIosKey.isEmpty && revenueCatAndroidKey.isEmpty;
}
