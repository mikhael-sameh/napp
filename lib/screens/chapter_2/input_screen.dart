import 'package:flutter/material.dart';
import 'package:napp/screens/chapter_2/answer_screen.dart';
import 'package:napp/widgets/app_bar.dart';
import 'package:napp/widgets/input_data.dart';

class InputSystem extends StatelessWidget {
  final String method;
  final String methodName;
  InputSystem(this.method,this.methodName, {super.key});

  final FocusNode x11 = FocusNode();
  final FocusNode x12 = FocusNode();
  final FocusNode x13 = FocusNode();

  final FocusNode x21 = FocusNode();
  final FocusNode x22 = FocusNode();
  final FocusNode x23 = FocusNode();

  final FocusNode x33 = FocusNode();
  final FocusNode x31 = FocusNode();
  final FocusNode x32 = FocusNode();

  final FocusNode b1 = FocusNode();
  final FocusNode b2 = FocusNode();
  final FocusNode b3 = FocusNode();

  late final List<List<double>> a = List.generate(3, (_) => List.generate(4, (_) => 0.0),);

  double parseNumbers(String t) {
    if (t.contains("/")) {
      final parts = t.split("/");
      final num = double.tryParse(parts[0].trim())!;
      final den = double.tryParse(parts[1].trim())!;
      return num / den;
    } else {
      return double.tryParse(t.trim())!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const TopBar("What's your system"),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Text(
                  methodName,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 8, 102, 196),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: (MediaQuery.of(context).viewInsets.bottom) / .5,
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: const TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 8, 102, 196),
                        ),
                        dataTextStyle: const TextStyle(fontSize: 20),
                        columns: [
                          DataColumn(label: Text("X1")),
                          DataColumn(label: Text("X2")),
                          DataColumn(label: Text("X3")),
                          DataColumn(label: Text("b")),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(InputNumber(x11, x21, (v) => a[0][0] = parseNumbers(v),),),
                              DataCell(InputNumber(x21, x31, (v) => a[0][1] = parseNumbers(v),),),
                              DataCell(InputNumber(x31, b1, (v) => a[0][2] = parseNumbers(v),),),
                              DataCell(InputNumber(b1, x12, (v) => a[0][3] = parseNumbers(v),),),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(InputNumber(x12, x22, (v) => a[1][0] = parseNumbers(v),),),
                              DataCell(InputNumber(x22, x32, (v) => a[1][1] = parseNumbers(v),),),
                              DataCell(InputNumber(x32, b2, (v) => a[1][2] = parseNumbers(v),),),
                              DataCell(InputNumber(b2, x13, (v) => a[1][3] = parseNumbers(v),),),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(InputNumber(x13, x23, (v) => a[2][0] = parseNumbers(v),),),
                              DataCell(InputNumber(x23, x33, (v) => a[2][1] = parseNumbers(v),),),
                              DataCell(InputNumber(x33, b3, (v) => a[2][2] = parseNumbers(v),),),
                              DataCell(InputNumber(b3, FocusNode(), (v) => a[2][3] = parseNumbers(v),),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                final matrix = a.map((row) => List<double>.from(row)).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chapter2AnswerScreen(
                      method: method,
                      methodName: methodName,
                      matrix: matrix,
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.all(Size(120, 50)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(
                  Color.fromARGB(255, 8, 102, 196),
                ),
              ),
              child: Text(
                "Calculate",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
