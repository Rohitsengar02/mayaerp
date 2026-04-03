import 'package:flutter/material.dart';
import '../../core/app_constants.dart';
import '../../core/app_theme.dart';
import '../features/onboarding/screens/showcase_screen.dart';
import '../core/services/auth_service.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 40,
            offset: const Offset(10, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Maya Institute",
                      style: AppTheme.titleStyle.copyWith(fontSize: 16),
                    ),
                    Text(
                      "ERP EXECUTIVE",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryRed,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _sectionLabel("MAIN MENU"),
                const SizedBox(height: 8),
                _sidebarItem(context, Icons.dashboard_rounded, "Dashboard", 0),
                _sidebarItem(
                  context,
                  Icons.person_add_rounded,
                  "Admissions",
                  1,
                ),
                const SizedBox(height: 16),
                _sectionLabel("MANAGEMENT"),
                const SizedBox(height: 8),
                _sidebarItem(
                  context,
                  Icons.account_tree_rounded,
                  "Course Management",
                  2,
                ),
                _sidebarItem(
                  context,
                  Icons.account_balance_wallet_rounded,
                  "Finance & Fees",
                  3,
                ),
                _sidebarItem(
                  context,
                  Icons.manage_accounts_rounded,
                  "User Management",
                  4,
                ),
                _sidebarItem(
                  context,
                  Icons.school_rounded,
                  "Student Management",
                  5,
                ),
                _sidebarItem(
                  context,
                  Icons.calendar_today_rounded,
                  "Attendance & Exams",
                  6,
                ),
                _sidebarItem(
                  context,
                  Icons.local_library_rounded,
                  "Library Control",
                  7,
                ),
                _sidebarItem(
                  context,
                  Icons.bar_chart_rounded,
                  "Reports & Logs",
                  8,
                ),
                _sidebarItem(
                  context,
                  Icons.record_voice_over_rounded,
                  "Inquiries",
                  9,
                ),
                _sidebarItem(
                  context,
                  Icons.directions_bus_rounded,
                  "Transport Hub",
                  10,
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          _sidebarItem(
            context,
            Icons.logout_rounded,
            "Sign Out",
            -1,
            color: AppColors.primaryRed,
            onTap: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const ShowcaseScreen()),
                  (route) => false,
                );
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Colors.grey,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _sidebarItem(
    BuildContext context,
    IconData icon,
    String title,
    int index, {
    VoidCallback? onTap,
    Color? color,
  }) {
    final isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryRed.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          onTap: onTap ?? () => onItemSelected(index),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryRed.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.primaryRed
                        : (color ?? Colors.grey.shade500),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryRed
                        : (color ?? AppColors.textMain),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
