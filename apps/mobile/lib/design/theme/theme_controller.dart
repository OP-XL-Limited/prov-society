import 'package:provenance_society/design/theme/ps_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_controller.g.dart';

/// Active theme. Defaults to Nocturne; `--dart-define=PS_THEME=atelier`
/// starts in Atelier for screenshot review. Settings (ME-04) drives it later.
@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  @override
  PsThemeMode build() => const String.fromEnvironment('PS_THEME') == 'atelier'
      ? PsThemeMode.atelier
      : PsThemeMode.nocturne;

  PsThemeMode get mode => state;

  // ignore: use_setters_to_change_properties, a named command, not a setter.
  void select(PsThemeMode mode) => state = mode;
}
