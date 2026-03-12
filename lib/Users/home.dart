import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/Widgets/time.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                fontSize: 17,
              ),
            ),
            Text(
              "Chris Lorem!",
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/1200x/0e/9b/7d/0e9b7d4d5bb319258d168fd17861dc0c.jpg',
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 169,
              margin: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: Offset(0, 4),
                    blurRadius: 5,
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 27, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chrissto',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Level 24',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: Color(0xff0C4B89),
                          ),
                        ),
                        Text(
                          'Coin : 300.000',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: Color(0xff0C4B89),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 137,
                      width: 121,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xff2D6399),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: Offset(0, 4),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 36,
                            left: -8,
                            child: Image.asset('assets/abstrac.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
