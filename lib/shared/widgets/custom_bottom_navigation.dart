/// Custom Bottom Navigation Bar matching Figma designs.
///
/// Menyediakan navigasi 4 tab:
/// - Home (Beranda)
/// - Booking (Cari Lapangan)
/// - History (Riwayat)
/// - Profile (Profil)
import 'package:flutter/material.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: AppTextStyles.navLabel.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryRed,
          ),
          unselectedLabelStyle: AppTextStyles.navLabel.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, color: AppColors.primaryRed),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month, color: AppColors.primaryRed),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history, color: AppColors.primaryRed),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, color: AppColors.primaryRed),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
