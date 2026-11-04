import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/components/app_icon.dart';
import 'package:provenance_society/design/components/ps_text.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/tokens/space.dart';
import 'package:provenance_society/design/tokens/type.dart';

/// A composed empty state in the voice of the house (UX-01, PSY-01): an
/// object, a small-caps label, a serif line and one quiet sentence.
class PsEmptyState extends StatelessWidget {
  const PsEmptyState({
    required this.icon,
    required this.label,
    required this.title,
    required this.body,
    this.tint = AppIconTint.verdigris,
    super.key,
  });

  final AppIconKind icon;
  final AppIconTint tint;
  final String label;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final palette = PsTheme.of(context).palette;
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          PsSpace.gutter,
          PsSpace.xl,
          PsSpace.gutter,
          // Clears the floating tab bar.
          140,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PsText(label, PsType.labelS, color: palette.ash),
            const SizedBox(height: PsSpace.s),
            ColoredBox(
              color: palette.hairline,
              child: const SizedBox(width: double.infinity, height: 1),
            ),
            const SizedBox(height: PsSpace.xxl),
            Center(child: AppIcon(icon, size: 112, tint: tint)),
            const SizedBox(height: PsSpace.xxl),
            PsText(title, PsType.displayL),
            const SizedBox(height: PsSpace.m),
            PsText(body, PsType.bodyM, color: palette.ash),
          ],
        ),
      ),
    );
  }
}
