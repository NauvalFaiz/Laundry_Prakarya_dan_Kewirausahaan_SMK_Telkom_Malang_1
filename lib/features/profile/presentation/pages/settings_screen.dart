import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Pengaturan', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('Akun'),
          _buildSettingsTile('Ubah Password', Icons.lock_outline, () {}),
          _buildSettingsTile('Notifikasi', Icons.notifications_none, () {}),
          _buildSettingsTile('Alamat Tersimpan', Icons.location_on_outlined, () {}),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Bantuan & Informasi'),
          _buildSettingsTile('Pusat Bantuan', Icons.help_outline, () {}),
          _buildSettingsTile('Syarat & Ketentuan', Icons.description_outlined, () {}),
          _buildSettingsTile('Kebijakan Privasi', Icons.privacy_tip_outlined, () {}),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Lainnya'),
          _buildSettingsTile('Beri Rating', Icons.star_outline, () {}),
          _buildSettingsTile('Tentang Aplikasi', Icons.info_outline, () {}),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF104E89),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF64748B)),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
