import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prakarya_dan_kewirausahaan/core/di/injection.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/pages/login_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/auth/presentation/pages/register_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/home/presentation/pages/dashboard_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/splash/presentation/pages/first_screnns.dart';
import 'package:prakarya_dan_kewirausahaan/features/splash/presentation/pages/OnboardScrens.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/presentation/pages/payment_qr_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/presentation/pages/order_list_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/bloc/order_bloc.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/pages/select_service_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/pages/create_order_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/data/models/order_models.dart';
import 'package:prakarya_dan_kewirausahaan/features/order/presentation/pages/order_tracking_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/payment/data/models/payment_model.dart';
import 'package:prakarya_dan_kewirausahaan/features/profile/presentation/pages/profile_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/profile/presentation/pages/membership_screen.dart';
import 'package:prakarya_dan_kewirausahaan/features/profile/presentation/pages/settings_screen.dart';

import '../../features/order/presentation/bloc/order_event.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const FirstScrenns(),
      ),
      GoRoute(
        path: '/onboard',
        name: 'onboard',
        builder: (context, state) => const OnboardScrens(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<OrderBloc>()..add(LoadServices()),
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<PaymentBloc>(),
          child: const OrderListScreen(),
        ),
      ),
      GoRoute(
        path: '/payment-qr/:orderId',
        name: 'payment-qr',
        builder: (context, state) {
          final orderId = int.parse(state.pathParameters['orderId']!);
          return BlocProvider(
            create: (_) => sl<PaymentBloc>(),
            child: PaymentQrScreen(orderId: orderId),
          );
        },
      ),
      GoRoute(
        path: '/select-service',
        name: 'select-service',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<OrderBloc>(),
          child: const SelectServiceScreen(),
        ),
      ),
      GoRoute(
        path: '/create-order',
        name: 'create-order',
        builder: (context, state) {
          final serviceJson = state.extra as Map<String, dynamic>;
          final service = ServiceModel.fromJson(serviceJson);
          return BlocProvider(
            create: (_) => sl<OrderBloc>(),
            child: CreateOrderScreen(service: service),
          );
        },
      ),
      GoRoute(
        path: '/order-tracking',
        name: 'order-tracking',
        builder: (context, state) {
          final orderJson = state.extra as Map<String, dynamic>;
          final order = OrderDetailModel.fromJson(orderJson);
          return OrderTrackingScreen(order: order);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/membership',
        name: 'membership',
        builder: (context, state) => const MembershipScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
