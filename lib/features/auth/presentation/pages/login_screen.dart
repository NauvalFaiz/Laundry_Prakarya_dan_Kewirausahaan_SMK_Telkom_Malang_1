import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInDown(
                            child: Text(
                              "Masuk ke\nAkun",
                              style: GoogleFonts.syne(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xffF1F1FF),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FadeInDown(
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              "Selamat datang kembali di RajajoWash",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: const Color(0xffF1F1FF).withOpacity(0.8),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          _formLogin("Nomor HP / Email", false, _identifierController),
                          const SizedBox(height: 24),
                          _formLogin("Password", true, _passwordController),
                          const SizedBox(height: 50),
                          state is AuthLoading
                              ? const Center(child: CircularProgressIndicator(color: Colors.white))
                              : BottomWidget(
                                  label: "Masuk",
                                  route: '/home',
                                  onPressed: () {
                                    if (_identifierController.text.isNotEmpty &&
                                        _passwordController.text.isNotEmpty) {
                                      context.read<AuthBloc>().add(
                                            LoginRequested(
                                              identifier: _identifierController.text,
                                              password: _passwordController.text,
                                            ),
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Harap isi semua bidang")),
                                      );
                                    }
                                  },
                                ),
                          const SizedBox(height: 30),
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/register'),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xffF1F1FF).withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                  children: [
                                    const TextSpan(text: "Belum punya akun? "),
                                    const TextSpan(
                                      text: "Daftar Disini",
                                      style: TextStyle(
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
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formLogin(String label, bool isPassword, TextEditingController controller) {
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: TextFormField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                obscureText: isPassword ? obscurePassword : false,
                cursorColor: const Color(0xffF1F1FF),
                decoration: InputDecoration(
                  hintText: isPassword ? "••••••••" : "Email atau No HP",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  border: InputBorder.none,
                  suffixIcon: isPassword
                      ? IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xffF1F1FF),
                            size: 20,
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
