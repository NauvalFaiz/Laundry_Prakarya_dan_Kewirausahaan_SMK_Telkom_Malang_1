import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/presentation/bloc/payment_event.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/presentation/bloc/payment_state.dart';

class PaymentQrScreen extends StatefulWidget {
  final int orderId;
  const PaymentQrScreen({super.key, required this.orderId});

  @override
  State<PaymentQrScreen> createState() => _PaymentQrScreenState();
}

class _PaymentQrScreenState extends State<PaymentQrScreen> {
  Timer? _countdownTimer;
  int _remainingSeconds = 1800; // default 30 menit
  String? _paymentUrl;
  bool _isPaid = false;
  bool _isExpired = false;
  final GlobalKey _qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(GeneratePaymentUrl(orderId: widget.orderId));
  }

  void _startCountdown(DateTime expiresAt) {
    _countdownTimer?.cancel();
    final diff = expiresAt.difference(DateTime.now()).inSeconds;
    setState(() {
      _remainingSeconds = diff > 0 ? diff : 0;
      _isExpired = _remainingSeconds <= 0;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          _isExpired = true;
          timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Color _timerColor() {
    if (_remainingSeconds <= 60) return const Color(0xFFEF4444);
    if (_remainingSeconds <= 300) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  Future<void> _saveQrToGallery() async {
    try {
      // Minta izin storage/photos
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      
      // Untuk Android 13+ (Photos)
      var photosStatus = await Permission.photos.status;
      if (!photosStatus.isGranted) {
        photosStatus = await Permission.photos.request();
      }

      if (!status.isGranted && !photosStatus.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin galeri ditolak'), backgroundColor: Colors.red),
          );
        }
        return;
      }

      // Beri sedikit delay agar widget selesai render
      await Future.delayed(const Duration(milliseconds: 300));

      final boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Widget belum siap untuk disimpan');
      }
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Gagal konversi ke gambar');
      }
      
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final result = await ImageGallerySaverPlus.saveImage(pngBytes, quality: 100, name: 'rajawash_qr_${widget.orderId}');

      if (mounted) {
        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('QR berhasil disimpan ke galeri! 📸', style: GoogleFonts.plusJakartaSans()),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          throw Exception(result['errorMessage'] ?? 'Gagal menyimpan ke galeri');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pembayaran QR', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 18, color: const Color(0xFF0F172A))),
        centerTitle: true,
      ),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentUrlGenerated) {
            setState(() { _paymentUrl = state.payment.paymentUrl; });
            if (state.payment.expiresAt != null) {
              final expires = DateTime.tryParse(state.payment.expiresAt!);
              if (expires != null) _startCountdown(expires);
            }
            context.read<PaymentBloc>().add(StartPaymentPolling(orderId: state.orderId));
          }
          if (state is PaymentSuccess) {
            _countdownTimer?.cancel();
            setState(() { _isPaid = true; });
          }
          if (state is PaymentError && _paymentUrl == null) {
            // Only show error if we never got a URL
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // Payment success
    if (_isPaid) return _buildSuccessView();

    // Still loading (no URL yet)
    if (_paymentUrl == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF104E89)),
            SizedBox(height: 16),
            Text('Generating QR Code...'),
          ],
        ),
      );
    }

    // QR loaded — always show (won't disappear on polling state changes)
    return _buildQrView();
  }

  Widget _buildQrView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          // Timer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _isExpired
                  ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                  : [_timerColor(), _timerColor().withValues(alpha: 0.8)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  _isExpired ? 'QR Code Expired!' : 'Berlaku: ${_formatTime(_remainingSeconds)}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // QR Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: const Color(0xFF104E89).withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8))],
            ),
            child: Column(
              children: [
                if (_isExpired) ...[
                  Icon(Icons.qr_code_rounded, size: 160, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('QR sudah expired', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() { _paymentUrl = null; _isExpired = false; });
                      context.read<PaymentBloc>().add(GeneratePaymentUrl(orderId: widget.orderId));
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Generate Ulang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF104E89), foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ] else ...[
                  // RepaintBoundary for screenshot/download
                  RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('RajaWash', style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF104E89))),
                          const SizedBox(height: 8),
                          QrImageView(
                            data: _paymentUrl!,
                            version: QrVersions.auto,
                            size: 200,
                            eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: const Color(0xFF0F172A)),
                            dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: const Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 8),
                          Text('Order #${widget.orderId}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF104E89))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Download button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _saveQrToGallery,
                      icon: const Icon(Icons.download_rounded, size: 20),
                      label: Text('Simpan QR ke Galeri', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF104E89),
                        side: const BorderSide(color: Color(0xFF104E89)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cara Bayar', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                const SizedBox(height: 12),
                _step(1, 'Buka Camera / Google Lens di HP'),
                _step(2, 'Scan QR Code di atas'),
                _step(3, 'Link terbuka otomatis di browser'),
                _step(4, 'Pembayaran terverifikasi otomatis'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Realtime status
          if (!_isExpired)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(4),
                      boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.5), blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Menunggu scan... Status update otomatis',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF166534))),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _step(int n, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 26, height: 26,
            decoration: BoxDecoration(color: const Color(0xFF104E89), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text('$n', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF475569)))),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(100)),
              child: const Icon(Icons.check_circle_rounded, size: 64, color: Color(0xFF10B981)),
            ),
            const SizedBox(height: 24),
            Text('Pembayaran Berhasil! 🎉', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
            const SizedBox(height: 8),
            Text('Order #${widget.orderId} sudah dibayar', style: GoogleFonts.plusJakartaSans(fontSize: 16, color: const Color(0xFF64748B))),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF104E89), foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Lihat Detail Pesanan', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
