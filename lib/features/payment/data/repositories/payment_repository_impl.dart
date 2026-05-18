import 'package:prakarya_dan_kewirausahaan/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaymentModel> generatePaymentUrl(int orderId) async {
    return await remoteDataSource.generatePaymentUrl(orderId);
  }

  @override
  Future<PaymentStatusModel> getPaymentStatus(int orderId) async {
    return await remoteDataSource.getPaymentStatus(orderId);
  }

  @override
  Future<List<OrderDetailModel>> getMyOrders() async {
    return await remoteDataSource.getMyOrders();
  }
}
