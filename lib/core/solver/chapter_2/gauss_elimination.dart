import 'dart:math';

import 'package:napp/core/utils/solver_models.dart';

class GaussEliminationSolver {
  final List<List<double>> _a;

  GaussEliminationSolver(List<List<double>> matrix) : _a = cloneMatrix(matrix);

  Chapter2Solution solve() {
    if (_a.length != 3 || _a.any((row) => row.length != 4)) {
      return const Chapter2Solution(
        hasSolution: false,
        roots: [],
        steps: [],
        errorMessage: 'Input must be a 3x4 augmented matrix.',
      );
    }

    final steps = <Chapter2Step>[
      Chapter2Step(
        title: 'Initial augmented matrix',
        snapshots: [MatrixSnapshot(label: 'A|b', matrix: cloneMatrix(_a), isAugmented: true)],
      ),
    ];

    if (_a[0][0] == 0) {
      return Chapter2Solution(
        hasSolution: false,
        roots: const [],
        steps: steps,
        errorMessage: 'Pivot a11 is zero; this implementation does not use pivoting.',
      );
    }

    final m21 = _a[1][0] / _a[0][0];
    final m31 = _a[2][0] / _a[0][0];

    for (int j = 0; j < 4; j++) {
      _a[1][j] = _a[1][j] - (m21 * _a[0][j]);
      _a[2][j] = _a[2][j] - (m31 * _a[0][j]);
    }

    steps.add(
      Chapter2Step(
        title: 'Eliminate x1 from rows 2 and 3',
        note:
            'm21=${m21.toStringAsFixed(4)},\t(R2-m21)*R1 -> R2\nm31=${m31.toStringAsFixed(4)} '
            '\t(R3-m31)*R1 -> R3',
        snapshots: [MatrixSnapshot(label: 'After first elimination', matrix: cloneMatrix(_a), isAugmented: true)],
      ),
    );

    if (_a[1][1] == 0) {
      return Chapter2Solution(
        hasSolution: false,
        roots: const [],
        steps: steps,
        errorMessage: 'Pivot a22 became zero; no unique solution with this flow.',
      );
    }

    final m32 = _a[2][1] / _a[1][1];
    for (int j = 0; j < 4; j++) {
      _a[2][j] = _a[2][j] - (m32 * _a[1][j]);
    }

    steps.add(
      Chapter2Step(
        title: 'Eliminate x2 from row 3',
        note: 'm32=${m32.toStringAsFixed(4)},\t(R3-m32)*R2 -> R3',
        snapshots: [MatrixSnapshot(label: 'Upper-triangular A|b', matrix: cloneMatrix(_a), isAugmented: true)],
      ),
    );

    if (_a[2][2] == 0) {
      return Chapter2Solution(
        hasSolution: false,
        roots: const [],
        steps: steps,
        errorMessage: 'Pivot a33 is zero; system is singular or has infinite solutions.',
      );
    }

    final x3 = _a[2][3] / _a[2][2];
    final x2 = (_a[1][3] - (_a[1][2] * x3)) / _a[1][1];
    final x1 = (_a[0][3] - (_a[0][1] * x2) - (_a[0][2] * x3)) / _a[0][0];

    if ([x1, x2, x3].any((v) => v.isNaN || v.isInfinite || v.abs() > pow(10, 12))) {
      return Chapter2Solution(
        hasSolution: false,
        roots: const [],
        steps: steps,
        errorMessage: 'Numerical instability detected while computing the solution.',
      );
    }

    return Chapter2Solution(
      hasSolution: true,
      roots: [x1, x2, x3],
      steps: steps,
    );
  }
}
