import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/core/widgets/Bottom_Widget.dart';
import 'package:prakarya_dan_kewirausahaan/core/widgets/app_pop_scope.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_event.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      context.go('/home');
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        FadeInDown(
                          child: Text(
                            "Masuk Ke\nAkun Anda",
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
                            "Nikmati layanan laundry terbaik dengan RajajoWash.",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              color: const Color(0xffF1F1FF).withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        
                        _buildInputField(
                          "Email / Nomor HP", 
                          "Masukkan email atau nomor HP", 
                          false, 
                          controller: _identifierController
                        ),
                        const SizedBox(height: 20),
                        
                        _buildInputField(
                          "Password", 
                          "Masukkan password", 
                          true,
                          controller: _passwordController,
                          isObscure: obscurePassword,
                          onToggle: () => setState(() => obscurePassword = !obscurePassword),
                        ),
                        
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Lupa Password?",
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xffF1F1FF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        isLoading 
                          ? const Center(child: CircularProgressIndicator(color: Colors.white))
                          : BottomWidget(
                              label: "Masuk", 
                              route: '/home',
                              onPressed: () {
                                if (_identifierController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                                  context.read<AuthBloc>().add(
                                    LoginRequested(
                                      identifier: _identifierController.text.trim(),
                                      password: _passwordController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                        
                        const SizedBox(height: 20),
                        
                        // Google Login Button (Old Style but functional)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: isLoading ? null : () => context.read<AuthBloc>().add(GoogleLoginRequested()),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.g_mobiledata, color: Colors.white, size: 30),
                                const SizedBox(width: 8),
                                Text(
                                  "Masuk dengan Google",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        Center(
                          child: GestureDetector(
                            onTap: () => context.push('/register'),
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xffF1F1FF).withOpacity(0.7),
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(text: "Belum punya akun? "),
                                  TextSpan(
                                    text: "Daftar Disini",
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
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, bool isPassword, {required TextEditingController controller, bool isObscure = false, VoidCallback? onToggle}) {
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
            controller: controller,
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
