// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class L10nKo extends L10n {
  L10nKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '사다리타기';

  @override
  String get onboardingHeadline => '누가 걸릴까?\n사다리로 정해요';

  @override
  String get onboardingBody =>
      '참가자와 결과를 적고 사다리를 타면 끝.\n당첨·꽝·순서·벌칙, 뭐든 공평하게 정할 수 있어요.\n로그인도, 데이터 수집도 없습니다.';

  @override
  String get start => '시작하기';

  @override
  String get players => '참가자';

  @override
  String playerCount(int n) {
    return '$n명';
  }

  @override
  String get playerRange => '2~10명';

  @override
  String get nameHint => '이름';

  @override
  String get results => '결과';

  @override
  String get resultHint => '결과';

  @override
  String get presetWinner => '당첨 1개';

  @override
  String get presetLoser => '꽝 1개';

  @override
  String get presetRank => '순위';

  @override
  String get presetCustom => '직접 입력';

  @override
  String get winner => '당첨';

  @override
  String get loser => '꽝';

  @override
  String rankN(int n) {
    return '$n등';
  }

  @override
  String get startGame => '사다리 타기';

  @override
  String get resetNames => '이름 초기화';

  @override
  String get ladderTitle => '사다리';

  @override
  String get tapNameHint => '위쪽 이름을 누르면 사다리를 타요';

  @override
  String get revealAll => '모두 타기';

  @override
  String get showResults => '결과 보기';

  @override
  String get hideResults => '결과 숨기기';

  @override
  String get shuffle => '다시 섞기';

  @override
  String get newGame => '새 게임';

  @override
  String get resultSummary => '결과';

  @override
  String get copyResults => '결과 복사';

  @override
  String get copied => '결과를 복사했어요';

  @override
  String get close => '닫기';

  @override
  String get shareText => '[사다리타기 결과]';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsGame => '게임';

  @override
  String get settingsAnimSpeed => '사다리 타는 속도';

  @override
  String get speedSlow => '느리게';

  @override
  String get speedNormal => '보통';

  @override
  String get speedFast => '빠르게';

  @override
  String get settingsRevealResults => '결과를 처음부터 보이기';

  @override
  String get settingsRevealResultsSubtitle => '끄면 사다리 아래 결과가 ? 로 가려져요';

  @override
  String get settingsSound => '효과음';

  @override
  String get settingsAbout => '앱 정보';

  @override
  String settingsVersion(String v) {
    return '버전 $v';
  }

  @override
  String get settingsPrivacy => '개인정보처리방침';

  @override
  String get settingsLicenses => '오픈소스 라이선스';

  @override
  String get settingsDataNote =>
      '이 앱은 개인정보를 수집하지 않습니다. 이름과 결과는 편의를 위해 기기 안에만 저장됩니다.';
}
