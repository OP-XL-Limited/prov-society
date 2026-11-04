import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provenance_society/features/me/presentation/me_screen.dart';
import 'package:provenance_society/features/shell/presentation/shell_screen.dart';
import 'package:provenance_society/features/society/presentation/society_screen.dart';
import 'package:provenance_society/features/today/presentation/today_screen.dart';
import 'package:provenance_society/features/vault/presentation/vault_screen.dart';
import 'package:provenance_society/features/wanted/presentation/wanted_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

abstract final class PsRoutes {
  static const today = '/today';
  static const vault = '/vault';
  static const society = '/society';
  static const wanted = '/wanted';
  static const me = '/me';
}

GoRoute _tab(String path, Widget screen) => GoRoute(
  path: path,
  pageBuilder: (context, state) =>
      NoTransitionPage<void>(key: state.pageKey, child: screen),
);

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) => GoRouter(
  // PS_ROUTE lets screenshot review open a given tab directly.
  initialLocation: const String.fromEnvironment(
    'PS_ROUTE',
    defaultValue: PsRoutes.today,
  ),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => ShellScreen(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [_tab(PsRoutes.today, const TodayScreen())],
        ),
        StatefulShellBranch(
          routes: [_tab(PsRoutes.vault, const VaultScreen())],
        ),
        StatefulShellBranch(
          routes: [_tab(PsRoutes.society, const SocietyScreen())],
        ),
        StatefulShellBranch(
          routes: [_tab(PsRoutes.wanted, const WantedScreen())],
        ),
        StatefulShellBranch(routes: [_tab(PsRoutes.me, const MeScreen())]),
      ],
    ),
  ],
);
