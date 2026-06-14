/// Main Shell wrapper for bottom navigation.
///
/// Menyediakan layout utama dengan bottom navigation yang tetap ada
/// saat berganti tab (Home, Booking, History, Profile).
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/shared/widgets/custom_bottom_navigation.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/booking')) {
      return 1;
    }
    if (location.startsWith('/history')) {
      return 2;
    }
    if (location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed('home');
        break;
      case 1:
        context.goNamed('booking');
        break;
      case 2:
        context.goNamed('history');
        break;
      case 3:
        context.goNamed('profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
