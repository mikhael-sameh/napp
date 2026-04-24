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
  late final List<DataColumn> columns;
  void mySolver() {
    switch (widget.method) {
      case 'b':
        solver = Bisection(widget.x1, widget.x2, widget.errr, fn);
        notValid = solver.notSolving();
        if (notValid) {
          errorMSG =
              "Since f(xl) * f(xu) > 0, so the function has not solution";
        } else {
          rows = solver.solving();
          columns = solver.columns();
        }
        break;
      case 'fa':
        solver = FalsePosition(widget.x1, widget.x2, widget.errr, fn);
        notValid = solver.notSolving();
        if (notValid) {
          errorMSG =
              "Since f(xl) * f(xu) > 0, so the function has not solution";
        } else {
          rows = solver.solving();
          columns = solver.columns();
        }
        break;
      case 'fi':
        solver = FixedPoint(widget.x1, widget.errr, fn);
        cantGetGx = solver.canGetGx();
        if (cantGetGx) {
          errorMSG = "Can't get g(x)";
        } else {
          rows = solver.solving();
          columns = solver.columns();
        }
        break;
      case 'n':
        solver = Newton(widget.x1, widget.errr, fn);
        rows = solver.solving();
        columns = solver.columns();
        break;
      case 's':
        solver = Secant(widget.x1, widget.x2, widget.errr, fn);
        rows = solver.solving();
        columns = solver.columns();
        break;
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
            style: TextStyle(fontSize: 35, color: Color.fromARGB(255, 8, 102, 196),height: 2),
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
                backgroundColor: WidgetStateProperty.all( Color.fromARGB(255, 51, 134, 248),
                ),
              ),
              child: Text(
                "Save",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndOpenPdf() async {
    try {
      final hasSolution = !(notValid || cantGetGx);
      final gxText = fn.fn2;
      await AnswerPdfService.generateAndOpen(
        AnswerPdfPayload(
          method: widget.method,
          methodName: widget.methodName,
          fileName: fileName,
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
          columns: hasSolution
              ?  columns
              : const [],
          rows: hasSolution ? rows : const [],
        ),
      );
      if (!mounted) {
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    mySolver();
  }

  @override
  build(BuildContext context) {
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
            const SizedBox(height: 12),
            TexText(
              'f(x) = \$${widget.function}\$',
              mathStyle: MathStyle.textCramped,
              style: TextStyle(
                fontSize: MediaQuery.widthOf(context) / 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            widget.method == "fi" || widget.method == "n"
                ? TexText(
                    'g(x) = \$${fn.fn2}\$',
                    mathStyle: MathStyle.textCramped,
                    style: TextStyle(
                      fontSize: MediaQuery.widthOf(context) / 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  )
                : const SizedBox.shrink(),
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
                    : const SizedBox.shrink(),
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
            const SizedBox(height: 12),
            notValid || cantGetGx
                ? Text(
                    errorMSG,
                    style:const  TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Card(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        dividerThickness: 2,
                        dataTextStyle: const TextStyle(fontSize: 18),
                        headingTextStyle: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 8, 102, 196),
                        ),
                        columns: columns,
                        rows: rows,
                      ),
                    ),
                  ),
            notValid || cantGetGx
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      const SizedBox(height: 12),
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
