import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/core/widgets/Bottom_Widget.dart';
import 'package:prakarya_dan_kewirausahaan/core/widgets/app_pop_scope.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return AppPopScope(
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/Background.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffB8BFD0).withOpacity(0.48),
                backgroundBlendMode: BlendMode.multiply,
              ),
            ),
          ),
          
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xffF1F1FF)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      child: Text(
                        "Daftar\nAkun Baru",
                        style: GoogleFonts.syne(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xffF1F1FF),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        "Bergabunglah dengan RajajoWash untuk pengalaman laundry terbaik.",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: const Color(0xffF1F1FF).withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    _buildInputField("Nama Lengkap", "Masukkan nama lengkap", false),
                    const SizedBox(height: 20),
                    
                    _buildInputField("Nomor HP / Email", "Masukkan nomor HP atau email", false),
                    const SizedBox(height: 20),
                    
                    _buildInputField("Password", "Masukkan password", true, 
                      isObscure: obscurePassword, 
                      onToggle: () => setState(() => obscurePassword = !obscurePassword)
                    ),
                    const SizedBox(height: 20),
                    
                    _buildInputField("Konfirmasi Password", "Ulangi password", true, 
                      isObscure: obscureConfirmPassword, 
                      onToggle: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword)
                    ),
                    
                    const SizedBox(height: 50),
                    const BottomWidget(label: "Daftar Sekarang", route: '/home'),
                    
                    const SizedBox(height: 30),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xffF1F1FF).withOpacity(0.7),
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(text: "Sudah punya akun? "),
                              TextSpan(
                                text: "Masuk Disini",
                                style: const TextStyle(
                                  color: Color(0xffF1F1FF),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, bool isPassword, {bool isObscure = false, VoidCallback? onToggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xffF1F1FF),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xffF1F1FF).withOpacity(0.3)),
          ),
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            obscureText: isPassword ? isObscure : false,
            cursorColor: const Color(0xffF1F1FF),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.white.withOpacity(0.3),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xffF1F1FF),
                        size: 20,
                      ),
                      onPressed: onToggle,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
