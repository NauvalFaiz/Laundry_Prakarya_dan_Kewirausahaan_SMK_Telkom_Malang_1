import 'package:prakarya_dan_kewirausahaan/features/order/data/models/order_models.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';

abstract class OrderRepository {
  Future<List<ServiceModel>> getServices();
  Future<OrderDetailModel> createOrder(CreateOrderRequest request);
  Future<List<OrderDetailModel>> getMyOrders();
}
