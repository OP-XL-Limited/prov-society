// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Provenance Society';

  @override
  String get tabToday => 'Today';

  @override
  String get tabVault => 'Vault';

  @override
  String get tabSociety => 'Society';

  @override
  String get tabWanted => 'Wanted';

  @override
  String get tabMe => 'Me';

  @override
  String get todayLabel => 'Today';

  @override
  String get todayTitle => 'Nothing worn yet.';

  @override
  String get todayBody =>
      'The morning\'s choice will be set here once your Vault holds a bottle.';

  @override
  String get vaultLabel => 'The Vault';

  @override
  String get vaultTitle => 'The shelves are empty.';

  @override
  String get vaultBody => 'Bottles you add are kept here, private by default.';

  @override
  String get societyLabel => 'The Society';

  @override
  String get societyTitle => 'Membership by invitation.';

  @override
  String get societyBody =>
      'Exhibitions and recognitions appear here for members.';

  @override
  String get wantedLabel => 'Wanted';

  @override
  String get wantedTitle => 'Nothing sought.';

  @override
  String get wantedBody =>
      'Bottles you are looking for are listed here, with a note when one is verified.';

  @override
  String get meLabel => 'Member';

  @override
  String get meTitle => 'Your profile is sealed.';

  @override
  String get meBody => 'What others may see is yours to decide.';
}
