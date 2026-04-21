import 'package:flutter/material.dart';
import 'package:napp/core/utils/the_function.dart';
import 'package:napp/core/solver/bisection.dart';
import 'package:napp/core/solver/false_position.dart';
import 'package:napp/core/solver/newton.dart';
import 'package:napp/core/solver/secant.dart';
import 'package:napp/core/solver/fixed_point.dart';
import 'package:tex_text/tex_text.dart';

class ShowAnswer extends StatefulWidget {
  final String fx1;
  final String fx2;
  final String method;
  final double x1, x2, errr;
  ShowAnswer(this.fx1,this.fx2 ,this.x1, this.x2, this.errr,this.method , {super.key});
  late final String function1 = fx1.replaceAllMapped(
  RegExp(r'(^|[^0-9])\.(?=[0-9])'),
  (m) => '${m.group(1)}0.',);
  late final String function2 = fx2.replaceAllMapped(
  RegExp(r'(^|[^0-9])\.(?=[0-9])'),
  (m) => '${m.group(1)}0.',);
  @override
  State<ShowAnswer> createState() => _ShowAnswerState();
}

class _ShowAnswerState extends State<ShowAnswer> {
  late final MyFunction f1 = MyFunction(widget.function1);
  late final MyFunction f2 = MyFunction(widget.function2);
  late dynamic solver;

  void mySolver() {
    switch (widget.method) {
      case 'b':
        solver = Bisection(widget.x1, widget.x2, widget.errr, f1);
        break;
      case 'fa':
        solver = FalsePosition(widget.x1, widget.x2, widget.errr, f1);
        break;
      case 'fi':
        solver = FixedPoint(widget.x1, widget.errr, f1,f2);
        break;
      case 'n':
        solver = Newton(widget.x1, widget.errr, f1,f2);
        break;
      case 's':
        solver = Secant(widget.x1, widget.x2, widget.errr, f1);
        break;
      default:
        solver = Bisection(widget.x1, widget.x2, widget.errr, f1);
    }
  }
@override
  void initState() {
    super.initState();
    mySolver();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title:  Text(
          'Answer',
          style: TextStyle(
            color: Color.fromARGB(255, 8, 102, 196),
            fontWeight: FontWeight.w700,
            fontSize: 40,
          ),
        ),
        centerTitle: true,
        shadowColor: Color.fromARGB(255, 8, 102, 196),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
        child: ListView(
          children: [
            TexText('f(x) = \$${widget.function1}\$',
            mathStyle: MathStyle.textCramped,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black87),
            ),
            widget.fx2==""? SizedBox.shrink():TexText('x = \$${widget.function2}\$',
              mathStyle: MathStyle.textCramped,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 10.0),
              child: DataTable(
                dividerThickness: 2,
                dataTextStyle: TextStyle(fontSize: 18),
                headingTextStyle: TextStyle(fontSize: 20,color: Color.fromARGB(250, 38, 12, 200)),
                columns: solver.columns(),
                rows: solver.solving(),
              ),
          ),]
        ),
      ),
    );
  }
}