//import 'package:flutter/material.dart';
import 'package:math_parser/math_parser.dart';
//import 'package:tex_text/tex_text.dart';
void main(){
 //runApp( TestApp());
  final String ff = "-(x^2)+1.8x+2.5";

  num f(double x){
  return MathNodeExpression.fromString(ff, variableNames: {'x'}).calc(
      MathVariableValues({'x': x}));
  }

  double fprim(double x){
    double h=1e-7;
    return(f(x+h)-f(x-h))/(2*h);
  }

  double g(double x){
    double derivative=fprim(x);
    return x-(f(x)/derivative);
  }

  print(g(5));
}

// class TestApp extends StatelessWidget{
//    TestApp ({super.key});
//   final String ff = "(2x)^2+x";
//   late final funcc = MathNodeExpression.fromString(ff, variableNames: {'x'}).calc(
//       MathVariableValues({'x': 2}));
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: TexText(r'$\grabled $ff$'),
//         ),
//       ),
//     );
//   }
// }