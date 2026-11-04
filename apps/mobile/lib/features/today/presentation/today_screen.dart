import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/components/app_icon.dart';
import 'package:provenance_society/design/components/ps_empty_state.dart';
import 'package:provenance_society/l10n/gen/app_localizations.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PsEmptyState(
      icon: AppIconKind.calendarWear,
      label: l10n.todayLabel,
      title: l10n.todayTitle,
      body: l10n.todayBody,
    );
  }
}
