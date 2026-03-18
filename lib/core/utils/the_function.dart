import 'package:math_parser/math_parser.dart';

class MyFunction{
  final String _fn;
  MyFunction(String fn):_fn=fn;

  num f(double value){
    return MathNodeExpression.fromString(_fn, variableNames: {'x'}).calc(
        MathVariableValues({'x': value}));
  }


  num fPrim(double x){
    double h=1e-7;
    return(f(x+h)-f(x-h))/(2*h);
  }
}