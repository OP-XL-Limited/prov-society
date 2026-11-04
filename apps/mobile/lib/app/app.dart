import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provenance_society/app/router.dart';
import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:provenance_society/design/theme/theme_controller.dart';
import 'package:provenance_society/l10n/gen/app_localizations.dart';

/// Root widget. Uses WidgetsApp, not MaterialApp, so no default Material
/// styling can leak in (SPEC section 3, PSY-15).
class PsApp extends ConsumerWidget {
  const PsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeControllerProvider);
    return WidgetsApp.router(
      debugShowCheckedModeBanner: false,
      color: PsTheme.paletteOf(mode).ink,
      routerConfig: ref.watch(routerProvider),
      onGenerateTitle: (c) => AppLocalizations.of(c).appName,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => PsTheme(
        mode: mode,
        child: ColoredBox(
          color: PsTheme.paletteOf(mode).ink,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
