import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/components/app_icon.dart';
import 'package:provenance_society/design/components/ps_empty_state.dart';
import 'package:provenance_society/l10n/gen/app_localizations.dart';

class SocietyScreen extends StatelessWidget {
  const SocietyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PsEmptyState(
      icon: AppIconKind.rankCrest,
      tint: AppIconTint.oxblood,
      label: l10n.societyLabel,
      title: l10n.societyTitle,
      body: l10n.societyBody,
    );
  }
}
