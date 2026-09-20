import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 사다리 아래 결과 칸을 채우는 방식.
enum ResultPreset {
  /// 당첨 1개, 나머지 꽝
  winner,

  /// 꽝 1개, 나머지 당첨
  loser,

  /// 1등 ~ N등
  rank,

  /// 직접 입력
  custom,
}

/// 사다리 타는 애니메이션 속도.
enum AnimSpeed { slow, normal, fast }

class AppSettings extends ChangeNotifier {
  static const _kOnboarded = 'onboarded';
  static const _kSpeed = 'anim_speed';
  static const _kReveal = 'reveal_results';
  static const _kCount = 'player_count';
  static const _kNames = 'player_names';
  static const _kResults = 'results';
  static const _kPreset = 'result_preset';

  static const minPlayers = 2;
  static const maxPlayers = 10;

  final SharedPreferences _prefs;
  AppSettings(this._prefs);

  bool get onboarded => _prefs.getBool(_kOnboarded) ?? false;
  Future<void> finishOnboarding() async {
    await _prefs.setBool(_kOnboarded, true);
    notifyListeners();
  }

  AnimSpeed get speed =>
      AnimSpeed.values[_prefs.getInt(_kSpeed) ?? AnimSpeed.normal.index];
  set speed(AnimSpeed v) {
    _prefs.setInt(_kSpeed, v.index);
    notifyListeners();
  }

  /// 사다리 화면에서 결과를 처음부터 보여줄지 (false 면 "?" 로 가림)
  bool get revealResults => _prefs.getBool(_kReveal) ?? false;
  set revealResults(bool v) {
    _prefs.setBool(_kReveal, v);
    notifyListeners();
  }

  // ---------------------------------------------------------------- 마지막 게임 입력

  int get playerCount =>
      (_prefs.getInt(_kCount) ?? 4).clamp(minPlayers, maxPlayers);

  /// 저장된 이름. 길이가 [playerCount] 와 다를 수 있으니 호출 쪽에서 맞춘다.
  List<String> get names => _prefs.getStringList(_kNames) ?? const [];
  List<String> get results => _prefs.getStringList(_kResults) ?? const [];

  ResultPreset get preset =>
      ResultPreset.values[_prefs.getInt(_kPreset) ?? ResultPreset.winner.index];

  /// 게임 시작 시 입력값을 통째로 저장 (알림 없음 — 화면 갱신 불필요)
  Future<void> saveGame({
    required List<String> names,
    required List<String> results,
    required ResultPreset preset,
  }) async {
    await Future.wait([
      _prefs.setInt(_kCount, names.length),
      _prefs.setStringList(_kNames, names),
      _prefs.setStringList(_kResults, results),
      _prefs.setInt(_kPreset, preset.index),
    ]);
  }
}
