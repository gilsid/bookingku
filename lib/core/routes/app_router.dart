/// Konfigurasi routing aplikasi BookingKu menggunakan GoRouter.
///
/// Mengatur navigasi antar halaman termasuk:
/// - Splash screen
/// - Autentikasi (Login, Register)
/// - Main app dengan bottom navigation (Home, Booking, History, Profile)
/// - Halaman detail (Payment, Ticket, Notification, dll.)
///
/// Nantinya saat backend tersedia, route guard akan mengecek
/// token dari API untuk menentukan apakah user sudah login.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/features/auth/presentation/pages/login_page.dart';
import 'package:bookingku/features/auth/presentation/pages/register_page.dart';
import 'package:bookingku/features/home/presentation/pages/home_page.dart';
import 'package:bookingku/features/booking/presentation/pages/booking_page.dart';
import 'package:bookingku/features/booking/presentation/pages/booking_confirmation_page.dart';
import 'package:bookingku/features/booking/presentation/pages/ticket_page.dart';
import 'package:bookingku/features/payment/presentation/pages/payment_detail_page.dart';
import 'package:bookingku/features/payment/presentation/pages/payment_success_page.dart';
import 'package:bookingku/features/payment/presentation/pages/upload_proof_page.dart';
import 'package:bookingku/features/history/presentation/pages/history_page.dart';
import 'package:bookingku/features/notification/presentation/pages/notification_page.dart';
import 'package:bookingku/features/profile/presentation/pages/profile_page.dart';
import 'package:bookingku/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:bookingku/features/profile/presentation/pages/change_password_page.dart';
import 'package:bookingku/features/field/presentation/pages/field_detail_page.dart';
import 'package:bookingku/features/splash/presentation/pages/splash_page.dart';
import 'package:bookingku/core/routes/main_shell.dart';

/// Nama-nama route yang digunakan dalam aplikasi.
/// Gunakan nama ini untuk navigasi agar type-safe.
class AppRouteNames {
  AppRouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String booking = 'booking';
  static const String history = 'history';
  static const String profile = 'profile';
  static const String notification = 'notification';
  static const String fieldDetail = 'field-detail';
  static const String bookingConfirmation = 'booking-confirmation';
  static const String paymentDetail = 'payment-detail';
  static const String paymentSuccess = 'payment-success';
  static const String uploadProof = 'upload-proof';
  static const String ticket = 'ticket';
  static const String editProfile = 'edit-profile';
  static const String changePassword = 'change-password';
}

/// Konfigurasi GoRouter utama.
///
/// Menggunakan ShellRoute untuk bottom navigation agar state
/// pada setiap tab dipertahankan saat berpindah tab.
class AppRouter {
  AppRouter._();

  /// GlobalKey untuk navigator, digunakan untuk navigasi tanpa context.
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// Router instance.
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),

      // Main App Shell (Bottom Navigation)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: AppRouteNames.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/booking',
            name: AppRouteNames.booking,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BookingPage(),
            ),
          ),
          GoRoute(
            path: '/history',
            name: AppRouteNames.history,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HistoryPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: AppRouteNames.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),

      // Detail Routes (di luar shell agar full screen)
      GoRoute(
        path: '/notification',
        name: AppRouteNames.notification,
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: '/field/:id',
        name: AppRouteNames.fieldDetail,
        builder: (context, state) => FieldDetailPage(
          fieldId: int.parse(state.pathParameters['id'] ?? '0'),
        ),
      ),
      GoRoute(
        path: '/booking-confirmation',
        name: AppRouteNames.bookingConfirmation,
        builder: (context, state) => const BookingConfirmationPage(),
      ),
      GoRoute(
        path: '/payment-detail',
        name: AppRouteNames.paymentDetail,
        builder: (context, state) => const PaymentDetailPage(),
      ),
      GoRoute(
        path: '/payment-success',
        name: AppRouteNames.paymentSuccess,
        builder: (context, state) => const PaymentSuccessPage(),
      ),
      GoRoute(
        path: '/upload-proof',
        name: AppRouteNames.uploadProof,
        builder: (context, state) => const UploadProofPage(),
      ),
      GoRoute(
        path: '/ticket/:bookingId',
        name: AppRouteNames.ticket,
        builder: (context, state) => TicketPage(
          bookingId: state.pathParameters['bookingId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/edit-profile',
        name: AppRouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/change-password',
        name: AppRouteNames.changePassword,
        builder: (context, state) => const ChangePasswordPage(),
      ),
    ],
  );
}
