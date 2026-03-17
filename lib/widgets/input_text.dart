import 'package:flutter/material.dart';


class InputText extends StatelessWidget {

  final FocusNode currentFocus;
  final FocusNode nextFocus;
  final String theHint;
  final bool autoFocus;
  final Function(String)? onChange;
  const InputText(this.currentFocus,this.nextFocus,this.theHint,this.autoFocus,this.onChange, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: currentFocus,
      onTapOutside: (covariant) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        hint: Text(
          theHint,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
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
      autofocus: autoFocus,///  ////////////////////
      cursorColor: Color.fromARGB(255, 8, 102, 196),
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.next,
      onSubmitted: (value) {
        if(nextFocus==FocusNode()){
          FocusScope.of(context).unfocus();
        }else{
        FocusScope.of(context).requestFocus(nextFocus); /// ////////////////
        }
      },
      onChanged: onChange,
      style: TextStyle(
        color: Color.fromARGB(255, 8, 102, 162),
        fontSize: 20,
      ),
    );
  }
}
