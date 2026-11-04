import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provenance_society/core/haptics.dart';
import 'package:provenance_society/design/components/app_icon.dart';
import 'package:provenance_society/design/components/ps_grain.dart';
import 'package:provenance_society/design/components/ps_tab_bar.dart';
import 'package:provenance_society/design/motion/ps_transitions.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/l10n/gen/app_localizations.dart';

/// Five-tab shell: Today, Vault, Society, Wanted, Me (NAV-01).
class ShellScreen extends ConsumerWidget {
  const ShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = PsTheme.of(context).palette;
    final items = [
      PsTabItem(kind: AppIconKind.calendarWear, label: l10n.tabToday),
      PsTabItem(kind: AppIconKind.vault, label: l10n.tabVault),
      PsTabItem(kind: AppIconKind.rankCrest, label: l10n.tabSociety),
      PsTabItem(kind: AppIconKind.wanted, label: l10n.tabWanted),
      PsTabItem(kind: AppIconKind.seal, label: l10n.tabMe),
    ];
    return ColoredBox(
      color: palette.ink,
      child: Stack(
        children: [
          const Positioned.fill(child: PsGrain()),
          Positioned.fill(
            child: PsTabFade(
              index: navigationShell.currentIndex,
              child: navigationShell,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PsTabBar(
              items: items,
              currentIndex: navigationShell.currentIndex,
              onSelected: (index) {
                if (index != navigationShell.currentIndex) {
                  unawaited(ref.read(hapticsProvider).light());
                }
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
