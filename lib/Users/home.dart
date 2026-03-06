import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/Widgets/time.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                fontSize: 18,
              ),
            ),
            Text(
              "Chris Lorem!",
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/1200x/0e/9b/7d/0e9b7d4d5bb319258d168fd17861dc0c.jpg',
              ),
            ),
          ),
        ],
      ),
      body: Center(child: Text("Home Screen")),
    );
  }
}
