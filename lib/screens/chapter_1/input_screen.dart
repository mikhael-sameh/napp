import 'package:flutter/material.dart';
import 'package:napp/screens/answer_screen.dart';
import 'package:napp/widgets/input_text.dart';
import 'package:napp/widgets/help_button.dart';


class InFuction extends StatefulWidget {
  final String method;
  final String hintX1;
  final bool isX2;
  final String hintX2;
  const InFuction(
    this.hintX1,
    this.isX2,
    this.hintX2,
    this.method, {
    super.key,
  });

  @override
  State<InFuction> createState() => _InFuctionState();
}

class _InFuctionState extends State<InFuction> {
  TextEditingController func1Controller = TextEditingController();
  TextEditingController func2Controller = TextEditingController();
  TextEditingController x1Controller = TextEditingController();
  TextEditingController x2Controller = TextEditingController();
  TextEditingController errController = TextEditingController();
  final function1Focus = FocusNode();
  final function2Focus = FocusNode();
  final x1Focus = FocusNode();
  final x2Focus = FocusNode();
  final errorFocus = FocusNode();
  Widget buildInputFX2() {
    if (widget.method == 'n') {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: InputText(
          function2Focus,
          x1Focus,
          "f'(x)",
          func2Controller,
        ),
      );
    } else if (widget.method == 'fi') {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: InputText(function2Focus, x1Focus, "x", func2Controller),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildInputX2() {
    if (widget.isX2) {
      return InputText(x2Focus, errorFocus, widget.hintX2, x2Controller);
    } else {
      return SizedBox.shrink();
    }
  }

  void showInputError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void onCalculatePressed() {
    final func = func1Controller.text.trim();
    final func2 = func2Controller.text.trim();
    final x1 = double.tryParse(x1Controller.text.trim());
    final err = double.tryParse(errController.text.trim());
    final x2 = widget.isX2 ? double.tryParse(x2Controller.text.trim()) : 0.0;

    if (func.isEmpty) {
      showInputError('Please enter f(x).');
      return;
    }
    if (widget.method == 'fi' && func2.isEmpty) {
      showInputError('Please enter x.');
      return;
    }
    if (widget.method == 'n' && func2.isEmpty) {
      showInputError('Please enter f`(x).');
      return;
    }
    if (x1 == null) {
      showInputError('Please enter a valid ${widget.hintX1}.');
      return;
    }
    if (widget.isX2 && x2 == null) {
      showInputError('Please enter a valid ${widget.hintX2}.');
      return;
    }
    if (err == null || err <= 0) {
      showInputError('Please enter a valid error value > 0.');
      return;
    }
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) {
            if (widget.isX2) {
              return ShowAnswer(func, "", x1, x2!, err, widget.method);
            } else if (widget.method == 'n' || widget.method == 'fi') {
              return ShowAnswer(func, func2, x1, 0, err, widget.method);
            } else {
              return ShowAnswer(func, "", x1, 0, err, widget.method);
            }
          },
        ),
      );
  }
@override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if(mounted){
        function1Focus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: Color.fromARGB(255, 8, 102, 196),
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          shadowColor: Color.fromARGB(255, 8, 102, 196),
          elevation: 4,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom:
                              (MediaQuery.of(context).viewInsets.bottom) / 4,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InputText(
                              function1Focus,
                              widget.method=='fi' || widget.method=='n' ? function2Focus : x1Focus,
                              "f(x)",
                              func1Controller,
                            ),
                            buildInputFX2(),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,

                                  ///         xl      ///////////////
                                  child: InputText(
                                    x1Focus,
                                    widget.isX2 ? x2Focus : errorFocus,
                                    widget.hintX1,
                                    x1Controller,
                                  ),
                                ),
                                SizedBox(width: widget.isX2 ? 5 : 0),
                                Expanded(
                                  flex: widget.isX2 ? 2 : 0,

                                  ///         xu      ///////////////
                                  child: buildInputX2(),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  ///     error     ///////////////
                                  child: InputText(
                                    errorFocus,
                                    FocusNode(),
                                    "Error",
                                    errController,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: onCalculatePressed,
                              style: ButtonStyle(
                                fixedSize: WidgetStateProperty.all(
                                  Size(120, 50),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                  Color.fromARGB(255, 8, 102, 196),
                                ),
                              ),
                              child: Text(
                                "Calculate",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "x" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "^" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "+" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "-" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "*" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "/" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "(" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, ")" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "{" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "}" ,1),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "sin()" ,2),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "cos()" ,2),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "tan()" ,2),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "e()" ,2),
                    HelpButton(func1Controller, func2Controller, function1Focus, function2Focus, "ln()" ,2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    func1Controller.dispose();
    func2Controller.dispose();
    x1Controller.dispose();
    x2Controller.dispose();
    errController.dispose();
    function1Focus.dispose();
    function2Focus.dispose();
    x1Focus.dispose();
    x2Focus.dispose();
    errorFocus.dispose();
    super.dispose();
  }
}
