import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/domain/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<LoadServices>(_onLoadServices);
    on<CreateNewOrder>(_onCreateOrder);
    on<LoadOrders>(_onLoadOrders);
  }

  Future<void> _onLoadServices(LoadServices event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final services = await orderRepository.getServices();
      emit(ServicesLoaded(services: services));
    } catch (e) {
      emit(OrderError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onCreateOrder(CreateNewOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await orderRepository.createOrder(event.request);
      emit(OrderCreated(order: order));
    } catch (e) {
      emit(OrderError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await orderRepository.getMyOrders();
      emit(OrdersListLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
