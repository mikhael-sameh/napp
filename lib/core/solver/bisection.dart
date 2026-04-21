import 'package:flutter/material.dart';
import 'package:napp/core/utils/the_function.dart';

class Bisection{
  double xl,xu,error,xr=0,xrold=0;
  MyFunction ff;
  Bisection(this.xl,this.xu,this.error,this.ff);
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
    return ff.f(xl).toDouble() * ff.f(xu).toDouble() > 0;
  }

  List<DataRow> solving() {
    final rows = <DataRow>[];
    double err = 100.0;
    int i = 0;
    do {
      xrold = xr;
      xr = (xl + xu) / 2;
      if(xr != 0) {
         err = (((xr - xrold) / xr) * 100).abs();
      }
      final errStr = (i == 0) ? '—' : err.toStringAsFixed(3);
      rows.add(show(i, xl, ff.f(xl).toDouble(), xu, ff.f(xu).toDouble(), xr, ff.f(xr).toDouble(), errStr));
      if (ff.f(xl).toDouble() * ff.f(xr).toDouble() < 0) {
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
