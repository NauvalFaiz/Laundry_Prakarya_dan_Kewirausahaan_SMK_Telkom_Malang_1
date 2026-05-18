import 'package:prakarya_dan_kewirausahaan/features/order/data/datasources/order_remote_data_source.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/data/models/order_models.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/domain/repositories/order_repository.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ServiceModel>> getServices() => remoteDataSource.getServices();

  @override
  Future<OrderDetailModel> createOrder(CreateOrderRequest request) =>
      remoteDataSource.createOrder(request);

  @override
  Future<List<OrderDetailModel>> getMyOrders() => remoteDataSource.getMyOrders();
}
