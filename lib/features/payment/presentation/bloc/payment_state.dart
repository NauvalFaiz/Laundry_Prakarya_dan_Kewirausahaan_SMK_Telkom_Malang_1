import 'package:equatable/equatable.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// State awal
class PaymentInitial extends PaymentState {}

/// Sedang loading
class PaymentLoading extends PaymentState {}

/// QR URL berhasil di-generate
class PaymentUrlGenerated extends PaymentState {
  final PaymentModel payment;
  final int orderId;

  PaymentUrlGenerated({required this.payment, required this.orderId});

  @override
  List<Object?> get props => [payment, orderId];
}

/// Status pembayaran berhasil di-cek
class PaymentStatusLoaded extends PaymentState {
  final PaymentStatusModel status;

  PaymentStatusLoaded({required this.status});

  @override
  List<Object?> get props => [status];
}

/// Pembayaran berhasil (paid)
class PaymentSuccess extends PaymentState {
  final PaymentStatusModel status;

  PaymentSuccess({required this.status});

  @override
  List<Object?> get props => [status];
}

/// Daftar pesanan berhasil dimuat
class OrdersLoaded extends PaymentState {
  final List<OrderDetailModel> orders;

  OrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

/// Error
class PaymentError extends PaymentState {
  final String message;

  PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}
