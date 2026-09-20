# 사다리타기 (ladder_game)

참가자와 결과를 적고 사다리를 타서 당첨·꽝·순서·벌칙을 정하는 앱.
Flutter, Android 대상. 한국어 · 영어 · 일본어 · 중국어(간체). AdMob 광고(배너 / 전면)로 수익화.

기능:
- 참가자 2~10명, 이름은 SharedPreferences 에 저장해 다음 실행 때 복원
- 결과 프리셋: 당첨 1개 / 꽝 1개 / 순위 / 직접 입력 (결과 칸을 손으로 고치면 자동으로 "직접 입력")
- 사다리: 세로줄 N, 가로줄 슬롯 `clamp(2N+6, 10, 26)` 개. 같은 슬롯에 이웃한 가로줄은 금지, 이웃한 줄 쌍마다 가로줄 최소 1개 보장
- 이름 탭 → 경로 애니메이션(속도 3단계) → 도착한 결과 칸 공개. "모두 타기"는 순차 실행
- 결과 시트: 이름 → 결과 목록 + 클립보드 복사
- 설정: 속도, 결과 처음부터 보이기, 앱 정보 / 개인정보처리방침 / 라이선스

## 구조

```
lib/
  main.dart                      앱 진입, 테마, 온보딩 분기
  app_scope.dart                 설정을 트리에 내려주는 InheritedWidget
  ads/ad_ids.dart                AdMob 광고 단위 ID (디버그=테스트 ID, 릴리즈=실제 ID)  ← 출시 전 교체
  ads/ad_manager.dart            전면 광고 로드/노출 싱글톤 (하루 1회 게이트)
  widgets/banner_ad_widget.dart  하단 적응형 배너 (Scaffold.bottomNavigationBar 슬롯)
  widgets/ladder_painter.dart    ★ 사다리 + 경로 CustomPainter. LadderGeometry 로 위젯과 좌표 공유
  models/ladder.dart             ★ 사다리 생성(Ladder.random) 과 경로 추적(trace / mapping)
  util/player_colors.dart        참가자 10색
  services/settings.dart         SharedPreferences (온보딩, 속도, 결과 표시, 마지막 이름·결과·프리셋)
  l10n/app_*.arb                 UI 문자열 (ko/en/ja/zh) → flutter gen-l10n 이 L10n 클래스 생성
  screens/onboarding_screen.dart 첫 실행: 소개 + 사다리 미리보기
  screens/setup_screen.dart      홈. 인원·이름·결과 입력 → 전면 광고(하루 1회) → 사다리 화면
  screens/ladder_screen.dart     사다리. 이름 버튼 / CustomPaint / 결과 칸 / 모두 타기·결과·새 게임
  screens/settings_screen.dart   설정 + 앱 정보 + 개인정보처리방침 링크
test/ladder_test.dart            사다리 생성·추적 단위 테스트
tool/
  make_icon.py                   앱 아이콘 원본 생성 (Pillow) → dart run flutter_launcher_icons
  make_store_assets.py           스토어 이미지 (512 아이콘, 1024×500 피처, 1080×1920 스크린샷)
  seed_emulator.py               에뮬레이터(루트) prefs 에 한글 이름·결과 주입 (스크린샷용)
  dev.ps1                        빌드·설치·스크린샷 헬퍼 (Windows)
docs/privacy-policy.html         개인정보처리방침 (GitHub Pages)
store/                           스토어 문구(listing.md, listing_i18n.md)·이미지
```

## 광고 노출 지점

| 위치 | 종류 | 동작 |
|---|---|---|
| 홈·사다리·설정 하단 | 배너 | 항상 표시 (적응형) |
| 홈에서 "사다리 타기" 누른 직후 | 전면 | **하루 첫 1회만** (`AdManager.showInterstitialOncePerDayThen`, 날짜를 prefs 에 기록) |

보상형 광고는 쓰지 않는다.

## 데이터

- 모든 데이터는 기기 안에만 (SharedPreferences). 서버 없음, 로그인 없음, 권한은 INTERNET 뿐.

## 개발 빌드

```bash
flutter pub get
flutter build apk --debug
```

에뮬레이터: photo_calendar 프로젝트의 AVD `photo_calendar`(Pixel 7 / API 36, ko-KR) 를 재사용.
```
emulator -avd photo_calendar
python tool/seed_emulator.py        # 앱을 한 번 실행한 뒤. 한글 이름·결과 6명 주입 (prefs 통째로 교체되므로 전면 광고 날짜도 초기화됨)
```
Windows 에서는 `. tool\dev.ps1` 후 `Build-Install`, `Launch`, `Shot 이름`, `Tap x y` 를 쓴다.

### 이 PC 전용 메모
Java 의 AF_UNIX 소켓이 `%TEMP%` 아래에서 실패해 Gradle 이 "Unable to establish loopback connection" 으로
죽는 문제가 있어, `android/gradle.properties` 와 `android/gradlew.bat` 에
`-Djdk.net.unixdomain.tmpdir=C:/tmp` 를 넣어 두었다. `C:\tmp` 폴더가 있어야 한다.
RAM 8GB 라 `gradle.properties` 의 힙은 `-Xmx3G`. 릴리즈 빌드 전엔 에뮬레이터를 끈다.

## 릴리즈

```bash
flutter build appbundle --release   # → build/app/outputs/bundle/release/app-release.aab
```
- 서명: `android/upload-keystore.jks` + `android/key.properties` (git 제외 — **반드시 백업**)
- Play 에 새 버전을 올릴 때마다 `pubspec.yaml` 의 `version: x.y.z+N` 에서 N 을 올린다.
- `compileSdk`/`targetSdk` 36, `minSdk` 23.

## 출시 체크리스트 / 상태

### 1. AdMob
- [ ] https://admob.google.com 에서 앱 등록 (Android)
- [ ] 광고 단위: 배너 / 전면 — 만들 때 "파트너 입찰" 체크 **끄기**. 보상형은 사용 안 함
- [ ] `lib/ads/ad_ids.dart` 의 `_real` 테스트 ID → 실제 ID 교체
- [ ] `android/app/src/main/AndroidManifest.xml` 의 `APPLICATION_ID` 교체 (지금은 Google 테스트 앱 ID)
- [ ] 개발 중 실제 ID 로 광고 클릭 금지 (계정 정지 사유)

### 2. 개인정보 / 정책
- [x] 개인정보처리방침: https://fpdlv12-dev.github.io/ladder_game/privacy-policy.html (원본 `docs/privacy-policy.html`, GitHub Pages)

### 3. Android 출시
- [x] 릴리즈 서명 키 생성 (2026-09-20)
- [x] 앱 아이콘 (`tool/make_icon.py` → `dart run flutter_launcher_icons`)
- [x] `flutter build appbundle --release` 성공 (테스트 광고 ID 상태)
- [x] 스토어 자산 (`tool/make_store_assets.py`) + 설명문 4개 언어
- [ ] Play Console: 앱 만들기 → 스토어 등록정보 → 앱 콘텐츠 → 비공개 테스트 트랙에 AAB 업로드
- [ ] 비공개 테스트 12명 × 14일 → 프로덕션 신청
