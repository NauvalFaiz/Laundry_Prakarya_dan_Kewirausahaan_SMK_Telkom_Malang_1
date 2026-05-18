import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/domain/repositories/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;
  Timer? _pollingTimer;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<GeneratePaymentUrl>(_onGeneratePaymentUrl);
    on<CheckPaymentStatus>(_onCheckPaymentStatus);
    on<LoadMyOrders>(_onLoadMyOrders);
    on<StartPaymentPolling>(_onStartPolling);
    on<StopPaymentPolling>(_onStopPolling);
  }

  /// Generate payment URL → tampilkan QR
  Future<void> _onGeneratePaymentUrl(
    GeneratePaymentUrl event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final result = await paymentRepository.generatePaymentUrl(event.orderId);
      emit(PaymentUrlGenerated(payment: result, orderId: event.orderId));
    } catch (e) {
      emit(PaymentError(
          message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Cek status pembayaran
  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatus event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      final result = await paymentRepository.getPaymentStatus(event.orderId);
      if (result.paymentStatus == 'paid') {
        _pollingTimer?.cancel();
        emit(PaymentSuccess(status: result));
      } else {
        emit(PaymentStatusLoaded(status: result));
      }
    } catch (e) {
      emit(PaymentError(
          message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Load daftar pesanan
  Future<void> _onLoadMyOrders(
    LoadMyOrders event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final orders = await paymentRepository.getMyOrders();
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(PaymentError(
          message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Start polling setiap 3 detik untuk realtime status
  Future<void> _onStartPolling(
    StartPaymentPolling event,
    Emitter<PaymentState> emit,
  ) async {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      add(CheckPaymentStatus(orderId: event.orderId));
    });
  }

  /// Stop polling
  Future<void> _onStopPolling(
    StopPaymentPolling event,
    Emitter<PaymentState> emit,
  ) async {
    _pollingTimer?.cancel();
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
