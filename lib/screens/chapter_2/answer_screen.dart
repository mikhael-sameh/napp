import 'package:flutter/material.dart';
import 'package:napp/core/services/chapter2_pdf_service.dart';
import 'package:napp/core/solver/chapter_2/Cramer_rule.dart';
import 'package:napp/core/solver/chapter_2/Gauss_Jordan_elimination.dart';
import 'package:napp/core/solver/chapter_2/Gauss_elimination.dart';
import 'package:napp/core/solver/chapter_2/LU_decomposition.dart';
import 'package:napp/core/utils/solver_models.dart';
import 'package:napp/widgets/app_bar.dart';

class Chapter2AnswerScreen extends StatefulWidget {
  final String method;
  final String methodName;
  final List<List<double>> matrix;

  const Chapter2AnswerScreen({
    super.key,
    required this.method,
    required this.methodName,
    required this.matrix,
  });

  @override
  State<Chapter2AnswerScreen> createState() => _Chapter2AnswerScreenState();
}

class _Chapter2AnswerScreenState extends State<Chapter2AnswerScreen> {
  late final Chapter2Solution solution;

  @override
  void initState() {
    super.initState();
    solution = _solve();
  }

  Chapter2Solution _solve() {
    switch (widget.method) {
      case 'GE':
        return GaussEliminationSolver(widget.matrix).solve();
      case 'LU':
        return LUDecompositionSolver(widget.matrix).solve();
      case 'C':
        return CramerRuleSolver(widget.matrix).solve();
      case 'GJE':
        return GaussJordanEliminationSolver(widget.matrix).solve();
      default:
        return const Chapter2Solution(
          hasSolution: false,
          roots: [],
          steps: [],
          errorMessage: 'Unknown method code.',
        );
    }
  }

  String fileName = "";

  Widget theBottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Save Name",
            style: TextStyle(fontSize: 35, color: Color.fromARGB(255, 8, 102, 196), height: 2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              style: TextStyle(
                color: Color.fromARGB(255, 8, 102, 162),
                fontSize: 20,
              ),
              textInputAction: TextInputAction.done,
              cursorColor: Colors.lightBlueAccent,
              textAlign: TextAlign.center,
              onChanged: (value) {
                fileName = value;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 102, 196),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextButton(
              onPressed: () {
                _generateAndOpenPdf();
                Navigator.pop(context);
              },
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.all(Size(100, 50)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 51, 134, 248),
                ),
              ),
              child: Text(
                "Save",
                style: TextStyle(fontSize: 22, color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndOpenPdf() async {
    try {
      await Chapter2AnswerPdfService.generateAndOpen(
        Chapter2PdfPayload(
          methodName: widget.methodName,
          solution: solution,
        ),
      );
      if (!mounted) {
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Failed to generate PDF: $e')),);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TopBar('Answer'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: theBottomSheet(context),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 51, 134, 248),
        child: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 35),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        children: [
          Text(
            widget.methodName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              color: Color.fromARGB(255, 8, 102, 196),
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (!solution.hasSolution)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.red,
              child: Text(
                solution.errorMessage ?? 'No unique solution.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          const SizedBox(height: 10),
          ...solution.steps.map(_buildStepCard),
          if (solution.hasSolution) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 8, 102, 196)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'x1 = ${solution.roots[0].toStringAsFixed(4)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 4, 62, 125),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'x2 = ${solution.roots[1].toStringAsFixed(4)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 4, 62, 125),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'x3 = ${solution.roots[2].toStringAsFixed(4)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 4, 62, 125),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCard(Chapter2Step step) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 8, 102, 196),
              ),
            ),
            if (step.note != null) ...[
              const SizedBox(height: 6),
              Text(step.note!, style: const TextStyle(fontSize: 18, color: Colors.black87)),
            ],
            if (step.snapshots.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...step.snapshots.map((snapshot) => _buildMatrix(snapshot)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMatrix(MatrixSnapshot snapshot) {
    final matrix = snapshot.matrix;
    if (matrix.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: List.generate(
                matrix.first.length,
                (index) {
                  final isLast = index == matrix.first.length - 1;
                  final suffix = snapshot.isAugmented && isLast ? '(b)' : 'C${index + 1}';
                  return DataColumn(
                    label: Text(
                      suffix,
                      style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 8, 102, 196)),
                    ),
                  );
                },
              ),
              rows: List.generate(
                matrix.length,
                (row) => DataRow(
                  cells: List.generate(
                    matrix[row].length,
                    (col) => DataCell(Text(matrix[row][col].toStringAsFixed(4), style: const TextStyle(fontSize: 16))),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
