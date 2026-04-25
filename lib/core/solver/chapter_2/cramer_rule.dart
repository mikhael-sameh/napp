import 'package:napp/core/utils/solver_models.dart';

class CramerRuleSolver {
  final List<List<double>> _augmented;

  CramerRuleSolver(List<List<double>> matrix) : _augmented = cloneMatrix(matrix);

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
    final steps = <Chapter2Step>[
      Chapter2Step(
        title: 'Initial A and b',
        snapshots: [
          MatrixSnapshot(label: 'A', matrix: cloneMatrix(a)),
          MatrixSnapshot(label: 'b', matrix: b.map((e) => [e]).toList()),
        ],
      ),
    ];

    final detA = _det(a);
    steps.add(
      Chapter2Step(
        title: 'Compute determinant of A',
        note: 'det(A)=${detA.toStringAsFixed(4)}',
        snapshots: [MatrixSnapshot(label: 'A', matrix: cloneMatrix(a))],
      ),
    );

    if (detA.abs() == 0) {
      return Chapter2Solution(
        hasSolution: false,
        roots: const [],
        steps: steps,
        errorMessage: 'det(A) = 0, so the system has no unique solution.',
      );
    }

    final roots = <double>[];
    for (int col = 0; col < 3; col++) {
      final ai = cloneMatrix(a);
      for (int row = 0; row < 3; row++) {
        ai[row][col] = b[row];
      }
      final detAi = _det(ai);
      final x = detAi / detA;
      roots.add(x);

      steps.add(
        Chapter2Step(
          title: 'Replace column ${col + 1} and compute determinant',
          note:
              'det(A${col + 1})=${detAi.toStringAsFixed(4)}, '
              'x${col + 1}=det(A${col + 1})/det(A)=${x.toStringAsFixed(4)}',
          snapshots: [MatrixSnapshot(label: 'A${col + 1}', matrix: ai)],
        ),
      );
    }

    return Chapter2Solution(
      hasSolution: true,
      roots: roots,
      steps: steps,
    );
  }

  double _det(List<List<double>> m) {
    return (m[0][0] * ((m[1][1] * m[2][2]) - (m[1][2] * m[2][1]))) -
        (m[0][1] * ((m[1][0] * m[2][2]) - (m[1][2] * m[2][0]))) +
        (m[0][2] * ((m[1][0] * m[2][1]) - (m[1][1] * m[2][0])));
  }
}
