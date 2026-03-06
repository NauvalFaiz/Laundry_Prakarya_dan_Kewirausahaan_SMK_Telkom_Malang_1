import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/Widgets/Bottom_Widget.dart';

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
                 BottomWidget(label: "Get Started", route: "/Onboard")
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
