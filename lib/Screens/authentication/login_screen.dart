import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/Widgets/Bottom_Widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Masuk ke\nAkun",
                  style: GoogleFonts.syne(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 11),
                Text(
                  "Selamat datang kembali di RajajoWash",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.82,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 43),
                _formLogin("Nomor HP / Email", false),
                SizedBox(height: 24),
                _formLogin("Password", true),
                SizedBox(height: 60),
                BottomWidget(
                  label: "Masuk",
                  route: '/home',
                )
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _formLogin(String label, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.65,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 315,
          height: 61,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.2),
            border: Border.all(color: Color(0xff9D9D9D)),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextFormField(
                obscureText: isPassword ? obscurePassword : false,
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: isPassword
                      ? IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
