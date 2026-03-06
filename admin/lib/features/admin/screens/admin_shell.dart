import 'package:flutter/material.dart';
import '../../../core/app_constants.dart';
import '../../../widgets/admin_sidebar.dart';
import 'admin_dashboard.dart';
import 'user_management_screen.dart';
import 'student_management_screen.dart';
import 'admission_management_screen.dart';
import 'finance_fees_screen.dart';
import 'attendance_exam_screen.dart';
import 'library_management_screen.dart';
import 'reports_settings_screen.dart';
import 'inquiries_screen.dart';
import 'transport_management_screen.dart';
import 'academic_management_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const AdminDashboard(), // 0
    const AdmissionManagementScreen(), // 1 - Admissions
    const AcademicManagementScreen(), // 2 - Academic
    const FinanceFeesScreen(), // 3 - Finance & Fees
    const UserManagementScreen(), // 4 - User Management
    const StudentManagementScreen(), // 5 - Student Management
    const AttendanceExamScreen(
      key: ValueKey('attendance_exams'),
    ), // 6 - Attendance & Exams
    const LibraryManagementScreen(), // 7 - Library Control
    const ReportsSettingsScreen(), // 8 - Reports & Logs
    const InquiriesScreen(), // 9 - Inquiries
    const TransportManagementScreen(), // 10 - Transport
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 1100;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile
          ? Drawer(
              width: 280,
              backgroundColor: Colors.white,
              child: AdminSidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.pop(context); // Close drawer
                },
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            AdminSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          Expanded(
            child: Column(
              children: [
                if (isMobile) _buildMobileNavbar(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavbar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu_rounded, color: Colors.black),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.school_rounded,
              color: AppColors.primaryRed,
              size: 20,
            ),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12"),
          ),
        ],
      ),
    );
  }
}
