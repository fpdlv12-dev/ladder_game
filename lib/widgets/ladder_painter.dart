import 'package:flutter/material.dart';

import '../models/ladder.dart';

/// 사다리 위에 그릴 경로 하나. [progress] 는 0(출발) ~ 1(도착).
class TracedPath {
  final List<LadderPoint> points;
  final Color color;
  final double progress;
  const TracedPath({
    required this.points,
    required this.color,
    required this.progress,
  });
}

/// 사다리 기하. 위젯(이름 칸)과 페인터가 같은 x 좌표를 쓰도록 여기서만 계산한다.
class LadderGeometry {
  final Size size;
  final int columns;
  final int rows;
  const LadderGeometry(this.size, this.columns, this.rows);

  double x(int column) => size.width * (column + 0.5) / columns;
  double y(int row) => size.height * row / (rows + 1);

  Offset at(LadderPoint p) => Offset(x(p.column), y(p.row));
}

class LadderPainter extends CustomPainter {
  final Ladder ladder;
  final Color lineColor;
  final List<TracedPath> paths;
  final double lineWidth;
  final double pathWidth;

  LadderPainter({
    required this.ladder,
    required this.lineColor,
    this.paths = const [],
    this.lineWidth = 3,
    this.pathWidth = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final g = LadderGeometry(size, ladder.columns, ladder.rows);
    final line = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    // 세로줄
    for (var c = 0; c < ladder.columns; c++) {
      canvas.drawLine(Offset(g.x(c), 0), Offset(g.x(c), size.height), line);
    }
    // 가로줄
    for (var r = 0; r < ladder.rows; r++) {
      final y = g.y(r + 1);
      for (var c = 0; c < ladder.columns - 1; c++) {
        if (ladder.rungs[r][c]) {
          canvas.drawLine(Offset(g.x(c), y), Offset(g.x(c + 1), y), line);
        }
      }
    }

    // 경로
    for (final tp in paths) {
      if (tp.points.length < 2 || tp.progress <= 0) continue;
      final pts = tp.points.map(g.at).toList();
      final metricsPath = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final p in pts.skip(1)) {
        metricsPath.lineTo(p.dx, p.dy);
      }
      final paint = Paint()
        ..color = tp.color
        ..strokeWidth = pathWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (tp.progress >= 1) {
        canvas.drawPath(metricsPath, paint);
        continue;
      }
      for (final metric in metricsPath.computeMetrics()) {
        final len = metric.length * tp.progress;
        canvas.drawPath(metric.extractPath(0, len), paint);
        final tangent = metric.getTangentForOffset(len);
        if (tangent != null) {
          canvas.drawCircle(
            tangent.position,
            pathWidth * 1.4,
            Paint()..color = tp.color,
          );
          canvas.drawCircle(
            tangent.position,
            pathWidth * 0.6,
            Paint()..color = Colors.white,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(LadderPainter old) =>
      old.ladder != ladder ||
      old.lineColor != lineColor ||
      old.paths != paths ||
      old.lineWidth != lineWidth ||
      old.pathWidth != pathWidth;
}
