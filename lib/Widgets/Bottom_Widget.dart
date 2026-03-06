import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class BottomWidget extends StatelessWidget {
  const BottomWidget({super.key, required this.label, required this.route});
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacementNamed(context, route);
      },
      child: Container(
        width: 326,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xff104E89),
          boxShadow: [BoxShadow(color: Color(0xff0D4C89), blurRadius: 15.2)],
          borderRadius: BorderRadius.circular(57),
          border: GradientBoxBorder(
            width: 2,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.84],
              colors: [Color(0xff0C4B89), Color(0xffF7E790)],
            ),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 5),
            Icon(Icons.arrow_right_alt, size: 30, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
