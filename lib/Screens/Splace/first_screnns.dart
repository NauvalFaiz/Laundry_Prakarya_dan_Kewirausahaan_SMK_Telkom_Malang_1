import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class FirstScrenns extends StatelessWidget {
  const FirstScrenns({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0C4B89), Color(0xffFFFFFF), Color(0xffF7E78E)],
          begin: Alignment.topCenter,
          stops: [0.0, 0.44, 1.0],
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -30,
              top: -20,
              child: Image.asset(
                  width: 289.55,
                  height: 228,
                  'assets/atas.png'),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "RajajoWash",
                    style: GoogleFonts.syne(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "Laundry bersih, hidup tenang.",
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                  ),
                  SizedBox(height: 115),
                  Container(
                    width: 188,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xff104E89),
                      boxShadow: [
                        BoxShadow(color: Color(0xff0D4C89), blurRadius: 15.2),
                      ],
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
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushReplacementNamed(context,'/Onboard');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Get Started",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_right_alt,
                            size: 30,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -30,
              bottom: -20,
              child: Image.asset(
                width: 289.55,
                height: 228,
                'assets/bawah.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
