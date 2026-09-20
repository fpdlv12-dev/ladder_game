import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ladder_game/models/ladder.dart';

void main() {
  test('mapping is a permutation for every size', () {
    for (var n = 2; n <= 10; n++) {
      for (var seed = 0; seed < 50; seed++) {
        final l = Ladder.random(n, rng: Random(seed));
        final m = l.mapping;
        expect(m.toSet().length, n, reason: 'n=$n seed=$seed $m');
        // 같은 슬롯에 이웃한 가로줄이 없어야 한다
        for (final row in l.rungs) {
          for (var c = 1; c < row.length; c++) {
            expect(row[c - 1] && row[c], isFalse);
          }
        }
        // 이웃한 모든 줄 쌍에 가로줄이 하나 이상
        for (var c = 0; c < n - 1; c++) {
          expect(l.rungs.any((r) => r[c]), isTrue);
        }
      }
    }
  });

  test('trace starts at top and ends at bottom', () {
    final l = Ladder.random(5, rng: Random(1));
    for (var s = 0; s < 5; s++) {
      final p = l.trace(s);
      expect(p.first, LadderPoint(s, 0));
      expect(p.last.row, l.rows + 1);
      // 연속 점은 수직 또는 수평으로만 이어진다
      for (var i = 1; i < p.length; i++) {
        final same = p[i].column == p[i - 1].column || p[i].row == p[i - 1].row;
        expect(same, isTrue);
      }
    }
  });
}
