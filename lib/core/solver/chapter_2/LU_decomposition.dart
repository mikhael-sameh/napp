import 'package:napp/core/utils/solver_models.dart';

class LUDecompositionSolver {
  final List<List<double>> _augmented;

  LUDecompositionSolver(List<List<double>> matrix) : _augmented = cloneMatrix(matrix);

  Chapter2Solution solve() {
    if (_augmented.length != 3 || _augmented.any((row) => row.length != 4)) {
      return const Chapter2Solution(
        hasSolution: false,
        roots: [],
        steps: [],
        errorMessage: 'Input must be a 3x4 augmented matrix.',
      );
    }

    final a = List.generate(3, (i) => List<double>.from(_augmented[i].take(3)));
    final b = [_augmented[0][3], _augmented[1][3], _augmented[2][3]];
    final l = List.generate(3, (i) => List<double>.generate(3, (j) => i == j ? 1.0 : 0.0));
    final u = cloneMatrix(a);

    final steps = <Chapter2Step>[
      Chapter2Step(
        title: 'Initial A and b',
        snapshots: [
          MatrixSnapshot(label: 'A', matrix: cloneMatrix(a)),
          MatrixSnapshot(label: 'b', matrix: b.map((e) => [e]).toList()),
        ],
      ),
    ];

    for (int k = 0; k < 3; k++) {
      if (u[k][k] == 0) {
        return Chapter2Solution(
          hasSolution: false,
          roots: const [],
          steps: steps,
          errorMessage: 'Zero pivot during LU at row ${k + 1}.',
        );
      }

      for (int i = k + 1; i < 3; i++) {
        final factor = u[i][k] / u[k][k];
        l[i][k] = factor;
        for (int j = k; j < 3; j++) {
          u[i][j] = u[i][j] - (factor * u[k][j]);
        }
        steps.add(
          Chapter2Step(
            title: 'Elimination for U at column ${k + 1}',
            note: 'm${i + 1}${k + 1}=${factor.toStringAsFixed(4)}',
            snapshots: [
              MatrixSnapshot(label: 'U', matrix: cloneMatrix(u)),
              MatrixSnapshot(label: 'L', matrix: cloneMatrix(l)),
            ],
          ),
        );
      }
    }

    final c = List<double>.filled(3, 0);
    c[0] = b[0];
    c[1] = b[1] - (l[1][0] * c[0]);
    c[2] = b[2] - (l[2][0] * c[0]) - (l[2][1] * c[1]);

    steps.add(
      Chapter2Step(
        title: 'substitution (Lc = b)',
        note: 'c1=${c[0].toStringAsFixed(4)}, c2=${c[1].toStringAsFixed(4)}, c3=${c[2].toStringAsFixed(4)}',
        snapshots: [
          MatrixSnapshot(label: 'L', matrix: cloneMatrix(l)),
          MatrixSnapshot(label: 'c', matrix: c.map((e) => [e]).toList()),
        ],
      ),
    );

    if (u[2][2] == 0 || u[1][1] == 0 || u[0][0] == 0) {
      return Chapter2Solution(
        hasSolution: false,
        roots: const [],
        steps: steps,
        errorMessage: 'U has zero diagonal value; no unique solution.',
      );
    }

    final x3 = c[2] / u[2][2];
    final x2 = (c[1] - (u[1][2] * x3)) / u[1][1];
    final x1 = (c[0] - (u[0][1] * x2) - (u[0][2] * x3)) / u[0][0];

    steps.add(
      Chapter2Step(
        title: 'substitution (Ux = c)',
        note:
            'x1=${x1.toStringAsFixed(4)}, '
            'x2=${x2.toStringAsFixed(4)}, '
            'x3=${x3.toStringAsFixed(4)}',
        snapshots: [
          MatrixSnapshot(label: 'U', matrix: cloneMatrix(u)),
          MatrixSnapshot(label: 'x', matrix: [ [x1], [x2], [x3] ]),
        ],
      ),
    );

    return Chapter2Solution(
      hasSolution: true,
      roots: [x1, x2, x3],
      steps: steps,
    );
  }
}
