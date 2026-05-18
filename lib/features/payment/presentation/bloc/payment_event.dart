import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Generate QR payment URL untuk order
class GeneratePaymentUrl extends PaymentEvent {
  final int orderId;

  GeneratePaymentUrl({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Cek status pembayaran secara realtime (polling)
class CheckPaymentStatus extends PaymentEvent {
  final int orderId;

  CheckPaymentStatus({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Load daftar pesanan user
class LoadMyOrders extends PaymentEvent {}

/// Start realtime polling
class StartPaymentPolling extends PaymentEvent {
  final int orderId;

  StartPaymentPolling({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Stop realtime polling
class StopPaymentPolling extends PaymentEvent {}
