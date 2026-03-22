import 'package:flutter/material.dart';
import 'package:napp/screens/input_screen.dart';
import 'package:napp/screens/temp.dart';

class MethodsCard extends StatelessWidget {
  MethodsCard(this.chapter,this.index, {super.key});
final int chapter;
final int index;
  final methods = [
    ["Bisection Method","False Position Method","Simple Fixed Point Method","Newton Method","Secant Method"],
    ["Gauss Elimination","LU Decomposition","Cramer's Rule","Partial Pivoting","Gauss-Jordan"]
  ];
  final List<List<Widget>> specialRout=[
   [
    InFuction("Xl",true,"Xu",'b'),
    InFuction("Xl",true,"Xu",'fa'),
    InFuction("X0",false," ",'fi'),
    InFuction("X0",false," ",'n'),
    InFuction("X-1",true,"X0",'s')
   ],
    [
      temp(),
      temp(),
      temp(),
      temp()
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
                leading: Icon(chapter==0? Icons.functions_outlined:Icons.data_array_outlined,color: const Color.fromARGB(255, 8, 102, 196),size:30 ,),
                title: Text(methods[chapter][index],style: TextStyle(fontSize: 18,)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> specialRout[chapter][index] ));
                },
              )
          ),
        ),
      ],
    );
  }
}
