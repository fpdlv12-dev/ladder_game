// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ghost Leg';

  @override
  String get onboardingHeadline => 'Who gets picked?\nLet the ladder decide';

  @override
  String get onboardingBody =>
      'Type the players and the outcomes, then climb the ladder.\nWinner, loser, turn order, penalties — decide anything fairly.\nNo sign-in, no data collection.';

  @override
  String get start => 'Get started';

  @override
  String get players => 'Players';

  @override
  String playerCount(int n) {
    return '$n players';
  }

  @override
  String get playerRange => '2–10 players';

  @override
  String get nameHint => 'Name';

  @override
  String get results => 'Outcomes';

  @override
  String get resultHint => 'Outcome';

  @override
  String get presetWinner => '1 winner';

  @override
  String get presetLoser => '1 loser';

  @override
  String get presetRank => 'Ranking';

  @override
  String get presetCustom => 'Custom';

  @override
  String get winner => 'WIN';

  @override
  String get loser => 'LOSE';

  @override
  String rankN(int n) {
    return '#$n';
  }

  @override
  String get startGame => 'Climb the ladder';

  @override
  String get resetNames => 'Reset names';

  @override
  String get ladderTitle => 'Ladder';

  @override
  String get tapNameHint => 'Tap a name at the top to climb';

  @override
  String get revealAll => 'Run all';

  @override
  String get showResults => 'Show outcomes';

  @override
  String get hideResults => 'Hide outcomes';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get newGame => 'New game';

  @override
  String get resultSummary => 'Results';

  @override
  String get copyResults => 'Copy results';

  @override
  String get copied => 'Results copied';

  @override
  String get close => 'Close';

  @override
  String get shareText => '[Ghost Leg results]';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGame => 'Game';

  @override
  String get settingsAnimSpeed => 'Climb speed';

  @override
  String get speedSlow => 'Slow';

  @override
  String get speedNormal => 'Normal';

  @override
  String get speedFast => 'Fast';

  @override
  String get settingsRevealResults => 'Show outcomes from the start';

  @override
  String get settingsRevealResultsSubtitle =>
      'When off, outcomes below the ladder are hidden as ?';

  @override
  String get settingsSound => 'Sound effects';

  @override
  String get settingsAbout => 'About';

  @override
  String settingsVersion(String v) {
    return 'Version $v';
  }

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsLicenses => 'Open source licenses';

  @override
  String get settingsDataNote =>
      'This app collects no personal data. Names and outcomes are kept only on your device for convenience.';
}
