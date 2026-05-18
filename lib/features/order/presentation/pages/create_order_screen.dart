import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/data/models/order_models.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/bloc/order_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/bloc/order_event.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/bloc/order_state.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/bloc/auth_state.dart';
import 'package:prakarya_dan_kewirausahaan/core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class CreateOrderScreen extends StatefulWidget {
  final ServiceModel service;
  const CreateOrderScreen({super.key, required this.service});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _locationController = TextEditingController();
  int _qty = 1;
  String _deliveryType = 'standart';
  String _pickupType = 'pickup';
  String _paymentMethod = 'qris';
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  int get _totalPrice => widget.service.price * _qty;

  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Buat Pesanan',
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700, fontSize: 18, color: const Color(0xFF1E293B))),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Pesanan #${state.order.id} berhasil dibuat! 🎉'),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Navigate to orders instead of payment-qr since payment requires weighing
            context.go('/orders');
          }
          if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Service Info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.local_laundry_service_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.service.name,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                            Text(
                              '${widget.service.owner?.laundryName ?? "Mitra Laundry"} • ${_formatCurrency(widget.service.price)}/${widget.service.unitType ?? "kg"}',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Form Card
                Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location
                      _buildLabel('Alamat Penjemputan'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan alamat lengkap...',
                          hintStyle: GoogleFonts.plusJakartaSans(color: const Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.location_on_rounded, color: Color(0xFF4F46E5)),
                          suffixIcon: _isLoadingLocation 
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.my_location_rounded, color: Color(0xFF4F46E5)),
                                  onPressed: _getLocation,
                                  tooltip: 'Gunakan Lokasi Saat Ini',
                                ),
                        ),
                      ),
                      if (_currentPosition != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Koordinat: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF10B981), fontWeight: FontWeight.w600),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Quantity
                      _buildLabel('Estimasi Berat / Jumlah (${widget.service.unitType ?? "kg"})'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_qty > 1) setState(() => _qty--);
                              },
                              icon: const Icon(Icons.remove_circle_rounded,
                                  color: Color(0xFF4F46E5), size: 32),
                            ),
                            const SizedBox(width: 20),
                            Text('$_qty',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 28, fontWeight: FontWeight.w800)),
                            const SizedBox(width: 20),
                            IconButton(
                              onPressed: () => setState(() => _qty++),
                              icon: const Icon(Icons.add_circle_rounded,
                                  color: Color(0xFF4F46E5), size: 32),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Harga akhir menyesuaikan timbangan kurir saat penjemputan.',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Delivery Type
                      _buildLabel('Tipe Pengiriman'),
                      const SizedBox(height: 8),
                      _buildChipGroup(
                        options: {'standart': 'Standart', 'hemat': 'Hemat', 'kilat': 'Kilat'},
                        selected: _deliveryType,
                        onChanged: (v) => setState(() => _deliveryType = v),
                      ),

                      const SizedBox(height: 20),

                      // Pickup Type
                      _buildLabel('Tipe Jemput'),
                      const SizedBox(height: 8),
                      _buildChipGroup(
                        options: {'pickup': 'Dijemput Kurir', 'self': 'Antar Sendiri'},
                        selected: _pickupType,
                        onChanged: (v) => setState(() => _pickupType = v),
                      ),

                      const SizedBox(height: 20),

                      // Payment Method
                      _buildLabel('Metode Pembayaran'),
                      const SizedBox(height: 8),
                      _buildChipGroup(
                        options: {'qris': 'QRIS / QR Code', 'tunai': 'Tunai'},
                        selected: _paymentMethod,
                        onChanged: (v) => setState(() => _paymentMethod = v),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.payment_rounded, size: 14, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _paymentMethod == 'tunai' 
                                ? 'Pembayaran dilakukan langsung ke kurir secara tunai setelah penimbangan.'
                                : 'Anda bisa scan QRIS setelah kurir selesai menimbang berat cucian Anda.',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFFD97706)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Total & Submit
                Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimasi Harga',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14, color: const Color(0xFF64748B))),
                          Text(_formatCurrency(_totalPrice),
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF4F46E5))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // BlocBuilder for Auth to get discount level
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          int discount = 0;
                          if (authState is AuthSuccess) {
                            final level = authState.authModel.user?.level ?? 1;
                            if (level == 2) discount = 2;
                            if (level == 3) discount = 5;
                            if (level == 4) discount = 10;
                            if (level >= 5) discount = 15;
                          }
                          
                          if (discount > 0) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Diskon Member (Lv)',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13, color: const Color(0xFF10B981))),
                                Text('-$discount%',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF10B981))),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is OrderLoading ? null : _submitOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF94A3B8),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: state is OrderLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5))
                              : Text('Pesan Sekarang',
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: GoogleFonts.plusJakartaSans(
            fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)));
  }

  Widget _buildChipGroup({
    required Map<String, String> options,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Wrap(
      spacing: 10,
      children: options.entries.map((e) {
        final isSelected = e.key == selected;
        return ChoiceChip(
          label: Text(e.value,
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF64748B))),
          selected: isSelected,
          selectedColor: const Color(0xFF4F46E5),
          backgroundColor: const Color(0xFFF8FAFC),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide.none,
          onSelected: (_) => onChanged(e.key),
        );
      }).toList(),
    );
  }

  void _submitOrder() {
    if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan alamat penjemputan'), backgroundColor: Colors.red),
      );
      return;
    }

    final request = CreateOrderRequest(
      ownerId: widget.service.ownerId ?? 0,
      serviceId: widget.service.id,
      laundryLocation: _currentPosition != null 
          ? '${_locationController.text} (Lat: ${_currentPosition!.latitude}, Lng: ${_currentPosition!.longitude})'
          : _locationController.text,
      deliveryType: _deliveryType,
      pickupType: _pickupType,
      paymentMethod: _paymentMethod,
      items: [
        OrderItemRequest(
          serviceName: widget.service.name,
          price: widget.service.price,
          qty: _qty,
        ),
      ],
    );

    context.read<OrderBloc>().add(CreateNewOrder(request: request));
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        // Opsional: jika text kosong, isi dengan koordinat sementara
        if (_locationController.text.isEmpty) {
          _locationController.text = 'Lokasi Saya';
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi berhasil didapatkan'), backgroundColor: Color(0xFF10B981)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }
}
