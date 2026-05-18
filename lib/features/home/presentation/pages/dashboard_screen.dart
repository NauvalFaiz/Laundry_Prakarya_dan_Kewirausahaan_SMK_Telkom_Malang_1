import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_event.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_state.dart';
import 'package:prakarya_dan_kewirausahaan/core/widgets/time.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/bloc/order_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/bloc/order_state.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/data/models/order_models.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNav = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) context.go('/login');
      },
      builder: (context, state) {
        String userName = "Guest";
        int userLevel = 1;
        int userPoints = 0;

        if (state is AuthSuccess) {
          userName = state.authModel.user?.name ?? "User";
          userLevel = state.authModel.user?.level ?? 1;
          userPoints = state.authModel.user?.points ?? 0;
        } else if (state is AuthSessionRestored) {
          userName = state.authModel.user?.name ?? "User";
          userLevel = state.authModel.user?.level ?? 1;
          userPoints = state.authModel.user?.points ?? 0;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: _currentNav == 3
                ? _buildPromoScreen()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, userName, userLevel, userPoints),
                        _buildSearchBar(context),
                        _buildCategoryRow(context),
                        _buildLevelCard(userName, userLevel, userPoints),
                        _buildSectionTitle('Mitra Laundry Terdekat', onSeeAll: () => context.push('/select-service')),
                        _buildMitraList(context),
                        _buildSectionTitle('Promo Untukmu', onSeeAll: () => setState(() => _currentNav = 3)),
                        _buildPromoBanner(),
                        _buildSectionTitle('Pesanan Aktif', onSeeAll: () => context.push('/orders')),
                        _buildActiveOrders(context),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
          ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  // ── HEADER (Grab-style) ──
  Widget _buildHeader(BuildContext ctx, String name, int level, int points) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showProfileMenu(ctx),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF104E89), Color(0xFF1E88E5)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Text(name[0].toUpperCase(),
                    style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF104E89))),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getGreeting(), style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8))),
                Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
              ],
            ),
          ),
          // XP Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFD4A017), Color(0xFFF59E0B)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚡', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text('$points XP', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF104E89), size: 22),
              onPressed: () {},
              constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
            ),
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR (Grab-style) ──
  Widget _buildSearchBar(BuildContext ctx) {
    return GestureDetector(
      onTap: () => ctx.push('/select-service'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 22),
            const SizedBox(width: 10),
            Text('Cari mitra laundry...', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFF94A3B8))),
          ],
        ),
      ),
    );
  }

  // ── CATEGORY ROW (Grab-style icons) ──
  Widget _buildCategoryRow(BuildContext ctx) {
    final cats = [
      _Cat(Icons.local_laundry_service_rounded, 'Cuci\nReguler', const Color(0xFF3B82F6)),
      _Cat(Icons.flash_on_rounded, 'Cuci\nKilat', const Color(0xFFF59E0B)),
      _Cat(Icons.dry_cleaning_rounded, 'Dry\nClean', const Color(0xFF10B981)),
      _Cat(Icons.iron_rounded, 'Setrika', const Color(0xFFEF4444)),
      _Cat(Icons.receipt_long_rounded, 'Pesanan\nSaya', const Color(0xFF8B5CF6)),
      _Cat(Icons.qr_code_scanner_rounded, 'Bayar\nQR', const Color(0xFF06B6D4)),
      _Cat(Icons.card_membership_rounded, 'Member\nship', const Color(0xFFEC4899)),
      _Cat(Icons.local_offer_rounded, 'Voucher', const Color(0xFF14B8A6)),
    ];

    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: cats.length,
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () {
              if (i == 4) { ctx.push('/orders'); }
              else if (i == 5) { ctx.push('/orders'); }
              else if (i <= 3) { ctx.push('/select-service'); }
            },
            child: SizedBox(
              width: 64,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cats[i].color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(cats[i].icon, color: cats[i].color, size: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(cats[i].label, textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF475569)),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── LEVEL CARD ──
  Widget _buildLevelCard(String name, int level, int points) {
    final lvlName = ['', 'Warga Baru', 'Pejuang Wangi', 'Sultan Laundry', 'Raja Bersih', 'Emperor Wash', 'Mythic Bubble'][level.clamp(1, 6)];
    final nextPts = [0, 500, 1500, 3500, 7000, 15000, 30000][level.clamp(1, 6)];
    final progress = nextPts > 0 ? (points / nextPts).clamp(0.0, 1.0) : 1.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF104E89), Color(0xFF1565C0)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF104E89).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          // Level badge
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Lv', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white70)),
                Text('$level', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🏆 $lvlName', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress, minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFF59E0B)),
                  ),
                ),
                const SizedBox(height: 4),
                Text('$points / $nextPts XP', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION TITLE ──
  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text('Lihat Semua', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF104E89))),
            ),
        ],
      ),
    );
  }

  // ── MITRA LIST (Grab-style merchant cards dari Database) ──
  Widget _buildMitraList(BuildContext ctx) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator(color: Color(0xFF104E89))),
          );
        }

        if (state is ServicesLoaded) {
          if (state.services.isEmpty) {
            return const SizedBox(
              height: 180,
              child: Center(child: Text('Belum ada mitra laundry tersedia', style: TextStyle(color: Colors.grey))),
            );
          }

          // Extract unique owners from services
          final Map<int, LaundryModel> uniqueOwners = {};
          final Map<int, int> lowestPrice = {};
          
          for (var s in state.services) {
            if (s.owner != null) {
              uniqueOwners[s.ownerId!] = s.owner!;
              if (!lowestPrice.containsKey(s.ownerId!) || s.price < lowestPrice[s.ownerId!]!) {
                lowestPrice[s.ownerId!] = s.price;
              }
            }
          }

          final mitras = uniqueOwners.values.toList();

          return SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemCount: mitras.length,
              itemBuilder: (_, i) {
                final m = mitras[i];
                final price = lowestPrice[m.id] ?? 0;
                
                return GestureDetector(
                  onTap: () => ctx.push('/select-service'),
                  child: Container(
                    width: 240,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF104E89).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.store_rounded, color: Color(0xFF104E89), size: 22),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.laundryName ?? 'Mitra Laundry', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                                  Text(m.laundryAddress ?? '-', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF94A3B8)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 3),
                            Text('4.9', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 10),
                            const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF94A3B8)),
                            Text('Terdekat', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF64748B))),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('Tersedia', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Mulai Rp $price/kg', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF104E89))),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ── PROMO BANNER ──
  Widget _buildPromoBanner() {
    return SizedBox(
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _promoCard('Diskon 15%', 'Member Diamond!\nKode: DIAMOND15', [const Color(0xFFEF4444), const Color(0xFFEC4899)]),
          const SizedBox(width: 12),
          _promoCard('Gratis Ongkir', 'Min. Rp 50.000\ns/d akhir bulan', [const Color(0xFF10B981), const Color(0xFF06B6D4)]),
          const SizedBox(width: 12),
          _promoCard('2x XP', 'Cuci Kilat\nDouble poin!', [const Color(0xFF8B5CF6), const Color(0xFF6366F1)]),
        ],
      ),
    );
  }

  Widget _promoCard(String title, String sub, List<Color> colors, {double? width}) {
    return Container(
      width: width ?? 220, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(sub, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70, height: 1.3)),
        ],
      ),
    );
  }

  // ── PROMO SCREEN ──
  Widget _buildPromoScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text('Promo & Diskon', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _promoCard('Diskon 15%', 'Member Diamond!\nOtomatis berlaku untuk level Anda.', [const Color(0xFFEF4444), const Color(0xFFEC4899)], width: double.infinity),
              const SizedBox(height: 16),
              _promoCard('Diskon DANA 20%', 'Bayar pakai QRIS Dana\nMax diskon Rp 10.000', [const Color(0xFF3B82F6), const Color(0xFF2563EB)], width: double.infinity),
              const SizedBox(height: 16),
              _promoCard('Gratis Ongkir', 'Min. transaksi Rp 50.000\nPeriode: s/d akhir bulan', [const Color(0xFF10B981), const Color(0xFF059669)], width: double.infinity),
              const SizedBox(height: 16),
              _promoCard('2x XP', 'Layanan Cuci Kilat\nDapatkan poin lebih banyak!', [const Color(0xFF8B5CF6), const Color(0xFF6366F1)], width: double.infinity),
            ],
          ),
        ),
      ],
    );
  }

  // ── ACTIVE ORDERS ──
  Widget _buildActiveOrders(BuildContext ctx) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: GestureDetector(
        onTap: () => ctx.push('/orders'),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF104E89).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.local_laundry_service_rounded, color: Color(0xFF104E89)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lihat pesanan aktif', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                  Text('Cek status cucianmu sekarang', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  // ── PROFILE MENU ──
  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            _menuItem(Icons.person_outline_rounded, 'Profil Saya', () => Navigator.pop(ctx)),
            _menuItem(Icons.card_membership_rounded, 'Membership', () => Navigator.pop(ctx)),
            _menuItem(Icons.settings_outlined, 'Pengaturan', () => Navigator.pop(ctx)),
            const Divider(height: 20),
            _menuItem(Icons.logout_rounded, 'Logout', () {
              Navigator.pop(ctx);
              _confirmLogout(context);
            }, isRed: true),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap, {bool isRed = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isRed ? const Color(0xFFFEE2E2) : const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 20, color: isRed ? const Color(0xFFEF4444) : const Color(0xFF104E89)),
      ),
      title: Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: isRed ? const Color(0xFFEF4444) : const Color(0xFF0F172A))),
      trailing: Icon(Icons.chevron_right_rounded, color: isRed ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1)),
      onTap: onTap,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Logout', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text('Yakin ingin keluar?', style: GoogleFonts.plusJakartaSans()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batal', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B)))),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); context.read<AuthBloc>().add(LogoutRequested()); },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text('Keluar', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV (Grab-style) ──
  Widget _buildBottomNav(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 'Home', 0, () => setState(() => _currentNav = 0)),
              _navItem(Icons.receipt_long_rounded, 'Pesanan', 1, () { setState(() => _currentNav = 1); ctx.push('/orders'); }),
              // Center FAB
              GestureDetector(
                onTap: () => ctx.push('/select-service'),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF104E89), Color(0xFF1E88E5)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: const Color(0xFF104E89).withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
                ),
              ),
              _navItem(Icons.local_offer_rounded, 'Promo', 3, () => setState(() => _currentNav = 3)),
              _navItem(Icons.person_rounded, 'Profil', 4, () => _showProfileMenu(ctx)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int idx, VoidCallback onTap) {
    final active = _currentNav == idx;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? const Color(0xFF104E89) : const Color(0xFF94A3B8), size: 22),
          const SizedBox(height: 3),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? const Color(0xFF104E89) : const Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}

class _Cat {
  final IconData icon;
  final String label;
  final Color color;
  _Cat(this.icon, this.label, this.color);
}
