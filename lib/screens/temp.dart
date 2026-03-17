///               temp screen      ///
import 'package:flutter/material.dart';

class temp extends StatelessWidget {
  const temp({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "يا ابني انا مش قولت محدش يدوس هنا😡",
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
