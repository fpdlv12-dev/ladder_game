// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '画鬼脚';

  @override
  String get onboardingHeadline => '谁会中?\n让鬼脚图来决定';

  @override
  String get onboardingBody =>
      '输入参与者和结果，沿着线走到底就行。\n中奖、淘汰、顺序、惩罚，什么都能公平决定。\n无需登录，不收集数据。';

  @override
  String get start => '开始';

  @override
  String get players => '参与者';

  @override
  String playerCount(int n) {
    return '$n人';
  }

  @override
  String get playerRange => '2～10人';

  @override
  String get nameHint => '姓名';

  @override
  String get results => '结果';

  @override
  String get resultHint => '结果';

  @override
  String get presetWinner => '1个中奖';

  @override
  String get presetLoser => '1个淘汰';

  @override
  String get presetRank => '排名';

  @override
  String get presetCustom => '自定义';

  @override
  String get winner => '中奖';

  @override
  String get loser => '淘汰';

  @override
  String rankN(int n) {
    return '第$n名';
  }

  @override
  String get startGame => '开始画鬼脚';

  @override
  String get resetNames => '重置姓名';

  @override
  String get ladderTitle => '鬼脚图';

  @override
  String get tapNameHint => '点击上方的名字开始走线';

  @override
  String get revealAll => '全部走完';

  @override
  String get showResults => '显示结果';

  @override
  String get hideResults => '隐藏结果';

  @override
  String get shuffle => '重新打乱';

  @override
  String get newGame => '新游戏';

  @override
  String get resultSummary => '结果';

  @override
  String get copyResults => '复制结果';

  @override
  String get copied => '已复制结果';

  @override
  String get close => '关闭';

  @override
  String get shareText => '[画鬼脚结果]';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsGame => '游戏';

  @override
  String get settingsAnimSpeed => '走线速度';

  @override
  String get speedSlow => '慢';

  @override
  String get speedNormal => '普通';

  @override
  String get speedFast => '快';

  @override
  String get settingsRevealResults => '一开始就显示结果';

  @override
  String get settingsRevealResultsSubtitle => '关闭后，下方结果会以 ? 隐藏';

  @override
  String get settingsSound => '音效';

  @override
  String get settingsAbout => '关于';

  @override
  String settingsVersion(String v) {
    return '版本 $v';
  }

  @override
  String get settingsPrivacy => '隐私政策';

  @override
  String get settingsLicenses => '开源许可';

  @override
  String get settingsDataNote => '本应用不收集个人信息。姓名和结果仅为方便使用而保存在设备本地。';
}
