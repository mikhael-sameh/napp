import 'package:flutter/material.dart';
import 'package:napp/core/utils/the_function.dart';

class Secant {
  double xi,xi_1,error;
  MyFunction ff;
  Secant(this.xi_1,this.xi,this.error,this.ff);


  List<DataColumn> columns(){
    return  [
      DataColumn(label: Text("i")),
      DataColumn(label: Text("Xi-1")),
      DataColumn(label: Text("f(Xi-1)")),
      DataColumn(label: Text("Xi")),
      DataColumn(label: Text("f(Xi)")),
      DataColumn(label: Text("error")),
    ];
  }

  DataRow show(int i, double xiMinus1, double fxiMinus1,double xi, double fxi,  String err) {
    return DataRow(cells: [
      DataCell(Text(i.toString())),
      DataCell(Text(xiMinus1.toStringAsFixed(4))),
      DataCell(Text(fxiMinus1.toStringAsFixed(4))),
      DataCell(Text(xi.toStringAsFixed(4))),
      DataCell(Text(fxi.toStringAsFixed(4))),
      DataCell(Text(err)),
    ]);
  }


  List<DataRow> solving() {
    final rows = <DataRow>[];
    double err = 100.0;
    int i = 0;
    double xiNext=0;
    do {
      xiNext=xi-((ff.f(xi)*(xi_1-xi))/(ff.f(xi_1)-ff.f(xi)));
      if(xi != 0) {
        err = (((xi - xi_1) / xi) * 100).abs();
      }
      final errStr = (i == 0) ? '—' : err.toStringAsFixed(3);
      rows.add(show(i, xi_1,ff.f(xi_1).toDouble(), xi, ff.f(xi).toDouble(), errStr));
      xi_1=xi;
      xi=xiNext;
      i++;
    } while(err > error);
    return rows;
  }
}
