import 'package:flutter/material.dart';
class HelpButton extends StatelessWidget{
  final FocusNode function1Focus;
  final FocusNode function2Focus;

 final TextEditingController function1;
 final TextEditingController function2;

 final String helper;
  const HelpButton(this.function1,this.function2,this.function1Focus,this.function2Focus,this.helper,{super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            const Color.fromARGB(255, 51, 134, 248),
          ),
        ),
        onPressed: () {
          if(FocusManager.instance.primaryFocus==function1Focus){
            String temp = function1.text.substring(0,function1.selection.end);
            int len = temp.length;
            String temp2 = function1.text.substring(function1.selection.end);
            temp+=helper;
            temp+=temp2;
            function1.value=TextEditingValue(text: temp,selection: TextSelection.fromPosition(TextPosition(offset: len+1)));
          }else if(FocusManager.instance.primaryFocus==function2Focus){
            String temp = function2.text.substring(0,function2.selection.end);
            int len = temp.length;
            String temp2 = function2.text.substring(function2.selection.end);
            temp+=helper;
            temp+=temp2;
            function2.value=TextEditingValue(text: temp,selection: TextSelection.fromPosition(TextPosition(offset: len+1)));
          }
        },
        child:Text(
          helper,
          style: TextStyle(fontSize: 25, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  void deactivate() {
    function1Focus.dispose();
    function2Focus.dispose();
  }
}