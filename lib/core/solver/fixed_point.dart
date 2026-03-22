import 'package:flutter/material.dart';
import 'package:napp/core/utils/the_function.dart';

class FixedPoint{
  double xi,xiPlus1=0,error;
  MyFunction f1;
  MyFunction f2;
  FixedPoint(this.xi,this.error,this.f1,this.f2);


  List<DataColumn> columns(){
    return  [
      DataColumn(label: Text("i")),
      DataColumn(label: Text("Xi")),
      DataColumn(label: Text("f(Xi)")),
      DataColumn(label: Text("error")),
    ];
  }

  DataRow show(int i, double xi, double fxi, String err) {
    return DataRow(cells: [
      DataCell(Text(i.toString())),
      DataCell(Text(xi.toStringAsFixed(4))),
      DataCell(Text(fxi.toStringAsFixed(4))),
      DataCell(Text(err)),
    ]);
  }


  List<DataRow> solving() {
    final rows = <DataRow>[];
    double err = 100.0;
    int i = 0;
    do {
      xiPlus1=f2.f(xi).toDouble();
      if(i != 0) {
        err = (((xiPlus1 - xi) / xiPlus1) * 100).abs();
      }
      final errStr = (i == 0) ? '—' : err.toStringAsFixed(3);
      rows.add(show(i, xi, xiPlus1, errStr));
      i++;
      xi=xiPlus1;
    } while(err > error);
    return rows;
  }
}
