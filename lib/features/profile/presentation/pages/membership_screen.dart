import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_state.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Membership', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 18)),
        backgroundColor: const Color(0xFF104E89),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          int level = 1;
          int points = 0;

          if (state is AuthSuccess) {
            level = state.authModel.user?.level ?? 1;
            points = state.authModel.user?.points ?? 0;
          } else if (state is AuthSessionRestored) {
            level = state.authModel.user?.level ?? 1;
            points = state.authModel.user?.points ?? 0;
          }

          final lvlName = ['', 'Warga Baru', 'Pejuang Wangi', 'Sultan Laundry', 'Raja Bersih', 'Emperor Wash', 'Mythic Bubble'][level.clamp(1, 6)];
          final nextPts = [0, 500, 1500, 3500, 7000, 15000, 30000][level.clamp(1, 6)];
          final progress = nextPts > 0 ? (points / nextPts).clamp(0.0, 1.0) : 1.0;
          
          int discountPercent = [0, 0, 2, 5, 10, 15, 15][level.clamp(1, 6)];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF104E89),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          lvlName,
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '$points XP',
                        style: GoogleFonts.syne(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFFF59E0B)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kumpulkan ${nextPts - points} XP lagi untuk naik level!',
                        style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(Color(0xFFF59E0B)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Level $level', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('Level ${level + 1}', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keuntungan Level Anda',
                        style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 16),
                      _buildBenefitCard(
                        'Diskon Otomatis', 
                        'Diskon $discountPercent% untuk setiap transaksi', 
                        Icons.discount_outlined, 
                        const Color(0xFF10B981)
                      ),
                      const SizedBox(height: 12),
                      _buildBenefitCard(
                        'Prioritas Antrean', 
                        level >= 3 ? 'Aktif' : 'Terkunci (Butuh Lv 3)', 
                        Icons.timer_outlined, 
                        level >= 3 ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8)
                      ),
                      const SizedBox(height: 12),
                      _buildBenefitCard(
                        'Gratis Ongkir', 
                        level >= 4 ? 'Aktif' : 'Terkunci (Butuh Lv 4)', 
                        Icons.local_shipping_outlined, 
                        level >= 4 ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBenefitCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
