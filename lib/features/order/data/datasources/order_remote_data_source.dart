import 'package:dio/dio.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/data/models/order_models.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<OrderDetailModel> createOrder(CreateOrderRequest request);
  Future<List<OrderDetailModel>> getMyOrders();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await dio.get('services');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => ServiceModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat layanan');
    }
  }

  @override
  Future<OrderDetailModel> createOrder(CreateOrderRequest request) async {
    try {
      final response = await dio.post('orders', data: request.toJson());
      return OrderDetailModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal membuat pesanan');
    }
  }

  @override
  Future<List<OrderDetailModel>> getMyOrders() async {
    try {
      final response = await dio.get('my-orders');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => OrderDetailModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat pesanan');
    }
  }
}
