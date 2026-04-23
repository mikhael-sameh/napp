import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class AnswerPdfPayload {
  final String method;
  final String methodName;
  final String functionText;
  final String gFunctionText;
  final String hintX1;
  final String hintX2;
  final double x1;
  final double x2;
  final double errorTolerance;
  final bool isX2Visible;
  final bool hasSolution;
  final String? errorMessage;
  final String? rootText;
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const AnswerPdfPayload({
    required this.method,
    required this.methodName,
    required this.functionText,
    required this.gFunctionText,
    required this.hintX1,
    required this.hintX2,
    required this.x1,
    required this.x2,
    required this.errorTolerance,
    required this.isX2Visible,
    required this.hasSolution,
    required this.columns,
    required this.rows,
    this.errorMessage,
    this.rootText,
  });
}

class AnswerPdfService {
  static Future<String> generateAndOpen(AnswerPdfPayload payload) async {
    final headers = payload.hasSolution
        ? payload.columns.map((column) => _extractWidgetText(column.label)).toList()
        : <String>[];
    final tableRows = payload.hasSolution
        ? payload.rows
            .map(
              (row) => row.cells
                  .map((cell) => _extractWidgetText(cell.child))
                  .toList(),
            )
            .toList()
        : <List<String>>[];

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            payload.methodName,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text('f(x): ${payload.functionText}'),
          payload.method=="fi" || payload.method=="n"?pw.Text('g(x): ${payload.gFunctionText}'):pw.SizedBox.shrink(),
          pw.SizedBox(height: 10),
          pw.Text('${payload.hintX1}: ${payload.x1}'),
          if (payload.isX2Visible) pw.Text('${payload.hintX2}: ${payload.x2}'),
          pw.Text('Error: ${payload.errorTolerance}'),
          pw.SizedBox(height: 14),
          if (payload.hasSolution)
            pw.Text(
              'Root: ${payload.rootText ?? '-'}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            )
          else
            pw.Text(
              payload.errorMessage ?? 'No solution available.',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          if (payload.hasSolution) pw.SizedBox(height: 14),
          if (payload.hasSolution)
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: tableRows,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
            ),
        ],
      ),
    );

    final now = DateTime.now();
    final timestamp =
        '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/answer_${payload.methodName}_$timestamp.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    final openResult = await OpenFilex.open(filePath);
    final openSucceeded = openResult.type == ResultType.done;

    if (openSucceeded) {
      return 'PDF saved and opened: $filePath';
    }
    return 'PDF saved at $filePath, but opening failed: ${openResult.message}';
  }

  static String _extractWidgetText(Widget widget) {
    if (widget is Text) {
      return widget.data ?? widget.textSpan?.toPlainText() ?? '-';
    }
    if (widget is RichText) {
      return widget.text.toPlainText();
    }
    return widget.toStringShort();
  }
}
