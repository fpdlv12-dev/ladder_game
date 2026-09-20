import 'dart:math';

import 'package:flutter/material.dart';

import '../ads/ad_manager.dart';
import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../services/settings.dart';
import '../util/player_colors.dart';
import '../widgets/banner_ad_widget.dart';
import 'ladder_screen.dart';
import 'settings_screen.dart';

/// 홈: 인원·이름·결과를 정하고 사다리를 시작한다.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _names = <TextEditingController>[];
  final _results = <TextEditingController>[];
  ResultPreset _preset = ResultPreset.winner;
  bool _restored = false;

  int get _count => _names.length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_restored) return;
    _restored = true;
    final s = AppScope.of(context).settings;
    _preset = s.preset;
    final saved = s.names;
    final savedResults = s.results;
    for (var i = 0; i < s.playerCount; i++) {
      _names.add(TextEditingController(text: i < saved.length ? saved[i] : ''));
      _results.add(
        TextEditingController(
          text: i < savedResults.length ? savedResults[i] : '',
        ),
      );
    }
    if (_preset != ResultPreset.custom && savedResults.isEmpty) {
      _applyPreset(_preset);
    }
  }

  @override
  void dispose() {
    for (final c in [..._names, ..._results]) {
      c.dispose();
    }
    super.dispose();
  }

  void _setCount(int n) {
    n = n.clamp(AppSettings.minPlayers, AppSettings.maxPlayers);
    if (n == _count) return;
    setState(() {
      while (_names.length > n) {
        _names.removeLast().dispose();
        _results.removeLast().dispose();
      }
      while (_names.length < n) {
        _names.add(TextEditingController());
        _results.add(TextEditingController());
      }
      if (_preset != ResultPreset.custom) _applyPreset(_preset);
    });
  }

  /// 프리셋에 맞춰 결과 칸을 채운다. 당첨/꽝 위치는 무작위.
  void _applyPreset(ResultPreset p) {
    final t = L10n.of(context);
    final n = _count;
    _preset = p;
    switch (p) {
      case ResultPreset.winner:
        final w = Random().nextInt(n);
        for (var i = 0; i < n; i++) {
          _results[i].text = i == w ? t.winner : t.loser;
        }
      case ResultPreset.loser:
        final l = Random().nextInt(n);
        for (var i = 0; i < n; i++) {
          _results[i].text = i == l ? t.loser : t.winner;
        }
      case ResultPreset.rank:
        for (var i = 0; i < n; i++) {
          _results[i].text = t.rankN(i + 1);
        }
      case ResultPreset.custom:
        break;
    }
  }

  void _resetNames() {
    setState(() {
      for (final c in _names) {
        c.clear();
      }
    });
  }

  Future<void> _start() async {
    FocusScope.of(context).unfocus();
    final names = List.generate(_count, (i) {
      final v = _names[i].text.trim();
      return v.isEmpty ? '${i + 1}' : v;
    });
    final results = List.generate(_count, (i) {
      final v = _results[i].text.trim();
      return v.isEmpty ? '${i + 1}' : v;
    });
    final settings = AppScope.of(context).settings;
    await settings.saveGame(names: names, results: results, preset: _preset);
    if (!mounted) return;
    // 전면 광고: 하루 첫 1회만 (사다리 화면으로 넘어가기 전)
    AdManager.instance.showInterstitialOncePerDayThen(() {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LadderScreen(names: names, results: results),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        actions: [
          IconButton(
            tooltip: t.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      bottomNavigationBar: const BannerAdWidget(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                _sectionHeader(
                  context,
                  t.players,
                  trailing: _CountStepper(
                    count: _count,
                    label: t.playerCount(_count),
                    onChanged: _setCount,
                  ),
                ),
                _fieldGrid(
                  controllers: _names,
                  hint: t.nameHint,
                  leading: (i) => CircleAvatar(
                    radius: 10,
                    backgroundColor: playerColor(i),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _resetNames,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(t.resetNames),
                  ),
                ),
                const SizedBox(height: 4),
                _sectionHeader(context, t.results),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final p in ResultPreset.values)
                      ChoiceChip(
                        label: Text(_presetLabel(t, p)),
                        selected: _preset == p,
                        onSelected: (_) => setState(() => _applyPreset(p)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                _fieldGrid(
                  controllers: _results,
                  hint: t.resultHint,
                  onChanged: () {
                    if (_preset != ResultPreset.custom) {
                      setState(() => _preset = ResultPreset.custom);
                    }
                  },
                  leading: (i) => Icon(
                    Icons.flag_outlined,
                    size: 18,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _start,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  t.startGame,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _presetLabel(L10n t, ResultPreset p) => switch (p) {
    ResultPreset.winner => t.presetWinner,
    ResultPreset.loser => t.presetLoser,
    ResultPreset.rank => t.presetRank,
    ResultPreset.custom => t.presetCustom,
  };

  Widget _sectionHeader(BuildContext context, String title, {Widget? trailing}) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  /// 2열 입력 그리드
  Widget _fieldGrid({
    required List<TextEditingController> controllers,
    required String hint,
    required Widget Function(int) leading,
    VoidCallback? onChanged,
  }) {
    final rows = (controllers.length + 1) ~/ 2;
    return Column(
      children: [
        for (var r = 0; r < rows; r++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                for (var k = 0; k < 2; k++) ...[
                  if (k == 1) const SizedBox(width: 8),
                  Expanded(
                    child: r * 2 + k < controllers.length
                        ? _field(controllers[r * 2 + k], hint,
                            leading(r * 2 + k), onChanged)
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _field(
    TextEditingController c,
    String hint,
    Widget leading,
    VoidCallback? onChanged,
  ) {
    return TextField(
      controller: c,
      maxLength: 12,
      textInputAction: TextInputAction.next,
      onChanged: onChanged == null ? null : (_) => onChanged(),
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        isDense: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10, right: 6),
          child: leading,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

class _CountStepper extends StatelessWidget {
  final int count;
  final String label;
  final ValueChanged<int> onChanged;
  const _CountStepper({
    required this.count,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: count > AppSettings.minPlayers
                ? () => onChanged(count - 1)
                : null,
            icon: const Icon(Icons.remove),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: count < AppSettings.maxPlayers
                ? () => onChanged(count + 1)
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
