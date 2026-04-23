import 'package:flutter/material.dart';
import 'package:napp/screens/chapter_1/input_screen.dart';
import 'package:napp/screens/chapter_2/input_screen.dart';

class MethodsCard extends StatelessWidget {
  MethodsCard(this.chapter,this.index, {super.key});
final int chapter;
final int index;
  final methods = [
    ["Bisection Method","False Position Method","Simple Fixed Point Method","Newton Method","Secant Method"],
    ["Gauss Elimination","LU Decomposition","Cramer's Rule","Gauss-Jordan Elimination"]
  ];
  final List<List<Widget>> specialRout=[
   [
    InFuction("XL",true,"XU",'b',"Bisection Method"),
    InFuction("XL",true,"XU",'fa',"False Position Method"),
    InFuction("X0",false," ",'fi',"Simple Fixed Point Method"),
    InFuction("X0",false," ",'n',"Newton Method"),
    InFuction("X-1",true,"X0",'s',"Secant Method")
   ],
    [
     InputSystem("GE","Gauss Elimination"),
     InputSystem("LU","LU Decomposition"),
     InputSystem("C","Cramer's Rule"),
     InputSystem("GJE","Gauss-Jordan Elimination"),
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            surfaceTintColor:  Colors.white,
              color: Colors.white,
              child: ListTile(
                leading: Icon(chapter==1? Icons.functions_outlined:Icons.data_array_outlined,color: const Color.fromARGB(255, 8, 102, 196),size:30 ,),
                title: Text(methods[chapter-1][index],style: TextStyle(fontSize: 18,)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> specialRout[chapter-1][index] ));
                },
              )
          ),
        ),
      ],
    );
  }
}
