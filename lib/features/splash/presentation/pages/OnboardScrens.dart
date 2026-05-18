import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/core/widgets/Bottom_Widget.dart';

class OnboardScrens extends StatefulWidget {
  const OnboardScrens({super.key});

  @override
  State<OnboardScrens> createState() => _OnboardScrensState();
}

class _OnboardScrensState extends State<OnboardScrens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Layanan Terbaik",
      "description": "Cucian bersih, rapi, dan harum dalam waktu singkat dengan harga terjangkau.",
      "image": "assets/laundry.jpg",
    },
    {
      "title": "Jemput Antar",
      "description": "Tidak perlu keluar rumah, kami yang akan menjemput dan mengantar pakaian Anda.",
      "image": "assets/deliver.jpg",
    },
    {
      "title": "Proses Cepat",
      "description": "Pakaian Anda akan diproses dengan teknologi modern agar hasil maksimal.",
      "image": "assets/instan.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-play logic with safety check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
        if (_pageController.hasClients) {
          int nextPage = _currentPage + 1;
          if (nextPage >= onboardingData.length) {
            nextPage = 0;
          }

          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Carousel Section (Image + Text)
            Expanded(
              flex: 8,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // Image Area
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: FadeIn(
                            key: ValueKey("image_$index"),
                            child: onboardingData[index]["image"]!.endsWith(".svg")
                                ? SvgPicture.asset(
                                    onboardingData[index]["image"]!,
                                    fit: BoxFit.contain,
                                    placeholderBuilder: (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Image.asset(
                                    onboardingData[index]["image"]!,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                      ),
                      
                      // Text Area
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            FadeInDown(
                              key: ValueKey("title_$index"),
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                onboardingData[index]["title"]!,
                                style: GoogleFonts.syne(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xff104E89),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            FadeInUp(
                              key: ValueKey("desc_$index"),
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                onboardingData[index]["description"]!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Spacer(),

            // Dot Indicators (Moved down here)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index 
                      ? const Color(0xff104E89) 
                      : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                children: [
                  const BottomWidget(label: "Masuk Sekarang", route: "/login"),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.pushReplacement("/home");
                    },
                    child: Text(
                      "Masuk Tanpa Daftar",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff104E89),
                        decoration: TextDecoration.underline,
                        decorationThickness: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
