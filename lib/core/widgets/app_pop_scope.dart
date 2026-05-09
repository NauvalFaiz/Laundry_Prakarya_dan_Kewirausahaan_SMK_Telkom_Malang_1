import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPopScope extends StatelessWidget {
  final Widget child;

  const AppPopScope({super.key, required this.child});

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xffF1F1FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Konfirmasi Keluar",
              style: GoogleFonts.syne(
                fontWeight: FontWeight.w800,
                color: const Color(0xff104E89),
              ),
            ),
            content: Text(
              "Apakah Anda yakin ingin keluar dari aplikasi?",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey[800],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "Tidak",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff104E89),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Ya",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _showExitDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
