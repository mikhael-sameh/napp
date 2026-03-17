import 'package:flutter/material.dart';
import 'package:napp/widgets/cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color primeColor = const Color.fromARGB(255, 8, 102, 196); //0866c4 hex

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title:  Text(
          'NAPP',
          style: TextStyle(
            color: primeColor,
            fontWeight: FontWeight.w700,
            fontSize: 40,
          ),
        ),
        centerTitle: true,
        shadowColor: primeColor,
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children:[ Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15.0,15.0,15.0,0),
              child: Text(
                "Chapter One",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 30,
                  fontFamily: 'Bebas',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,),
              child: ListView.builder(itemCount: 5,shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),itemBuilder: (context,index){return MethodsCard(0,index);}),
            ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    color: primeColor,
                    thickness: 2,
                    endIndent: 35,
                    indent: 35,
                  ),
                ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                "Chapter Two",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                  fontFamily: 'Bebas',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,),
              child: ListView.builder(itemCount: 5,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),itemBuilder: (context,index){return MethodsCard(1,index);}),
            ),
          ],
        ),]
      ),
    );
  }
}
