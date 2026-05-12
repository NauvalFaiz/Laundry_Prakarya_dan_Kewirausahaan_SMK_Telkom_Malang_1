import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/core/utils/session_manager.dart';

class FirstScrenns extends StatefulWidget {
  const FirstScrenns({super.key});

  @override
  State<FirstScrenns> createState() => _FirstScrennsState();
}

class _FirstScrennsState extends State<FirstScrenns> {
  @override
  void initState() {
    super.initState();
    // Tampilkan splash lalu cek session
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        _checkSession();
      }
    });
  }

  Future<void> _checkSession() async {
    final isLoggedIn = await SessionManager.isLoggedIn();
    if (!mounted) return;

    if (isLoggedIn) {
      // Sudah login → langsung ke Home/Dashboard
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Belum login → ke Onboarding
      Navigator.pushReplacementNamed(context, '/Onboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -40,
            top: -30,
            child: FadeInDown(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 400),
              child: Image.asset(
                width: 300,
                height: 240,
                'assets/atas.png',
              ),
            ),
          ),

          Positioned(
            right: -40,
            bottom: -30,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 400),
              child: Image.asset(
                width: 300,
                height: 240,
                'assets/bawah.png',
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeIn(
                    duration: const Duration(milliseconds: 1000),
                    delay: const Duration(milliseconds: 1200),
                    child: Column(
                      children: [
                        Text(
                          "RajaWash",
                          style: GoogleFonts.syne(
                            fontSize: 46,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xff104E89),
                            letterSpacing: -1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Cucian bersih, hidup tenang.",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
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
    );
  }
}
