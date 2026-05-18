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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xffF1F1FF)),
                onPressed: () => context.pop(),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                        
                        _buildInputField("Nama Lengkap", "Masukkan nama lengkap", false, controller: _nameController),
                        const SizedBox(height: 20),
                        
                        _buildInputField("Nomor HP / Email", "Masukkan nomor HP atau email", false, controller: _identifierController),
                        const SizedBox(height: 20),
                        
                        _buildInputField("Password", "Masukkan password", true, 
                          controller: _passwordController,
                          isObscure: obscurePassword, 
                          onToggle: () => setState(() => obscurePassword = !obscurePassword)
                        ),
                        const SizedBox(height: 20),
                        
                        _buildInputField("Konfirmasi Password", "Ulangi password", true, 
                          controller: _confirmPasswordController,
                          isObscure: obscureConfirmPassword, 
                          onToggle: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword)
                        ),
                        
                        const SizedBox(height: 50),
                        isLoading 
                          ? const Center(child: CircularProgressIndicator(color: Colors.white))
                          : BottomWidget(
                            label: "Daftar Sekarang", 
                            route: '/home',
                            onPressed: () {
                              if (_nameController.text.isNotEmpty &&
                                  _identifierController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                if (_passwordController.text == _confirmPasswordController.text) {
                                  context.read<AuthBloc>().add(
                                    RegisterRequested(
                                      name: _nameController.text.trim(),
                                      identifier: _identifierController.text.trim(),
                                      password: _passwordController.text,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Password tidak cocok")),
                                  );
                                }
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
                            onTap: () => context.pop(),
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
