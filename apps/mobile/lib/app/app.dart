import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/tokens/type.dart';
import 'package:provenance_society/l10n/gen/app_localizations.dart';

/// Root widget. Uses WidgetsApp, not MaterialApp, so no default Material
/// styling can leak in (SPEC section 3, PSY-15).
class PsApp extends StatelessWidget {
  const PsApp({this.mode = PsThemeMode.nocturne, super.key});

  final PsThemeMode mode;

  @override
  Widget build(BuildContext context) {
    final palette = PsTheme.paletteOf(mode).ink;
    return WidgetsApp(
      color: palette,
      onGenerateTitle: (c) => AppLocalizations.of(c).appName,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (c, _, _) => builder(c),
      ),
      builder: (context, _) => PsTheme(mode: mode, child: const _Boot()),
    );
  }
}

class _Boot extends StatelessWidget {
  const _Boot();

  @override
  Widget build(BuildContext context) {
    final theme = PsTheme.of(context);
    return ColoredBox(
      color: theme.palette.ink,
      child: Center(
        child: Text(
          AppLocalizations.of(context).bootTagline,
          textDirection: TextDirection.ltr,
          style: theme.style(PsType.titleM),
        ),
      ),
    );
  }
}
