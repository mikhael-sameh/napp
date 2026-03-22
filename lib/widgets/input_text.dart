import 'package:flutter/material.dart';


class InputText extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode currentFocus;
  final FocusNode nextFocus;
  final String theHint;
  final bool autoFocus;
   const InputText(this.currentFocus,this.nextFocus,this.theHint,this.autoFocus,this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: currentFocus,
      decoration: InputDecoration(
        label: Text(
          theHint,
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
        //TODO: add lapel style
      ),
      autofocus: autoFocus,
      cursorColor: Color.fromARGB(255, 8, 102, 196),
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      onSubmitted: (value) {
        if(nextFocus==FocusNode()){
          FocusScope.of(context).unfocus();
        }else{
        FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      style: TextStyle(
        color: Color.fromARGB(255, 8, 102, 162),
        fontSize: 20,
      ),
    );
  }
}
