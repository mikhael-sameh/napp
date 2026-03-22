import 'package:math_parser/math_parser.dart';

class MyFunction{
  late String fn;
  MyFunction(this.fn);

  num f(double value){
    return MathNodeExpression.fromString(fn, variableNames: {'x'}).calc(
        MathVariableValues({'x': value}));
  }
}