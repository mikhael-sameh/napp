import 'package:flutter/material.dart';
import 'package:napp/screens/answer_screen.dart';
import 'package:napp/widgets/input_text.dart';


class InFuction extends StatefulWidget {
  final String method;
  final String hintX1;
  final bool inX2;
  final String hintX2;
  const InFuction(this.hintX1,this.inX2,this.hintX2,this.method,{super.key});


  @override
  State<InFuction> createState() => _InFuctionState();
}

class _InFuctionState extends State<InFuction> {
  String? func;
  double? x1,x2,err;
  final functionFocus = FocusNode();
  final x1Focus = FocusNode();
  final x2Focus = FocusNode();
  final errorFocus = FocusNode();

  Widget buildInputText2(){
    if(widget.inX2){
      return InputText(x2Focus,errorFocus, widget.hintX2, false, (value) {
        x2 = double.tryParse(value);
      });
    }else{
      return SizedBox.shrink();
    }
  }

  Widget pass(){
    if (widget.method=='fi' || widget.method=='n'){
      return ShowAnswer(func!.trim(), x1!, 0, err!,widget.method);
    }else{
      return ShowAnswer(func!.trim(), x1!, x2!, err!,widget.method);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: Text(
          'What\'s Your Function',
          style: TextStyle(
            color: Color.fromARGB(255, 8, 102, 196),
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        shadowColor: Color.fromARGB(255, 8, 102, 196),
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            InputText(functionFocus,x1Focus, "f(x)", true, (value) {
              func = value;
            }),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  ///         xl      ///////////////
                  child: InputText(x1Focus,widget.inX2? x2Focus: errorFocus, widget.hintX1, false, (value) {
                    x1 = double.tryParse(value);
                  }),
                ),
                SizedBox(width: widget.inX2? 10: 0),
                Expanded(
                  flex: widget.inX2? 2: 0,
                  ///         xu      ///////////////
                  child: buildInputText2(),
                ),
                SizedBox(width: 10),
                Expanded(
                    ///     error     ///////////////
                child: InputText(errorFocus, FocusNode(), "Error", false, (value) {
                  err = double.tryParse(value);
                })
                ),
              ],
            ),

            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => pass(),
                    ),
                  );
              },
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.all(Size(100, 50)),
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
                "Done",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

