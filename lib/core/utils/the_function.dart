import 'package:math_parser/math_parser.dart';

class MyFunction{
  late final String fn;
  late final String? fn2=_getGx(fn);
  MyFunction(this.fn);

  num f(double value){
    return MathNodeExpression.fromString(fn, variableNames: {'x'}).calc(
        MathVariableValues({'x': value}));
  }

  double fDash(double x){
    double h = 1e-8;
    return (f(x + h) - f(x - h)) / (2 * h);
  }

  String? _getGx(String func) {
    final regExp = RegExp(r'([+-]?\s*\d*\.?\d*)\s*x\^?(\d*)');
    final matches = regExp.allMatches(func);

    List<Map<String, dynamic>> candidates = [];

    for (final match in matches) {
      try {
        String fullTerm = match.group(0)!;
        String coefPart = match.group(1)?.replaceAll(RegExp(r'\s+'), '') ?? "";
        String powerPart = match.group(2) ?? "";

        double a = 1.0;
        if (coefPart == "-") {
          a = -1.0;
        }
        else if (coefPart.isNotEmpty && coefPart != "+") {
          a = double.parse(coefPart);
        }

        double n = powerPart.isEmpty ? 1.0 : double.parse(powerPart);

        String restExpr = func.replaceFirst(fullTerm, "");
        restExpr = _cleanEquation(restExpr);

        candidates.add({
          "power": n,
          "formula": n == 1.0
              ? "(- ($restExpr)) / $a"
              : "((- ($restExpr)) / $a)^(1 / $n)"
        });
      } catch (e) {
        continue;
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => b["power"].compareTo(a["power"]));

    return candidates.first["formula"];
  }

  String _cleanEquation(String expr) {
    String cleaned = expr.trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('+-', '-')
        .replaceAll('-+', '-')
        .replaceAll('++', '+')
        .replaceAll('--', '+');

    if (cleaned.startsWith('+')) cleaned = cleaned.substring(1).trim();
    if (cleaned.isEmpty || cleaned == "-") return "0";
    if (cleaned.startsWith('-')) cleaned = cleaned;

    return cleaned;
  }

  num gx(double x){
    return MathNodeExpression.fromString(fn2!, variableNames: {'x'}).calc(
        MathVariableValues({'x': x}));
  }

}