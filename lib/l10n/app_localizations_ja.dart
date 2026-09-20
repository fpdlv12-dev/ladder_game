// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'あみだくじ';

  @override
  String get onboardingHeadline => '誰が当たる?\nあみだくじで決めよう';

  @override
  String get onboardingBody =>
      '参加者と結果を入力して、あみだをたどるだけ。\n当たり・はずれ・順番・罰ゲーム、何でも公平に決められます。\nログインもデータ収集もありません。';

  @override
  String get start => 'はじめる';

  @override
  String get players => '参加者';

  @override
  String playerCount(int n) {
    return '$n人';
  }

  @override
  String get playerRange => '2〜10人';

  @override
  String get nameHint => '名前';

  @override
  String get results => '結果';

  @override
  String get resultHint => '結果';

  @override
  String get presetWinner => '当たり1つ';

  @override
  String get presetLoser => 'はずれ1つ';

  @override
  String get presetRank => '順位';

  @override
  String get presetCustom => '自由入力';

  @override
  String get winner => '当たり';

  @override
  String get loser => 'はずれ';

  @override
  String rankN(int n) {
    return '$n位';
  }

  @override
  String get startGame => 'あみだを引く';

  @override
  String get resetNames => '名前をリセット';

  @override
  String get ladderTitle => 'あみだ';

  @override
  String get tapNameHint => '上の名前をタップするとたどります';

  @override
  String get revealAll => '全員たどる';

  @override
  String get showResults => '結果を表示';

  @override
  String get hideResults => '結果を隠す';

  @override
  String get shuffle => '引き直す';

  @override
  String get newGame => '新しいゲーム';

  @override
  String get resultSummary => '結果';

  @override
  String get copyResults => '結果をコピー';

  @override
  String get copied => '結果をコピーしました';

  @override
  String get close => '閉じる';

  @override
  String get shareText => '[あみだくじの結果]';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsGame => 'ゲーム';

  @override
  String get settingsAnimSpeed => 'たどる速さ';

  @override
  String get speedSlow => 'ゆっくり';

  @override
  String get speedNormal => 'ふつう';

  @override
  String get speedFast => '速く';

  @override
  String get settingsRevealResults => '結果を最初から表示';

  @override
  String get settingsRevealResultsSubtitle => 'オフにすると下の結果が ? で隠れます';

  @override
  String get settingsSound => '効果音';

  @override
  String get settingsAbout => 'アプリ情報';

  @override
  String settingsVersion(String v) {
    return 'バージョン $v';
  }

  @override
  String get settingsPrivacy => 'プライバシーポリシー';

  @override
  String get settingsLicenses => 'オープンソースライセンス';

  @override
  String get settingsDataNote => 'このアプリは個人情報を収集しません。名前と結果は利便性のため端末内にのみ保存されます。';
}
