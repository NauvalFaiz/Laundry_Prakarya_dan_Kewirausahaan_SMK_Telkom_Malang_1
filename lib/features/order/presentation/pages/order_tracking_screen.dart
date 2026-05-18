import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderDetailModel order;
  const OrderTrackingScreen({super.key, required this.order});

  // Map backend status to tracking step index
  // Backend flow: pending → pickup → weighing → to_laundry → received → process → done → delivery_back → shipped → completed
  int _getCurrentStep(String status) {
    switch (status) {
      case 'pending':
      case 'waiting_payment':
      case 'paid':
      case 'received':
        return 0; // Pesanan Diterima
      case 'pickup':
      case 'weighing':
      case 'to_laundry':
        return 1; // Dijemput Kurir
      case 'process':
        return 2; // Sedang Dicuci
      case 'done':
      case 'delivery_back':
        return 3; // Siap Diantar
      case 'shipped':
      case 'completed':
        return 4; // Terkirim
      case 'cancel':
        return -1;
      default:
        return 0;
    }
  }

  String _getHeaderTitle(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'waiting_payment':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Pesanan Dibayar';
      case 'pickup':
        return 'Dijemput Kurir';
      case 'weighing':
        return 'Penimbangan';
      case 'to_laundry':
        return 'Diantar ke Laundry';
      case 'received':
        return 'Diterima Laundry';
      case 'process':
        return 'Sedang di cuci';
      case 'done':
        return 'Selesai Dicuci';
      case 'delivery_back':
        return 'Siap Diantar';
      case 'shipped':
        return 'Dalam Pengiriman';
      case 'completed':
        return 'Selesai';
      case 'cancel':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _getCurrentStep(order.status);
    final isCancelled = order.status == 'cancel';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tracking Pesanan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // ── Header Status ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getHeaderTitle(order.status),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.syne(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF104E89),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'No. ${order.paymentCode ?? "ORD${order.id}"}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Timeline Card ──
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTrackStep(
                    step: 0,
                    currentStep: currentStep,
                    isCancelled: isCancelled,
                    icon: Icons.check_circle_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Pesanan Diterima',
                    subtitle: _getStepSubtitle(0, currentStep),
                    isLast: false,
                  ),
                  _buildTrackStep(
                    step: 1,
                    currentStep: currentStep,
                    isCancelled: isCancelled,
                    icon: Icons.delivery_dining_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Dijemput Kurir',
                    subtitle: _getStepSubtitle(1, currentStep),
                    isLast: false,
                  ),
                  _buildTrackStep(
                    step: 2,
                    currentStep: currentStep,
                    isCancelled: isCancelled,
                    icon: Icons.local_laundry_service_rounded,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Sedang Dicuci',
                    subtitle: _getStepSubtitle(2, currentStep),
                    isLast: false,
                    isHighlighted: currentStep == 2,
                  ),
                  _buildTrackStep(
                    step: 3,
                    currentStep: currentStep,
                    isCancelled: isCancelled,
                    icon: Icons.inventory_2_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Siap Diantar',
                    subtitle: _getStepSubtitle(3, currentStep),
                    isLast: false,
                  ),
                  _buildTrackStep(
                    step: 4,
                    currentStep: currentStep,
                    isCancelled: isCancelled,
                    icon: Icons.home_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Terkirim',
                    subtitle: _getStepSubtitle(4, currentStep),
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Kurir Card ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kurir kamu',
                    style: GoogleFonts.syne(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFE2E8F0),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Color(0xFF64748B),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kurir RajaWash',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Menunggu assign kurir',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF104E89),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          'Hubungi',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getStepSubtitle(int step, int currentStep) {
    if (step < currentStep) {
      return 'Konfirmasi Berhasil';
    } else if (step == currentStep) {
      return 'Sekarang – Proses sedang berlangsung';
    } else {
      return 'Menunggu selesai';
    }
  }

  Widget _buildTrackStep({
    required int step,
    required int currentStep,
    required bool isCancelled,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isLast,
    bool isHighlighted = false,
  }) {
    final isCompleted = step < currentStep;
    final isActive = step == currentStep;
    final isFuture = step > currentStep;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + icon
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Icon circle
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isFuture
                        ? const Color(0xFFF1F5F9)
                        : isActive
                        ? iconColor.withValues(alpha: 0.15)
                        : iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: isActive
                        ? Border.all(color: iconColor, width: 2)
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: isFuture ? const Color(0xFFCBD5E1) : iconColor,
                    size: 22,
                  ),
                ),
                // Vertical line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? iconColor.withValues(alpha: 0.4)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? const Color(0xFF104E89)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isHighlighted
                          ? Colors.white
                          : isFuture
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isHighlighted
                          ? Colors.white70
                          : isFuture
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
