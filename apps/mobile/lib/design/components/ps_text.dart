import 'package:flutter/widgets.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/tokens/type.dart';

/// Token-driven text. Labels set in uppercase per the type scale.
class PsText extends StatelessWidget {
  const PsText(
    this.data,
    this.spec, {
    this.color,
    this.textAlign,
    this.maxLines,
    this.semanticsLabel,
    super.key,
  });

  final String data;
  final PsTextSpec spec;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = PsTheme.of(context);
    // Display type is already large: cap its scale so words never break
    // mid-word at the largest Dynamic Type (UX-02). Body text scales fully.
    final scaler = spec.family == PsFonts.display
        ? MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.25)
        : null;
    return Text(
      spec.uppercase ? data.toUpperCase() : data,
      style: theme.style(spec, color: color),
      textScaler: scaler,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      semanticsLabel: semanticsLabel ?? data,
    );
  }
}
