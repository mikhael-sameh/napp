import 'package:flutter/material.dart';

class InputNumber extends StatelessWidget {
  final FocusNode myFocus;
  final FocusNode nextFocus;
  final Function(String) onChange;
  const InputNumber(this.myFocus, this.nextFocus, this.onChange, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: myFocus,
      decoration: InputDecoration(
        hint: Text(".", style: TextStyle(color: Colors.black45)),
        border: InputBorder.none,
      ),
      style: TextStyle(fontSize: 22),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,
      onSubmitted: (value) {
        FocusScope.of(context).requestFocus(nextFocus);
      },
      onChanged: onChange,
    );
  }
}
