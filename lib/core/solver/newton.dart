import 'package:flutter/material.dart';
import 'package:napp/core/utils/the_function.dart';

class Newton{
  double xi,xiPlus1=0,error;
  MyFunction ff;
  Newton(this.xi,this.error,this.ff);


  List<DataColumn> columns(){
    return  [
      DataColumn(label: Text("i")),
      DataColumn(label: Text("Xi")),
      DataColumn(label: Text("f(Xi)")),
      DataColumn(label: Text("f`(Xi)")),
      DataColumn(label: Text("error")),
    ];
  }

  DataRow show(int i, double xi, double fxi, double fDashxi,  String err) {
    return DataRow(cells: [
      DataCell(Text(i.toString())),
      DataCell(Text(xi.toStringAsFixed(3))),
      DataCell(Text(fxi.toStringAsFixed(3))),
      DataCell(Text(fDashxi.toStringAsFixed(3))),
      DataCell(Text(err)),
    ]);
  }


  List<DataRow> solving() {
    final rows = <DataRow>[];
    double err = 100.0;
    int i = 0;
    double xiOld = 0;
    do {
      xiPlus1=xi-(ff.f(xi)/ff.fPrim(xi));
      if(xiPlus1 != 0) {
        err = (((xi - xiOld) / xi) * 100).abs();
      }
      final errStr = (i == 0) ? '—' : err.toStringAsFixed(3);
      rows.add(show(i, xi, ff.f(xi).toDouble(), ff.fPrim(xi).toDouble(), errStr));
      i++;
      xiOld=xi;
      xi=xiPlus1;
    } while(err > error);
    return rows;
  }
}
