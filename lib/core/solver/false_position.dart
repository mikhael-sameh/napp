import 'package:flutter/material.dart';
import 'package:napp/core/utils/the_function.dart';

class FalsePosition{
  double xl,xu,error,xr=0,xrold=0;
  MyFunction fn;
  FalsePosition(this.xl,this.xu,this.error,this.fn);

  List<DataColumn> columns(){
    return  [
      DataColumn(label: Text("i")),
      DataColumn(label: Text("Xl")),
      DataColumn(label: Text("f(Xl)")),
      DataColumn(label: Text("Xu")),
      DataColumn(label: Text("f(Xu)")),
      DataColumn(label: Text("Xr")),
      DataColumn(label: Text("f(Xr)")),
      DataColumn(label: Text("error")),
    ];
  }

  DataRow show(int i, double x1, double fx1, double x2, double fx2, double x3, double fx3, String err) {
    return DataRow(cells: [
      DataCell(Text(i.toString())),
      DataCell(Text(x1.toStringAsFixed(4))),
      DataCell(Text(fx1.toStringAsFixed(4))),
      DataCell(Text(x2.toStringAsFixed(4))),
      DataCell(Text(fx2.toStringAsFixed(4))),
      DataCell(Text(x3.toStringAsFixed(4))),
      DataCell(Text(fx3.toStringAsFixed(4))),
      DataCell(Text(err)),
    ]);
  }

  bool notSolving(){
    return fn.f(xl).toDouble() * fn.f(xu).toDouble() > 0;
  }

  List<DataRow> solving() {
    final rows = <DataRow>[];
    if(fn.f(xl).toDouble() * fn.f(xu).toDouble() > 0){
      return rows;
    }
    double err = 100.0;
    int i = 0;
    do {
      xrold = xr;
      xr = xu-(
          (fn.f(xu)*(xl-xu))/
              (fn.f(xl)-fn.f(xu)
              ));
      // Relative error; avoid division by zero when xr == 0
      if(xr != 0) {
        err = (((xr - xrold) / xr) * 100).abs();
      }
      final errStr = (i == 0) ? '—' : err.toStringAsFixed(3);
      rows.add(show(i, xl, fn.f(xl).toDouble(), xu, fn.f(xu).toDouble(), xr, fn.f(xr).toDouble(), errStr));
      // Bisection: keep the half that contains the root (where f changes sign)
      if (fn.f(xl).toDouble() * fn.f(xr).toDouble() < 0) {
        xu = xr;
      } else {
        xl = xr;
      }
      i++;
    } while(err > error && i<50);
    return rows;
  }

  double getRoot(){
    return xr;
  }

}
