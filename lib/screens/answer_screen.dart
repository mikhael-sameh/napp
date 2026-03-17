import 'package:flutter/material.dart';
import 'package:napp/core/utils/the_function.dart';
import 'package:napp/core/solver/bisection.dart';
import 'package:napp/core/solver/false_position.dart';
import 'package:tex_text/tex_text.dart';

class ShowAnswer extends StatefulWidget {
  final String func;
  final String method;
  final double x1, x2, errr;
  const ShowAnswer(this.func, this.x1, this.x2, this.errr,this.method , {super.key});

  @override
  State<ShowAnswer> createState() => _ShowAnswerState();
}

class _ShowAnswerState extends State<ShowAnswer> {
  late final MyFunction ff = MyFunction(widget.func);
  late Bisection bisection;

  late dynamic solver;

  void mySolver() {
    // 2. تحديد الكلاس بناءً على التاب (method)
    switch (widget.method) {
      case 'b': // Bisection
        solver = Bisection(widget.x1, widget.x2, widget.errr, ff);
        break;
      case 'fa': // مثال: False Position
        solver = FalsePosition(widget.x1, widget.x2, widget.errr, ff);
        break;
      case 'n': // مثال: Newton Raphson
      // solver = NewtonRaphson(widget.x1, widget.errr, ff); // قد تختلف المعاملات
        break;
      default:
      // يجب وضع قيمة افتراضية أو التعامل مع الخطأ
        solver = Bisection(widget.x1, widget.x2, widget.errr, ff);
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
            TexText('f(x) = \$${widget.func}\$',
            mathStyle: MathStyle.display,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black87
            ),
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