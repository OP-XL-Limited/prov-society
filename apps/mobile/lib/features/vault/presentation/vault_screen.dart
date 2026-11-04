import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/components/app_icon.dart';
import 'package:provenance_society/design/components/ps_empty_state.dart';
import 'package:provenance_society/l10n/gen/app_localizations.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PsEmptyState(
      icon: AppIconKind.vault,
      label: l10n.vaultLabel,
      title: l10n.vaultTitle,
      body: l10n.vaultBody,
    );
  }
}
