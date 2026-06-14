import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookingku/core/theme/app_theme.dart';
import 'package:bookingku/core/routes/app_router.dart';
import 'package:bookingku/core/services/storage_service.dart';

// Repositories Implementations
import 'package:bookingku/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bookingku/features/home/data/repositories/home_repository_impl.dart';
import 'package:bookingku/features/field/data/repositories/field_repository_impl.dart';
import 'package:bookingku/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:bookingku/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:bookingku/features/notification/data/repositories/notification_repository_impl.dart';

// Providers
import 'package:bookingku/features/auth/presentation/providers/auth_provider.dart';
import 'package:bookingku/features/home/presentation/providers/home_provider.dart';
import 'package:bookingku/features/field/presentation/providers/field_provider.dart';
import 'package:bookingku/features/booking/presentation/providers/booking_provider.dart';
import 'package:bookingku/features/payment/presentation/providers/payment_provider.dart';
import 'package:bookingku/features/notification/presentation/providers/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Storage Service
  final storageService = StorageService();
  await storageService.init();

  // Initialize Repositories
  final authRepository = AuthRepositoryImpl(storageService);
  final homeRepository = HomeRepositoryImpl();
  final fieldRepository = FieldRepositoryImpl();
  final bookingRepository = BookingRepositoryImpl();
  final paymentRepository = PaymentRepositoryImpl();
  final notificationRepository = NotificationRepositoryImpl();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => HomeProvider(homeRepository)),
        ChangeNotifierProvider(create: (_) => FieldProvider(fieldRepository)),
        ChangeNotifierProvider(create: (_) => BookingProvider(bookingRepository)),
        ChangeNotifierProvider(create: (_) => PaymentProvider(paymentRepository)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(notificationRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BookingKu',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
