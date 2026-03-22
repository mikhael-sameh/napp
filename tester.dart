import 'package:flutter/material.dart';
import 'package:math_parser/math_parser.dart';
//import 'package:tex_text/tex_text.dart';
void main(){
  runApp( TestApp());
}

class TestApp extends StatefulWidget {
  TestApp({super.key});

  final TextEditingController txc = TextEditingController();
  final String ff = "(2x)^2+x";
  late final funcc = MathNodeExpression
      .fromString(ff, variableNames: {'x'})
      .calc(
      MathVariableValues({'x': 2}));
  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TextField(
              controller: widget.txc,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.txc.text += 'd';
                  });
                },
                child: Text("data")
            )
          ],
        ),
      ),
    );
  }
}