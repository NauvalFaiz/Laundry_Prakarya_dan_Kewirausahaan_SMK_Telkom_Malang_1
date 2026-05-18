import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';

abstract class PaymentRepository {
  Future<PaymentModel> generatePaymentUrl(int orderId);
  Future<PaymentStatusModel> getPaymentStatus(int orderId);
  Future<List<OrderDetailModel>> getMyOrders();
}
