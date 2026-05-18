import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderDetailModel order;

  const OrderDetailScreen({super.key, required this.order});

  String _formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return const Color(0xFF10B981);
      case 'waiting_payment':
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'process':
      case 'weighing':
        return const Color(0xFF3B82F6);
      case 'done':
      case 'completed':
        return const Color(0xFF10B981);
      case 'cancel':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'waiting_payment':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Sudah Dibayar';
      case 'pickup':
        return 'Dijemput Kurir';
      case 'weighing':
        return 'Penimbangan';
      case 'to_laundry':
        return 'Dikirim ke Laundry';
      case 'received':
        return 'Diterima Laundry';
      case 'process':
        return 'Sedang Diproses';
      case 'done':
        return 'Selesai Dicuci';
      case 'delivery_back':
        return 'Dikirim Kembali';
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'waiting_payment':
        return Icons.payment_rounded;
      case 'paid':
        return Icons.check_circle_rounded;
      case 'pickup':
        return Icons.delivery_dining_rounded;
      case 'weighing':
        return Icons.scale_rounded;
      case 'process':
        return Icons.local_laundry_service_rounded;
      case 'done':
        return Icons.check_circle_outline_rounded;
      case 'completed':
        return Icons.verified_rounded;
      case 'cancel':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Pesanan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Status Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getStatusColor(order.status),
                    _getStatusColor(order.status).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getStatusColor(order.status).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    _getStatusIcon(order.status),
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getStatusLabel(order.status),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Order #${order.id}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Track Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/order-tracking', extra: order);
                },
                icon: const Icon(Icons.timeline_rounded, size: 20),
                label: Text(
                  'Track Pesanan',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF104E89),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Invoice Card
            _buildSectionCard(
              title: 'Invoice',
              icon: Icons.receipt_long_rounded,
              children: [
                _buildDetailRow('Order ID', '#${order.id}'),
                _buildDetailRow(
                  'Metode Pembayaran',
                  order.paymentMethod?.toUpperCase() ?? '-',
                ),
                _buildDetailRow('Kode Pembayaran: ', order.paymentCode ?? '-'),
                _buildDetailRow(
                  'Status Pembayaran',
                  order.paymentStatus == 'paid' ? 'Lunas ✅' : 'Belum Bayar',
                  valueColor: order.paymentStatus == 'paid'
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
                if (order.paidAt != null)
                  _buildDetailRow('Dibayar pada', order.paidAt!),
                const Divider(height: 24),
                _buildDetailRow('Diskon', '${order.discount}%'),
                _buildDetailRow(
                  'Total',
                  _formatCurrency(order.totalPrice),
                  isBold: true,
                  valueColor: const Color(0xFF4F46E5),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Detail Laundry
            _buildSectionCard(
              title: 'Detail Laundry',
              icon: Icons.local_laundry_service_rounded,
              children: [
                _buildDetailRow('Lokasi', order.laundryLocation ?? '-'),
                _buildDetailRow('Tipe Pengiriman', order.deliveryType ?? '-'),
                _buildDetailRow('Tipe Pickup', order.pickupType ?? '-'),
                if (order.pointsGranted != null)
                  _buildDetailRow(
                    'Poin Didapat',
                    '+${order.pointsGranted} XP 🎮',
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // QR Payment Section
            if (order.paymentStatus != 'paid' && order.paymentMethod != 'tunai') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.qr_code_2_rounded,
                      size: 48,
                      color: Color(0xFF4F46E5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Belum melakukan pembayaran',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push('/payment-qr/${order.id}');
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: Text(
                          'Bayar dengan QR',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Order Tracking Timeline
            if (order.histories != null && order.histories!.isNotEmpty) ...[
              _buildSectionCard(
                title: 'Tracking Pesanan',
                icon: Icons.timeline_rounded,
                children: [
                  ...order.histories!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final history = entry.value;
                    final isLast = index == order.histories!.length - 1;
                    return _buildTimelineItem(
                      status: history.status ?? '',
                      note: history.note ?? '',
                      time: history.createdAt ?? '',
                      isLast: isLast,
                      isActive: isLast,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF4F46E5)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                  color: valueColor ?? const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String status,
    required String note,
    required String time,
    required bool isLast,
    required bool isActive,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF4F46E5)
                      : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: const Color(0xFFE2E8F0)),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusLabel(status),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? const Color(0xFF4F46E5)
                          : const Color(0xFF64748B),
                    ),
                  ),
                  if (note.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      note,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                  if (time.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
