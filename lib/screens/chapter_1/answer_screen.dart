import 'package:flutter/material.dart';
import 'package:napp/core/solver/chapter_1/bisection.dart';
import 'package:napp/core/solver/chapter_1/false_position.dart';
import 'package:napp/core/solver/chapter_1/fixed_point.dart';
import 'package:napp/core/solver/chapter_1/newton.dart';
import 'package:napp/core/solver/chapter_1/secant.dart';
import 'package:napp/core/utils/the_function.dart';
import 'package:napp/core/services/chapter1_pdf_service.dart';
import 'package:napp/widgets/app_bar.dart';
import 'package:tex_text/tex_text.dart';

class ShowAnswer extends StatefulWidget {
  final String method, methodName, fx, hintX1, hintX2;
  final double x1, x2, errr;
  final bool isX2;
  ShowAnswer(
    this.fx,
    this.x1,
    this.x2,
    this.errr,
    this.method,
    this.methodName,
    this.hintX1,
    this.hintX2,
    this.isX2, {
    super.key,
  });
  late final String function = fx.replaceAllMapped(
    RegExp(r'(^|[^0-9])\.(?=[0-9])'),
    (m) => '${m.group(1)}0.',
  );
  @override
  State<ShowAnswer> createState() => _ShowAnswerState();
}

class _ShowAnswerState extends State<ShowAnswer> {
  late final MyFunction fn = MyFunction(widget.function);
  bool notValid = false;
  bool cantGetGx = false;
  String errorMSG = "";
  late dynamic solver;
  late final List<DataRow> rows;
  void mySolver() {
    switch (widget.method) {
      case 'b':
        solver = Bisection(widget.x1, widget.x2, widget.errr, fn);
        notValid = solver.notSolving();
        if (notValid) {
          errorMSG = "Since f(xl) * f(xu) > 0, so the function has not solution";
        }else{
          rows=solver.solving();
        }
        break;
      case 'fa':
        solver = FalsePosition(widget.x1, widget.x2, widget.errr, fn);
        notValid = solver.notSolving();
        if (notValid) {
          errorMSG = "Since f(xl) * f(xu) > 0, so the function has not solution";
        }else{
          rows=solver.solving();
        }
        break;
      case 'fi':
        solver = FixedPoint(widget.x1, widget.errr, fn);
        cantGetGx = solver.canGetGx();
        if (cantGetGx) {
          errorMSG = "Can't get g(x)";
        }else{
          rows=solver.solving();
        }
        break;
      case 'n':
        solver = Newton(widget.x1, widget.errr, fn);
        rows=solver.solving();
        break;
      case 's':
        solver = Secant(widget.x1, widget.x2, widget.errr, fn);
        rows=solver.solving();
        break;
    }
  }


  Future<void> _generateAndOpenPdf() async {
    try {
      final hasSolution = !(notValid || cantGetGx);
      final gxText =fn.fn2;
      await AnswerPdfService.generateAndOpen(
        AnswerPdfPayload(
          method: widget.method,
          methodName: widget.methodName,
          functionText: widget.function,
          gFunctionText: gxText!,
          hintX1: widget.hintX1,
          hintX2: widget.hintX2,
          x1: widget.x1,
          x2: widget.x2,
          errorTolerance: widget.errr,
          isX2Visible: widget.isX2,
          hasSolution: hasSolution,
          errorMessage: hasSolution ? null : errorMSG,
          rootText: hasSolution ? solver.getRoot().toStringAsFixed(4) : null,
          columns: hasSolution ? (solver.columns() as List<DataColumn>) : const [],
          rows: hasSolution ? (rows) : const [],
        ),
      );
      if (!mounted) {
        return;
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
    } finally {
    }
  }

  @override
  void initState() {
    super.initState();
    mySolver();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TopBar('Answer'),
      floatingActionButton: FloatingActionButton(
        onPressed:  _generateAndOpenPdf,
        backgroundColor: Color.fromARGB(255, 51, 134, 248),
        child: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 35),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: ListView(
          children: [
            Text(
              widget.methodName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 8, 102, 196),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12),
            TexText(
              'f(x) = \$${widget.function}\$',
              mathStyle: MathStyle.textCramped,
              style: TextStyle(
                fontSize: MediaQuery.widthOf(context) / 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
           widget.method=="fi" || widget.method=="n"? TexText(
              'g(x) = \$${fn.fn2}\$',
              mathStyle: MathStyle.textCramped,
              style: TextStyle(
                fontSize: MediaQuery.widthOf(context) / 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ):SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.hintX1} = ${widget.x1}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                widget.isX2
                    ? Text(
                        "${widget.hintX2} = ${widget.x2}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      )
                    : SizedBox.shrink(),
                Text(
                  "Error = ${widget.errr}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            notValid || cantGetGx
                ? Text(
                    errorMSG,
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dividerThickness: 2,
                      dataTextStyle: const TextStyle(fontSize: 18),
                      headingTextStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 8, 102, 196),
                      ),
                      columns: solver.columns(),
                      rows: rows,
                    ),
                  ),
            notValid || cantGetGx
                ? SizedBox.shrink()
                : Column(
                    children: [
                      SizedBox(height: 12),
                      Text(
                        "Root = ${solver.getRoot().toStringAsFixed(4)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 4, 62, 125),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
