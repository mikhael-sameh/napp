import 'package:napp/core/utils/solver_models.dart';

class GaussJordanEliminationSolver {
  final List<List<double>> _a;
  static const double _eps = 1e-12;

  GaussJordanEliminationSolver(List<List<double>> matrix) : _a = cloneMatrix(matrix);

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

    for (int pivotIndex = 0; pivotIndex < 3; pivotIndex++) {
      final pivot = _a[pivotIndex][pivotIndex];
      if (pivot.abs() < _eps) {
        return Chapter2Solution(
          hasSolution: false,
          roots: const [],
          steps: steps,
          errorMessage: 'Zero pivot at row ${pivotIndex + 1}; this implementation does not pivot.',
        );
      }

      for (int j = 0; j < 4; j++) {
        _a[pivotIndex][j] = _a[pivotIndex][j] / pivot;
      }
      steps.add(
        Chapter2Step(
          title: 'Normalize row ${pivotIndex + 1}',
          note: 'R${pivotIndex + 1} <- R${pivotIndex + 1}/${pivot.toStringAsFixed(4)}',
          snapshots: [MatrixSnapshot(label: 'A|b', matrix: cloneMatrix(_a), isAugmented: true)],
        ),
      );

      for (int row = 0; row < 3; row++) {
        if (row == pivotIndex) {
          continue;
        }
        final factor = _a[row][pivotIndex];
        if (factor.abs() < _eps) {
          continue;
        }
        for (int j = 0; j < 4; j++) {
          _a[row][j] = _a[row][j] - (factor * _a[pivotIndex][j]);
        }
        steps.add(
          Chapter2Step(
            title: 'Eliminate pivot column ${pivotIndex + 1} from row ${row + 1}',
            note:
                'R${row + 1} <- R${row + 1} - (${factor.toStringAsFixed(4)})*R${pivotIndex + 1}',
            snapshots: [MatrixSnapshot(label: 'A|b', matrix: cloneMatrix(_a), isAugmented: true)],
          ),
        );
      }
    }

    final roots = [_a[0][3], _a[1][3], _a[2][3]];
    steps.add(
      Chapter2Step(
        title: 'Final solution',
        note:
            'x1=${roots[0].toStringAsFixed(4)}, '
            'x2=${roots[1].toStringAsFixed(4)}, '
            'x3=${roots[2].toStringAsFixed(4)}',
        snapshots: [MatrixSnapshot(label: '(A|b)', matrix: cloneMatrix(_a), isAugmented: true)],
      ),
    );

    return Chapter2Solution(
      hasSolution: true,
      roots: roots,
      steps: steps,
    );
  }
}
