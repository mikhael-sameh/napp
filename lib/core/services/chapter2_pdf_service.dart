import 'dart:io';

import 'package:napp/core/utils/solver_models.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Chapter2PdfPayload {
  final String methodName;
  final Chapter2Solution solution;

  const Chapter2PdfPayload({
    required this.methodName,
    required this.solution,
  });
}

class Chapter2AnswerPdfService {
  static Future<String> generateAndOpen(Chapter2PdfPayload payload) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(28),
        build: (context) => _buildPdfWidgets(payload),
      ),
    );

    final now = DateTime.now();
    final timestamp =
        '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    final safeName = payload.methodName.replaceAll(RegExp(r'[^\w\-]+'), '_');
    Directory? directory = await getDownloadsDirectory();
    directory ??= await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/answer_ch2_${safeName}_$timestamp.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    final openResult = await OpenFilex.open(filePath);
    final openSucceeded = openResult.type == ResultType.done;

    if (openSucceeded) {
      return 'PDF saved and opened: $filePath';
    }
    return 'PDF saved at $filePath, but opening failed: ${openResult.message}';
  }

  static List<pw.Widget> _buildPdfWidgets(Chapter2PdfPayload payload) {
    final s = payload.solution;
    final titleStyle = pw.TextStyle(
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromInt(0xFF0866C4),
    );
    final stepTitleStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromInt(0xFF0866C4),
    );
    final noteStyle = const pw.TextStyle(fontSize: 10);
    final headerCellStyle = pw.TextStyle(
      fontSize: 9,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromInt(0xFF0866C4),
    );
    final cellStyle = const pw.TextStyle(fontSize: 9);

    final widgets = <pw.Widget>[
      pw.Center(
        child: pw.Text(payload.methodName, style: titleStyle),
      ),
      pw.SizedBox(height: 14),
    ];

    if (!s.hasSolution) {
      widgets.add(
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(color: PdfColors.red700),
          child: pw.Text(
            s.errorMessage ?? 'No unique solution.',
            style: pw.TextStyle(fontSize: 11, color: PdfColors.white),
            textAlign: pw.TextAlign.center,
          ),
        ),
      );
      widgets.add(pw.SizedBox(height: 10));
    }

    for (final step in s.steps) {
      widgets.add(_stepCardPdf(
        step: step,
        stepTitleStyle: stepTitleStyle,
        noteStyle: noteStyle,
        headerCellStyle: headerCellStyle,
        cellStyle: cellStyle,
      ));
      widgets.add(pw.SizedBox(height: 8));
    }

    if (s.hasSolution && s.roots.length == 3) {
      widgets.add(
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColor.fromInt(0xFF0866C4), width: 1),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'x1 = ${_fmt(s.roots[0])}',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF043E7D),
                ),
              ),
              pw.Text(
                'x2 = ${_fmt(s.roots[1])}',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF043E7D),
                ),
              ),
              pw.Text(
                'x3 = ${_fmt(s.roots[2])}',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF043E7D),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  static pw.Widget _stepCardPdf({
    required Chapter2Step step,
    required pw.TextStyle stepTitleStyle,
    required pw.TextStyle noteStyle,
    required pw.TextStyle headerCellStyle,
    required pw.TextStyle cellStyle,
  }) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 2),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColors.grey400, width: 0.8),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(step.title, style: stepTitleStyle),
          if (step.note != null) ...[
            pw.SizedBox(height: 4),
            pw.Text(step.note!, style: noteStyle),
          ],
          if (step.snapshots.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            ...step.snapshots.expand(
              (snap) => [
                _matrixTablePdf(
                  snap: snap,
                  headerCellStyle: headerCellStyle,
                  cellStyle: cellStyle,
                ),
                pw.SizedBox(height: 6),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _matrixTablePdf({
    required MatrixSnapshot snap,
    required pw.TextStyle headerCellStyle,
    required pw.TextStyle cellStyle,
  }) {
    if (snap.matrix.isEmpty) {
      return pw.SizedBox();
    }
    final cols = snap.matrix.first.length;
    final headers = List.generate(cols, (i) {
      final isLast = i == cols - 1;
      if (snap.isAugmented && isLast) {
        return '(b)';
      }
      return 'C${i + 1}';
    });

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          snap.label,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 3),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.4),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: headers
                  .map(
                    (h) => pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(h, style: headerCellStyle),
                    ),
                  )
                  .toList(),
            ),
            ...snap.matrix.map(
              (row) => pw.TableRow(
                children: row
                    .map(
                      (v) => pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(_fmt(v), style: cellStyle),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _fmt(double value) {
    if (value.abs() < 1e-10) {
      return '0.0000';
    }
    return value.toStringAsFixed(4);
  }
}
