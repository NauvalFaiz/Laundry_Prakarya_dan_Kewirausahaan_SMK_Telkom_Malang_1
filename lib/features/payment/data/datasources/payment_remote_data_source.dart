import 'package:dio/dio.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> generatePaymentUrl(int orderId);
  Future<PaymentStatusModel> getPaymentStatus(int orderId);
  Future<List<OrderDetailModel>> getMyOrders();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaymentModel> generatePaymentUrl(int orderId) async {
    try {
      final response = await dio.post('orders/$orderId/payment-url');
      return PaymentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal generate payment URL');
    }
  }

  @override
  Future<PaymentStatusModel> getPaymentStatus(int orderId) async {
    try {
      final response = await dio.get('orders/$orderId/payment-status');
      return PaymentStatusModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal cek status pembayaran');
    }
  }

  @override
  Future<List<OrderDetailModel>> getMyOrders() async {
    try {
      final response = await dio.get('my-orders');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((e) => OrderDetailModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal mengambil daftar pesanan');
    }
  }
}
