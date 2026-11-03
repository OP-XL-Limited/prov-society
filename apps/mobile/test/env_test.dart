import 'package:flutter_test/flutter_test.dart';
import 'package:provenance_society/core/env.dart';

void main() {
  const empty = PsEnv(
    environment: 'local',
    supabaseUrl: '',
    supabaseAnonKey: '',
    revenueCatIosKey: '',
    revenueCatAndroidKey: '',
    forceMocks: false,
  );

  test('OPS-02 missing keys fall back to mocks', () {
    expect(empty.hasBackend, isFalse);
    expect(empty.useBackendMocks, isTrue);
    expect(empty.useBillingMocks, isTrue);
  });

  test('OPS-02 real keys use the backend unless mocks are forced', () {
    const keyed = PsEnv(
      environment: 'staging',
      supabaseUrl: 'https://example.supabase.co',
      supabaseAnonKey: 'anon',
      revenueCatIosKey: 'appl_x',
      revenueCatAndroidKey: '',
      forceMocks: false,
    );
    expect(keyed.useBackendMocks, isFalse);
    expect(keyed.useBillingMocks, isFalse);
  });
}
