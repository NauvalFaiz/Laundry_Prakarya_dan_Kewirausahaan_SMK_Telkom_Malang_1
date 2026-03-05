import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Index(), debugShowCheckedModeBanner: false));
}

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0b4b89), Color(0xffFFEC8E), Color(0xffFFFFFF)],
          begin: Alignment.topCenter,
          stops: [
            0.0,
            0.69,
            1.0
          ],
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(),
    );
  }
}
