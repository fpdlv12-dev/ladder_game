import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../models/ladder.dart';
import '../services/settings.dart';
import '../util/player_colors.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/ladder_painter.dart';

/// 사다리 화면. 위쪽 이름을 누르면 경로가 그려지며 내려가고, 도착한 결과가 열린다.
class LadderScreen extends StatefulWidget {
  final List<String> names;
  final List<String> results;
  const LadderScreen({super.key, required this.names, required this.results});

  @override
  State<LadderScreen> createState() => _LadderScreenState();
}

class _LadderScreenState extends State<LadderScreen>
    with SingleTickerProviderStateMixin {
  late Ladder _ladder;
  late AnimationController _anim;

  /// 참가자 → 완성된 경로 (애니메이션 중인 참가자는 [_running])
  final _done = <int, List<LadderPoint>>{};
  int? _running;
  List<LadderPoint>? _runningPath;

  /// 열린 결과 칸(도착 줄 번호)
  final _revealed = <int>{};
  bool _showAll = false;
  bool _runningAll = false;

  int get _n => widget.names.length;

  @override
  void initState() {
    super.initState();
    _ladder = Ladder.random(_n);
    _anim = AnimationController(vsync: this)..addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showAll = AppScope.of(context).settings.revealResults;
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Duration _durationFor(List<LadderPoint> path) {
    final speed = AppScope.of(context).settings.speed;
    final perSegment = switch (speed) {
      AnimSpeed.slow => 170,
      AnimSpeed.normal => 95,
      AnimSpeed.fast => 45,
    };
    return Duration(milliseconds: 250 + perSegment * path.length);
  }

  Future<void> _run(int player) async {
    if (_running != null || _done.containsKey(player)) return;
    final path = _ladder.trace(player);
    setState(() {
      _running = player;
      _runningPath = path;
    });
    _anim.duration = _durationFor(path);
    try {
      await _anim.forward(from: 0).orCancel;
    } on TickerCanceled {
      return;
    }
    if (!mounted) return;
    setState(() {
      _done[player] = path;
      _revealed.add(path.last.column);
      _running = null;
      _runningPath = null;
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _runAll() async {
    if (_runningAll || _running != null) return;
    setState(() => _runningAll = true);
    for (var p = 0; p < _n; p++) {
      if (!mounted) return;
      if (_done.containsKey(p)) continue;
      await _run(p);
    }
    if (mounted) setState(() => _runningAll = false);
  }

  void _shuffle() {
    _anim.stop();
    setState(() {
      _ladder = Ladder.random(_n);
      _done.clear();
      _revealed.clear();
      _running = null;
      _runningPath = null;
      _runningAll = false;
    });
  }

  List<TracedPath> get _paths => [
    for (final e in _done.entries)
      TracedPath(
        points: e.value,
        color: playerColor(e.key),
        progress: 1,
      ),
    if (_running != null && _runningPath != null)
      TracedPath(
        points: _runningPath!,
        color: playerColor(_running!),
        progress: Curves.easeInOut.transform(_anim.value),
      ),
  ];

  /// 결과 칸 [column] 에 도착한 참가자 (완료된 경로 기준)
  int? _arrivedAt(int column) {
    for (final e in _done.entries) {
      if (e.value.last.column == column) return e.key;
    }
    return null;
  }

  void _showSummary() {
    final t = L10n.of(context);
    final mapping = _ladder.mapping;
    final lines = [
      for (var p = 0; p < _n; p++)
        '${widget.names[p]} → ${widget.results[mapping[p]]}',
    ];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.resultSummary,
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _n,
                itemBuilder: (_, p) => ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: playerColor(p),
                    child: Text(
                      '${p + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(widget.names[p]),
                  trailing: Text(
                    widget.results[mapping[p]],
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: '${t.shareText}\n${lines.join('\n')}',
                          ),
                        );
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(t.copied)));
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: Text(t.copyResults),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(t.close),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final cs = Theme.of(context).colorScheme;
    final allDone = _done.length == _n;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.ladderTitle),
        actions: [
          IconButton(
            tooltip: _showAll ? t.hideResults : t.showResults,
            icon: Icon(
              _showAll ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            ),
            onPressed: () => setState(() => _showAll = !_showAll),
          ),
          IconButton(
            tooltip: t.shuffle,
            icon: const Icon(Icons.shuffle),
            onPressed: _shuffle,
          ),
        ],
      ),
      bottomNavigationBar: const BannerAdWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
          child: Column(
            children: [
              Text(
                allDone ? '' : t.tapNameHint,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 6),
              // 위: 이름 버튼
              Row(
                children: [
                  for (var p = 0; p < _n; p++)
                    Expanded(
                      child: _NameButton(
                        label: widget.names[p],
                        color: playerColor(p),
                        done: _done.containsKey(p),
                        active: _running == p,
                        onTap: _running == null && !_done.containsKey(p)
                            ? () => _run(p)
                            : null,
                      ),
                    ),
                ],
              ),
              // 가운데: 사다리
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: CustomPaint(
                    painter: LadderPainter(
                      ladder: _ladder,
                      lineColor: cs.outlineVariant,
                      paths: _paths,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
              // 아래: 결과
              Row(
                children: [
                  for (var c = 0; c < _n; c++)
                    Expanded(
                      child: _ResultBox(
                        label: widget.results[c],
                        revealed: _showAll || _revealed.contains(c),
                        color: _arrivedAt(c) == null
                            ? null
                            : playerColor(_arrivedAt(c)!),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: allDone || _runningAll ? null : _runAll,
                      icon: const Icon(Icons.fast_forward_rounded),
                      label: Text(t.revealAll),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: _showSummary,
                      icon: const Icon(Icons.list_alt_rounded),
                      label: Text(t.resultSummary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.replay_rounded),
                      label: Text(t.newGame),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool done;
  final bool active;
  final VoidCallback? onTap;
  const _NameButton({
    required this.label,
    required this.color,
    required this.done,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final filled = done || active;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: filled ? color : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            height: 44,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                height: 1.15,
                fontWeight: FontWeight.bold,
                color: filled ? Colors.white : color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultBox extends StatelessWidget {
  final String label;
  final bool revealed;
  final Color? color;
  const _ResultBox({
    required this.label,
    required this.revealed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = color ?? cs.surfaceContainerHighest;
    final fg = color == null ? cs.onSurface : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 44,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: color == null ? Border.all(color: cs.outlineVariant) : null,
        ),
        child: Text(
          revealed ? label : '?',
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: revealed ? 12 : 16,
            height: 1.15,
            fontWeight: FontWeight.bold,
            color: fg,
          ),
        ),
      ),
    );
  }
}
