import 'dart:math';

/// 사다리 한 판. [columns] 개의 세로줄과 [rows] 개의 가로줄 슬롯.
///
/// `rungs[r][c]` 가 true 면 r 번째 슬롯에서 c 번 줄과 c+1 번 줄 사이에 가로줄이 있다.
/// 같은 슬롯에서 이웃한 두 가로줄(c 와 c+1)은 동시에 있을 수 없다 (한 줄에 두 방향이 붙는 것 방지).
class Ladder {
  final int columns;
  final int rows;
  final List<List<bool>> rungs;

  Ladder._(this.columns, this.rows, this.rungs);

  /// 무작위 사다리 생성. 이웃한 모든 줄 쌍에 가로줄이 최소 1개는 있도록 해서
  /// 결과가 한쪽으로만 쏠리지 않게 한다.
  factory Ladder.random(int columns, {Random? rng, int? rows}) {
    assert(columns >= 2);
    final r = rng ?? Random();
    final n = rows ?? (columns * 2 + 6).clamp(10, 26);
    late List<List<bool>> grid;
    while (true) {
      grid = List.generate(n, (_) => List.filled(columns - 1, false));
      for (var row = 0; row < n; row++) {
        for (var c = 0; c < columns - 1; c++) {
          final leftTaken = c > 0 && grid[row][c - 1];
          if (!leftTaken && r.nextDouble() < 0.38) grid[row][c] = true;
        }
      }
      // 모든 이웃 쌍에 가로줄이 하나 이상
      final ok = List.generate(
        columns - 1,
        (c) => grid.any((row) => row[c]),
      ).every((v) => v);
      if (ok) break;
    }
    return Ladder._(columns, n, grid);
  }

  /// [start] 번 줄에서 출발했을 때 지나는 경로. 각 원소는 (column, rowIndex) 이며
  /// rowIndex 는 0(맨 위) ~ rows+1(맨 아래). 가로줄 슬롯 r 은 rowIndex r+1 에 해당한다.
  List<LadderPoint> trace(int start) {
    var col = start;
    final path = <LadderPoint>[LadderPoint(col, 0)];
    for (var r = 0; r < rows; r++) {
      final y = r + 1;
      if (col < columns - 1 && rungs[r][col]) {
        path.add(LadderPoint(col, y));
        col += 1;
        path.add(LadderPoint(col, y));
      } else if (col > 0 && rungs[r][col - 1]) {
        path.add(LadderPoint(col, y));
        col -= 1;
        path.add(LadderPoint(col, y));
      }
    }
    path.add(LadderPoint(col, rows + 1));
    return path;
  }

  /// 출발 줄 → 도착 줄
  int destination(int start) => trace(start).last.column;

  /// 모든 출발 줄의 도착 줄 (순열)
  List<int> get mapping => List.generate(columns, destination);
}

class LadderPoint {
  final int column;
  final int row;
  const LadderPoint(this.column, this.row);

  @override
  String toString() => '($column,$row)';

  @override
  bool operator ==(Object other) =>
      other is LadderPoint && other.column == column && other.row == row;

  @override
  int get hashCode => Object.hash(column, row);
}
