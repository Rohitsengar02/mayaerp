import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../widgets/admin_sidebar.dart';
import '../../../widgets/admin_bottom_bar.dart';
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
      drawer: Drawer(
        width: 280,
        backgroundColor: Colors.white,
        child: AdminSidebar(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() => _selectedIndex = index);
            Navigator.pop(context); // Close drawer on selection
          },
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              if (!isMobile)
                AdminSidebar(
                  selectedIndex: _selectedIndex,
                  onItemSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                ),
              Expanded(
                child: Stack(
                  children: [
                    if (isMobile && _selectedIndex == 0)
                      Container(
                        height: 360, // Optimized height to terminate after stats cards
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFCE4EC), Color(0xFFF8F6F6)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                      ),
                    Column(
                      children: [
                        if (isMobile) _buildMobileNavbar(isTransparent: _selectedIndex == 0),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: isMobile ? 100 : 0),
                            child: IndexedStack(
                              index: _selectedIndex,
                              children: _screens,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isMobile)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AdminBottomBar(
                    selectedIndex: _selectedIndex,
                    onItemSelected: (index) {
                      setState(() => _selectedIndex = index);
                    },
                  ),
                  AdminBottomBar.floatingCenterButton(context, () {
                    _showMoreMenu(context);
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _moreMenuSlider(context),
    );
  }

  Widget _moreMenuSlider(BuildContext context) {
    final List<Map<String, dynamic>> moreItems = [
      {"icon": Icons.account_tree_rounded, "label": "Academic", "index": 2},
      {"icon": Icons.manage_accounts_rounded, "label": "Users", "index": 4},
      {"icon": Icons.calendar_today_rounded, "label": "Exams", "index": 6},
      {"icon": Icons.local_library_rounded, "label": "Library", "index": 7},
      {"icon": Icons.bar_chart_rounded, "label": "Reports", "index": 8},
      {"icon": Icons.record_voice_over_rounded, "label": "Inquiries", "index": 9},
      {"icon": Icons.directions_bus_rounded, "label": "Transport", "index": 10},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Admin Modules",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.9,
            ),
            itemCount: moreItems.length,
            itemBuilder: (context, index) {
              final item = moreItems[index];
              return _menuGridItem(context, item);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    ).animate().slideY(begin: 1.0, curve: Curves.easeOutCubic, duration: 400.ms);
  }

  Widget _menuGridItem(BuildContext context, Map<String, dynamic> item) {
    bool isSelected = _selectedIndex == item['index'];
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = item['index']);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed.withOpacity(0.05) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed.withOpacity(0.2) : Colors.grey.shade100,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryRed : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item['icon'],
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                item['label'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primaryRed : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNavbar({bool isTransparent = false}) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isTransparent ? Colors.transparent : Colors.white,
        boxShadow: isTransparent
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isTransparent ? Colors.black.withOpacity(0.05) : AppColors.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.menu_rounded, color: isTransparent ? const Color(0xFF1E293B) : AppColors.primaryRed, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Maya ERP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E293B), // Always dark for light pink
                ),
              ),
              Text(
                "ADMINISTRATOR",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFF1F5F9),
                backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=IT2023-042"),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
