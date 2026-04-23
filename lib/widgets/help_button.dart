import 'package:flutter/material.dart';
class HelpButton extends StatelessWidget{
  final FocusNode function1Focus;

 final TextEditingController function1;

 final String helper;
 final int type;
  const HelpButton(this.function1,this.function1Focus,this.helper,this.type,{super.key});

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
            String temp2 = function1.text.substring(function1.selection.end);
            int len = temp.length + helper.length ;
            temp+=helper;
            temp+=temp2;
            function1.value=TextEditingValue(text: temp,selection: TextSelection.fromPosition(TextPosition(offset:type==1? len:len-1)));
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
  }
}