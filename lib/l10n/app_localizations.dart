import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'사다리타기'**
  String get appTitle;

  /// No description provided for @onboardingHeadline.
  ///
  /// In ko, this message translates to:
  /// **'누가 걸릴까?\n사다리로 정해요'**
  String get onboardingHeadline;

  /// No description provided for @onboardingBody.
  ///
  /// In ko, this message translates to:
  /// **'참가자와 결과를 적고 사다리를 타면 끝.\n당첨·꽝·순서·벌칙, 뭐든 공평하게 정할 수 있어요.\n로그인도, 데이터 수집도 없습니다.'**
  String get onboardingBody;

  /// No description provided for @start.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get start;

  /// No description provided for @players.
  ///
  /// In ko, this message translates to:
  /// **'참가자'**
  String get players;

  /// No description provided for @playerCount.
  ///
  /// In ko, this message translates to:
  /// **'{n}명'**
  String playerCount(int n);

  /// No description provided for @playerRange.
  ///
  /// In ko, this message translates to:
  /// **'2~10명'**
  String get playerRange;

  /// No description provided for @nameHint.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get nameHint;

  /// No description provided for @results.
  ///
  /// In ko, this message translates to:
  /// **'결과'**
  String get results;

  /// No description provided for @resultHint.
  ///
  /// In ko, this message translates to:
  /// **'결과'**
  String get resultHint;

  /// No description provided for @presetWinner.
  ///
  /// In ko, this message translates to:
  /// **'당첨 1개'**
  String get presetWinner;

  /// No description provided for @presetLoser.
  ///
  /// In ko, this message translates to:
  /// **'꽝 1개'**
  String get presetLoser;

  /// No description provided for @presetRank.
  ///
  /// In ko, this message translates to:
  /// **'순위'**
  String get presetRank;

  /// No description provided for @presetCustom.
  ///
  /// In ko, this message translates to:
  /// **'직접 입력'**
  String get presetCustom;

  /// No description provided for @winner.
  ///
  /// In ko, this message translates to:
  /// **'당첨'**
  String get winner;

  /// No description provided for @loser.
  ///
  /// In ko, this message translates to:
  /// **'꽝'**
  String get loser;

  /// No description provided for @rankN.
  ///
  /// In ko, this message translates to:
  /// **'{n}등'**
  String rankN(int n);

  /// No description provided for @startGame.
  ///
  /// In ko, this message translates to:
  /// **'사다리 타기'**
  String get startGame;

  /// No description provided for @resetNames.
  ///
  /// In ko, this message translates to:
  /// **'이름 초기화'**
  String get resetNames;

  /// No description provided for @ladderTitle.
  ///
  /// In ko, this message translates to:
  /// **'사다리'**
  String get ladderTitle;

  /// No description provided for @tapNameHint.
  ///
  /// In ko, this message translates to:
  /// **'위쪽 이름을 누르면 사다리를 타요'**
  String get tapNameHint;

  /// No description provided for @revealAll.
  ///
  /// In ko, this message translates to:
  /// **'모두 타기'**
  String get revealAll;

  /// No description provided for @showResults.
  ///
  /// In ko, this message translates to:
  /// **'결과 보기'**
  String get showResults;

  /// No description provided for @hideResults.
  ///
  /// In ko, this message translates to:
  /// **'결과 숨기기'**
  String get hideResults;

  /// No description provided for @shuffle.
  ///
  /// In ko, this message translates to:
  /// **'다시 섞기'**
  String get shuffle;

  /// No description provided for @newGame.
  ///
  /// In ko, this message translates to:
  /// **'새 게임'**
  String get newGame;

  /// No description provided for @resultSummary.
  ///
  /// In ko, this message translates to:
  /// **'결과'**
  String get resultSummary;

  /// No description provided for @copyResults.
  ///
  /// In ko, this message translates to:
  /// **'결과 복사'**
  String get copyResults;

  /// No description provided for @copied.
  ///
  /// In ko, this message translates to:
  /// **'결과를 복사했어요'**
  String get copied;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @shareText.
  ///
  /// In ko, this message translates to:
  /// **'[사다리타기 결과]'**
  String get shareText;

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @settingsGame.
  ///
  /// In ko, this message translates to:
  /// **'게임'**
  String get settingsGame;

  /// No description provided for @settingsAnimSpeed.
  ///
  /// In ko, this message translates to:
  /// **'사다리 타는 속도'**
  String get settingsAnimSpeed;

  /// No description provided for @speedSlow.
  ///
  /// In ko, this message translates to:
  /// **'느리게'**
  String get speedSlow;

  /// No description provided for @speedNormal.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get speedNormal;

  /// No description provided for @speedFast.
  ///
  /// In ko, this message translates to:
  /// **'빠르게'**
  String get speedFast;

  /// No description provided for @settingsRevealResults.
  ///
  /// In ko, this message translates to:
  /// **'결과를 처음부터 보이기'**
  String get settingsRevealResults;

  /// No description provided for @settingsRevealResultsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'끄면 사다리 아래 결과가 ? 로 가려져요'**
  String get settingsRevealResultsSubtitle;

  /// No description provided for @settingsSound.
  ///
  /// In ko, this message translates to:
  /// **'효과음'**
  String get settingsSound;

  /// No description provided for @settingsAbout.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In ko, this message translates to:
  /// **'버전 {v}'**
  String settingsVersion(String v);

  /// No description provided for @settingsPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보처리방침'**
  String get settingsPrivacy;

  /// No description provided for @settingsLicenses.
  ///
  /// In ko, this message translates to:
  /// **'오픈소스 라이선스'**
  String get settingsLicenses;

  /// No description provided for @settingsDataNote.
  ///
  /// In ko, this message translates to:
  /// **'이 앱은 개인정보를 수집하지 않습니다. 이름과 결과는 편의를 위해 기기 안에만 저장됩니다.'**
  String get settingsDataNote;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'ja':
      return L10nJa();
    case 'ko':
      return L10nKo();
    case 'zh':
      return L10nZh();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
