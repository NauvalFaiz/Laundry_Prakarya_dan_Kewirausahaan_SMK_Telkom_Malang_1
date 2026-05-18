import 'package:equatable/equatable.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/data/models/order_models.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadServices extends OrderEvent {}

class CreateNewOrder extends OrderEvent {
  final CreateOrderRequest request;
  CreateNewOrder({required this.request});

  @override
  List<Object?> get props => [request];
}

class LoadOrders extends OrderEvent {}
