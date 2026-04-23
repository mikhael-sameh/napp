class MatrixSnapshot {
  final String label;
  final List<List<double>> matrix;
  final bool isAugmented;

  const MatrixSnapshot({
    required this.label,
    required this.matrix,
    this.isAugmented = false,
  });
}

class Chapter2Step {
  final String title;
  final List<MatrixSnapshot> snapshots;
  final String? note;

  const Chapter2Step({
    required this.title,
    required this.snapshots,
    this.note,
  });
}

class Chapter2Solution {
  final bool hasSolution;
  final String? errorMessage;
  final List<double> roots;
  final List<Chapter2Step> steps;

  const Chapter2Solution({
    required this.hasSolution,
    required this.roots,
    required this.steps,
    this.errorMessage,
  });
}

List<List<double>> cloneMatrix(List<List<double>> source) {
  return source.map((row) => List<double>.from(row)).toList();
}

