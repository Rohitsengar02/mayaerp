import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';

class StudentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  const StudentDetailScreen({super.key, required this.student});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1100;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F6F6),
          body: isMobile
              ? Column(
                  children: [
                    _buildMobileHeader(),
                    _buildTabBar(isMobile),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildPersonalInfoTab(isMobile),
                          _buildAcademicTab(isMobile),
                          _buildFeesTab(isMobile),
                          _buildPerformanceTab(isMobile),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    _buildProfileSidebar(),
                    Expanded(
                      child: Column(
                        children: [
                          _buildHeader(),
                          _buildTabBar(isMobile),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildPersonalInfoTab(isMobile),
                                _buildAcademicTab(isMobile),
                                _buildFeesTab(isMobile),
                                _buildPerformanceTab(isMobile),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildProfileSidebar() {
    return Container(
      width: 320,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2D),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: Column(
        children: [
          const SizedBox(height: 60),
          _backButton(),
          const SizedBox(height: 40),
          Hero(
            tag: 'student_avatar_${widget.student['roll']}',
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 4),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://ui-avatars.com/api/?name=Student&background=random&size=200",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.student['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              widget.student['roll'],
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 40),
          _sidebarStat("Current CGPA", "8.92", Colors.greenAccent),
          _sidebarStat("Attendance", "94%", Colors.blueAccent),
          _sidebarStat("Outstanding", "₹0.00", Colors.orangeAccent),
          const Spacer(),
          _actionBtn(Icons.edit_rounded, "Edit Profile"),
          const SizedBox(height: 12),
          _actionBtn(Icons.print_rounded, "Print ID Card"),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sidebarStat(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _backButton(),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.student['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    widget.student['roll'],
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              _statusBadge(widget.student['status']),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _mobileHeaderStat("GPA", "8.92", Colors.greenAccent),
              _mobileHeaderStat("Attend", "94%", Colors.blueAccent),
              _mobileHeaderStat("Dues", "₹0.00", Colors.orangeAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mobileHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      color: Colors.white,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Student Portfolio",
                style: AppTheme.titleStyle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Complete academic and financial history for ${widget.student['name']}",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          _statusBadge(widget.student['status']),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isMobile) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 32),
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primaryRed,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppColors.primaryRed,
        indicatorWeight: 3,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Personal"),
          Tab(text: "Academics"),
          Tab(text: "Fees"),
          Tab(text: "Performance"),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      child: Column(
        children: [
          _infoGrid([
            {"label": "FULL NAME", "value": widget.student['name']},
            {"label": "FATHER'S NAME", "value": "Rajesh Kumar"},
            {"label": "DATE OF BIRTH", "value": "12 Aug 2004"},
            {"label": "GENDER", "value": "Male"},
            {"label": "BLOOD GROUP", "value": "O+ Positive"},
            {"label": "CATEGORY", "value": "General"},
          ], isMobile),
          SizedBox(height: isMobile ? 24 : 32),
          _infoGrid([
            {"label": "EMAIL ADDRESS", "value": "student.name@example.com"},
            {"label": "PHONE NUMBER", "value": "+91 98765 43210"},
            {"label": "EMERGENCY CONTACT", "value": "+91 99999 00000"},
            {
              "label": "ADDRESS",
              "value": "42, Green Valley Hub, New Delhi, India",
            },
          ], isMobile),
        ],
      ).animate().fadeIn().slideY(begin: 0.05),
    );
  }

  Widget _buildAcademicTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _academicDetailCard("Course Details", [
            {"label": "DEPARTMENT", "value": "School of Computing"},
            {"label": "COURSE", "value": widget.student['course']},
            {"label": "BATCH", "value": "2024-2028"},
            {"label": "SECTION", "value": "A"},
          ], isMobile),
          const SizedBox(height: 32),
          const Text(
            "Enrolled Subjects",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _subjectRow("Data Structures & Algorithms", "Theory + Lab", "CS301", isMobile),
          _subjectRow("Discrete Mathematics", "Theory", "MA202", isMobile),
          _subjectRow("Digital Electronics", "Theory + Lab", "EC105", isMobile),
          _subjectRow("Environmental Studies", "Audit", "ES101", isMobile),
        ],
      ),
    );
  }

  Widget _buildFeesTab(bool isMobile) {
    return ListView(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      children: [
        _feeCard("Academic Fee", "₹85,000", "Paid", Colors.green, isMobile),
        _feeCard("Hostel & Mess Fee", "₹45,000", "Paid", Colors.green, isMobile),
        _feeCard("Examination Fee", "₹2,500", "Pending", Colors.orange, isMobile),
        _feeCard("Library Dues", "₹450", "Overdue", Colors.red, isMobile),
      ],
    );
  }

  Widget _buildPerformanceTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Semester Wise SGPA",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _sgpaCard("SEM 1", "9.2"),
                const SizedBox(width: 16),
                _sgpaCard("SEM 2", "8.7"),
                const SizedBox(width: 16),
                _sgpaCard("SEM 3", "9.1"),
                const SizedBox(width: 16),
                _sgpaCard("SEM 4", "8.9"),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            "Attendance Analysis",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black12),
            ),
            child: const Center(
              child: Text(
                "Attendance Graph View",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── HELPERS ──
  Widget _infoGrid(List<Map<String, String>> items, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 1 : 3,
          childAspectRatio: isMobile ? 4 : 3,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) =>
            _infoBlock(items[index]['label']!, items[index]['value']!),
      ),
    );
  }

  Widget _infoBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _academicDetailCard(String title, List<Map<String, String>> items, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          if (isMobile)
            Column(
              children: items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _infoBlock(e['label']!, e['value']!),
              )).toList(),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items
                  .map((e) => _infoBlock(e['label']!, e['value']!))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _subjectRow(String name, String type, String code, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.book_outlined,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isMobile)
                  Text(
                    type,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                  ),
              ],
            ),
          ),
          if (!isMobile)
            Text(
              type,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          const SizedBox(width: 16),
          Text(
            code,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.primaryRed,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _feeCard(String title, String amount, String status, Color color, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sgpaCard(String sem, String sgpa) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            sem,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sgpa,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton() => InkWell(
    onTap: () => Navigator.pop(context),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white,
        size: 16,
      ),
    ),
  );

  Widget _statusBadge(String status) {
    final isRegular = status == 'Regular';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isRegular
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isRegular ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white54, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
