import 'package:flutter/material.dart';
import 'package:napp/core/utils/the_function.dart';
import 'package:napp/core/solver/bisection.dart';
import 'package:napp/core/solver/false_position.dart';
import 'package:napp/core/solver/newton.dart';
import 'package:napp/core/solver/secant.dart';
import 'package:napp/core/solver/fixed_point.dart';
import 'package:tex_text/tex_text.dart';
import 'package:napp/widgets/app_bar.dart';

class ShowAnswer extends StatefulWidget {
  final String method, methodName, fx1, fx2, hintX1, hintX2;
  final double x1, x2, errr;
  final bool isX2;
  ShowAnswer(
    this.fx1,
    this.fx2,
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
  late final String function1 = fx1.replaceAllMapped(
    RegExp(r'(^|[^0-9])\.(?=[0-9])'),
    (m) => '${m.group(1)}0.',
  );
  late final String function2 = fx2.replaceAllMapped(
    RegExp(r'(^|[^0-9])\.(?=[0-9])'),
    (m) => '${m.group(1)}0.',
  );
  @override
  State<ShowAnswer> createState() => _ShowAnswerState();
}

class _ShowAnswerState extends State<ShowAnswer> {
  late final MyFunction f1 = MyFunction(widget.function1);
  late final MyFunction f2 = MyFunction(widget.function2);
  bool notValid = false;
  late dynamic solver;
  void mySolver() {
    switch (widget.method) {
      case 'b':
        solver = Bisection(widget.x1, widget.x2, widget.errr, f1);
        notValid = solver.notSolving();
        break;
      case 'fa':
        solver = FalsePosition(widget.x1, widget.x2, widget.errr, f1);
        notValid = solver.notSolving();

        break;
      case 'fi':
        solver = FixedPoint(widget.x1, widget.errr, f1, f2);
        break;
      case 'n':
        solver = Newton(widget.x1, widget.errr, f1, f2);
        break;
      case 's':
        solver = Secant(widget.x1, widget.x2, widget.errr, f1);
        break;
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
              'f(x) = \$${widget.function1}\$',
              mathStyle: MathStyle.textCramped,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            widget.fx2 == ""
                ? SizedBox(height: 12)
                : TexText(
                    'x = \$${widget.function2}\$',
                    mathStyle: MathStyle.textCramped,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
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
            notValid
                ? Text(
                    "Since f(xl) * f(xu) > 0, so the function has not solution",
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
                      dataTextStyle: TextStyle(fontSize: 18),
                      headingTextStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 8, 102, 196),
                      ),
                      columns: solver.columns(),
                      rows: solver.solving(),
                    ),
                  ),
            notValid
                ?SizedBox.shrink():
            Column(
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
