import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
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

/// PDF layout aligned with [ShowAnswer] (chapter 1 answer screen).
class AnswerPdfService {
  static const int _titleBlue = 0xFF0866C4;
  static const int _rootBlue = 0xFF043E7D;

  static Future<String> generateAndOpen(AnswerPdfPayload payload) async {
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
    final filePath = '${directory.path}/answer_ch1_${safeName}_$timestamp.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    final openResult = await OpenFilex.open(filePath);
    final openSucceeded = openResult.type == ResultType.done;

    if (openSucceeded) {
      return 'PDF saved and opened: $filePath';
    }
    return 'PDF saved at $filePath, but opening failed: ${openResult.message}';
  }

  static List<pw.Widget> _buildPdfWidgets(AnswerPdfPayload payload) {
    final titleStyle = pw.TextStyle(
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromInt(_titleBlue),
      decoration: pw.TextDecoration.underline,
      decorationColor: PdfColor.fromInt(_titleBlue),
    );
    final mathStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.normal,
      color: PdfColors.grey900,
    );
    final paramStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.normal,
      color: PdfColors.grey900,
    );
    final headerCellStyle = pw.TextStyle(
      fontSize: 11,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromInt(_titleBlue),
    );
    final cellStyle = const pw.TextStyle(fontSize: 10, color: PdfColors.grey900);
    final rootStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromInt(_rootBlue),
    );

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

    final widgets = <pw.Widget>[
      pw.Center(child: pw.Text(payload.methodName, style: titleStyle)),
      pw.SizedBox(height: 12),
      pw.Text('f(x) = ${payload.functionText}', style: mathStyle),
      if (payload.method == 'fi' || payload.method == 'n') ...[
        pw.SizedBox(height: 6),
        pw.Text('g(x) = ${payload.gFunctionText}', style: mathStyle),
      ],
      pw.SizedBox(height: 12),
      _parameterRowPdf(payload, paramStyle),
      pw.SizedBox(height: 12),
    ];

    if (!payload.hasSolution) {
      widgets.add(
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(color: PdfColors.red700),
          child: pw.Text(
            payload.errorMessage ?? 'No solution available.',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.white),
            textAlign: pw.TextAlign.center,
          ),
        ),
      );
      return widgets;
    }

    widgets.add(_iterationTablePdf(headers, tableRows, headerCellStyle, cellStyle));
    widgets.add(pw.SizedBox(height: 12));
    widgets.add(
      pw.Text(
        'Root = ${payload.rootText ?? '-'}',
        style: rootStyle,
      ),
    );

    return widgets;
  }

  static pw.Widget _parameterRowPdf(AnswerPdfPayload payload, pw.TextStyle paramStyle) {
    final children = <pw.Widget>[
      pw.Expanded(
        child: pw.Text(
          '${payload.hintX1} = ${payload.x1}',
          style: paramStyle,
        ),
      ),
    ];
    if (payload.isX2Visible) {
      children.add(
        pw.Expanded(
          child: pw.Text(
            '${payload.hintX2} = ${payload.x2}',
            style: paramStyle,
            textAlign: pw.TextAlign.center,
          ),
        ),
      );
    }
    children.add(
      pw.Expanded(
        child: pw.Text(
          'Error = ${payload.errorTolerance}',
          style: paramStyle,
          textAlign: pw.TextAlign.right,
        ),
      ),
    );
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: children,
    );
  }

  static pw.Widget _iterationTablePdf(
    List<String> headers,
    List<List<String>> data,
    pw.TextStyle headerCellStyle,
    pw.TextStyle cellStyle,
  ) {
    if (headers.isEmpty || data.isEmpty) {
      return pw.SizedBox();
    }
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: headers
              .map(
                (h) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: pw.Text(h, style: headerCellStyle),
                ),
              )
              .toList(),
        ),
        ...data.map(
          (row) => pw.TableRow(
            children: row
                .map(
                  (cell) => pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: pw.Text(cell, style: cellStyle),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
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
