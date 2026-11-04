import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/components/app_icon.dart';
import 'package:provenance_society/design/components/ps_empty_state.dart';
import 'package:provenance_society/l10n/gen/app_localizations.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PsEmptyState(
      icon: AppIconKind.seal,
      label: l10n.meLabel,
      title: l10n.meTitle,
      body: l10n.meBody,
    );
  }
}
