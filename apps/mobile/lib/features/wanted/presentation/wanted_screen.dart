import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/components/app_icon.dart';
import 'package:provenance_society/design/components/ps_empty_state.dart';
import 'package:provenance_society/l10n/gen/app_localizations.dart';

class WantedScreen extends StatelessWidget {
  const WantedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PsEmptyState(
      icon: AppIconKind.wanted,
      tint: AppIconTint.resin,
      label: l10n.wantedLabel,
      title: l10n.wantedTitle,
      body: l10n.wantedBody,
    );
  }
}
