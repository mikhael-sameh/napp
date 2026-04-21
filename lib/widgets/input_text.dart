import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode currentFocus;
  final FocusNode nextFocus;
  final String theHint;
  const InputText(
    this.currentFocus,
    this.nextFocus,
    this.theHint,
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: currentFocus,
      decoration: InputDecoration(
        label: Text(
          theHint,
          style: TextStyle(
            color: Color.fromARGB(255, 35, 123, 216),
            fontSize: 17,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 8, 102, 196),
            width: 1.2,
          ),
        ),
      ),
      cursorColor: Color.fromARGB(255, 8, 102, 196),
      textAlign: TextAlign.center,
      textInputAction: nextFocus == FocusNode()
          ? TextInputAction.done
          : TextInputAction.next,
      keyboardType: TextInputType.number,
      onSubmitted: (value) {
        FocusScope.of(context).requestFocus(nextFocus);
      },
      style: TextStyle(color: Color.fromARGB(255, 8, 102, 162), fontSize: 20),
    );
  }
}
