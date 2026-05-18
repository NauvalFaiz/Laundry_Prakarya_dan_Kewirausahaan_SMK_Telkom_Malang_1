import 'package:equatable/equatable.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/data/models/order_models.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class ServicesLoaded extends OrderState {
  final List<ServiceModel> services;
  ServicesLoaded({required this.services});

  @override
  List<Object?> get props => [services];
}

class OrderCreated extends OrderState {
  final OrderDetailModel order;
  OrderCreated({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrdersListLoaded extends OrderState {
  final List<OrderDetailModel> orders;
  OrdersListLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderError extends OrderState {
  final String message;
  OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}
