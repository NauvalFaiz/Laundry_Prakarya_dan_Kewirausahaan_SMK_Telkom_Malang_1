import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_event.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_state.dart';

import '../../../../core/widgets/time.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = "Guest";
        if (state is AuthSuccess) {
          userName = state.authModel.user?.name ?? "User";
        }

        return Scaffold(
          backgroundColor: const Color(0xffF1F1FF),
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
                  userName,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Color(0xff0C4B89)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Apakah Anda yakin ingin keluar?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<AuthBloc>().add(LogoutRequested());
                          },
                          child: const Text("Keluar", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 10),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xff0C4B89),
                  backgroundImage: (state is AuthSuccess && state.authModel.user?.avatar != null)
                      ? NetworkImage(state.authModel.user!.avatar!)
                      : NetworkImage('https://ui-avatars.com/api/?name=$userName&background=0C4B89&color=fff'),
                ),
              ),
            ],
          ),
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                context.go('/login');
              }
            },
            child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 169,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
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
                              userName,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Level 24',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: const Color(0xff0C4B89),
                              ),
                            ),
                            Text(
                              'Coin : 300.000',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: const Color(0xff0C4B89),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 137,
                          width: 121,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xff2D6399),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(0, 4),
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
          ),
        );
      },
    );
  }
}
