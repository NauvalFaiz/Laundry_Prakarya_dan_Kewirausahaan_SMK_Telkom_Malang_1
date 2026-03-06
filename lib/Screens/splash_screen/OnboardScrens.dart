import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/Widgets/Bottom_Widget.dart';

class OnboardScrens extends StatelessWidget {
  const OnboardScrens({super.key});

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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/mobil.png"),
                SizedBox(height: 15),
                Text(
                  "Jemput & Antar",
                  style: GoogleFonts.syne(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  "Kami jemput laundry-mu dari rumah dan antar balik dengan keadaan bersih dan wangi",
                  style: GoogleFonts.plusJakartaSans(fontSize: 14.82),
                ),
                SizedBox(height: 55),
                BottomWidget(label: "Lanjut", route: "/login"),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Lewati",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.82,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
