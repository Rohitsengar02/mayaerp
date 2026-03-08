import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import 'student_detail_screen.dart';

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  final List<Map<String, dynamic>> _students = [
    {
      "name": "Alice Smith",
      "roll": "MIT-2024-001",
      "course": "B.Tech CSE",
      "department": "School of Computing",
      "year": "1st Year",
      "status": "Regular",
      "image": "https://api.dicebear.com/7.x/avataaars/svg?seed=Alice",
      "cgpa": "9.2",
    },
    {
      "name": "Bob Jones",
      "roll": "MIT-2023-015",
      "course": "BBA Marketing",
      "department": "Business School",
      "year": "2nd Year",
      "status": "Regular",
      "image": "https://api.dicebear.com/7.x/avataaars/svg?seed=Bob",
      "cgpa": "8.5",
    },
    {
      "name": "Charlie Brown",
      "roll": "MIT-2022-042",
      "course": "MBA Finance",
      "department": "Business School",
      "year": "Final Year",
      "status": "Suspended",
      "image": "https://api.dicebear.com/7.x/avataaars/svg?seed=Charlie",
      "cgpa": "7.8",
    },
    {
      "name": "David Wilson",
      "roll": "MIT-2024-089",
      "course": "B.Sc Physics",
      "department": "Science Dept",
      "year": "1st Year",
      "status": "Regular",
      "image": "https://api.dicebear.com/7.x/avataaars/svg?seed=David",
      "cgpa": "8.9",
    },
    {
      "name": "Emma Watson",
      "roll": "MIT-2024-112",
      "course": "B.Tech Mech",
      "department": "Engineering Dept",
      "year": "1st Year",
      "status": "Regular",
      "image": "https://api.dicebear.com/7.x/avataaars/svg?seed=Emma",
      "cgpa": "9.5",
    },
    {
      "name": "Frank Castle",
      "roll": "MIT-2023-056",
      "course": "B.Tech CSE",
      "department": "School of Computing",
      "year": "2nd Year",
      "status": "Regular",
      "image": "https://api.dicebear.com/7.x/avataaars/svg?seed=Frank",
      "cgpa": "8.2",
    },
  ];

  String _selectedCourse = "All Courses";
  String _selectedYear = "All Years";
  String _selectedStatus = "All Status";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 1100;
        final sidePadding = isMobile ? 20.0 : 40.0;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F6F6),
          body: Column(
            children: [
              _buildHeader(isMobile),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(sidePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsCarousel(isMobile),
                      SizedBox(height: isMobile ? 32 : 48),
                      _buildFilters(isMobile),
                      SizedBox(height: isMobile ? 32 : 40),
                      _buildStudentGrid(width),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Student Registry",
              style: AppTheme.titleStyle.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _headerActionBtn(
                    Icons.file_download_rounded,
                    "Export",
                    Colors.white,
                    Colors.black,
                    () {},
                    isMobile: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _headerActionBtn(
                    Icons.person_add_rounded,
                    "Add",
                    AppColors.primaryRed,
                    Colors.white,
                    () {},
                    isMobile: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Student Registry",
                style: AppTheme.titleStyle.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Management & academic tracking for ${_students.length} active students",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
          Row(
            children: [
              _headerActionBtn(
                Icons.file_download_rounded,
                "Export Data",
                Colors.white,
                Colors.black,
                () {},
              ),
              const SizedBox(width: 16),
              _headerActionBtn(
                Icons.person_add_rounded,
                "Add Student",
                AppColors.primaryRed,
                Colors.white,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCarousel(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _statCard(
            "Total Enrollment",
            "1,240",
            "+12% since last year",
            Icons.people_alt_rounded,
            Colors.blue,
            isMobile: isMobile,
          ),
          SizedBox(width: isMobile ? 16 : 24),
          _statCard(
            "Gender Ratio",
            "52:48",
            "Male to Female",
            Icons.wc_rounded,
            Colors.purple,
            isMobile: isMobile,
          ),
          SizedBox(width: isMobile ? 16 : 24),
          _statCard(
            "Academic Excellence",
            "8.2 GPA",
            "Institutional average",
            Icons.auto_graph_rounded,
            Colors.orange,
            isMobile: isMobile,
          ),
          SizedBox(width: isMobile ? 16 : 24),
          _statCard(
            "Active Clubs",
            "24",
            "3 new this semester",
            Icons.extension_rounded,
            Colors.green,
            isMobile: isMobile,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05);
  }

  Widget _statCard(
    String label,
    String value,
    String trend,
    IconData icon,
    Color color, {
    bool isMobile = false,
  }) {
    return Container(
      width: isMobile ? 260 : 320,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isMobile ? 12 : 14),
                ),
                child: Icon(icon, color: color, size: isMobile ? 20 : 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.green,
                  size: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 20 : 24),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 28 : 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 13 : 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trend,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: isMobile ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerActionBtn(
    IconData icon,
    String label,
    Color bg,
    Color fg,
    VoidCallback onTap, {
    bool isMobile = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: bg != Colors.white
            ? [
                BoxShadow(
                  color: bg.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 20,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: fg, size: isMobile ? 18 : 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 12 : 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _searchBar(isMobile: true),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.03)),
            ),
            child: Column(
              children: [
                _filterDropdown(
                  "Course",
                  ["All Courses", "B.Tech", "B.Sc", "MBA", "BBA"],
                  _selectedCourse,
                  (v) => setState(() => _selectedCourse = v!),
                  isMobile: true,
                ),
                const Divider(height: 24),
                _filterDropdown(
                  "Year",
                  ["All Years", "1st Year", "2nd Year", "3rd Year", "Final Year"],
                  _selectedYear,
                  (v) => setState(() => _selectedYear = v!),
                  isMobile: true,
                ),
                const Divider(height: 24),
                _filterDropdown(
                  "Status",
                  ["All Status", "Regular", "Alumni", "Suspended"],
                  _selectedStatus,
                  (v) => setState(() => _selectedStatus = v!),
                  isMobile: true,
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.filter_list_rounded,
            color: Colors.blueAccent,
            size: 22,
          ),
          const SizedBox(width: 24),
          _filterDropdown(
            "Course",
            ["All Courses", "B.Tech", "B.Sc", "MBA", "BBA"],
            _selectedCourse,
            (v) => setState(() => _selectedCourse = v!),
          ),
          const SizedBox(width: 20),
          _filterDropdown(
            "Academic Year",
            ["All Years", "1st Year", "2nd Year", "3rd Year", "Final Year"],
            _selectedYear,
            (v) => setState(() => _selectedYear = v!),
          ),
          const SizedBox(width: 20),
          _filterDropdown(
            "Status",
            ["All Status", "Regular", "Alumni", "Suspended"],
            _selectedStatus,
            (v) => setState(() => _selectedStatus = v!),
          ),
          const Spacer(),
          _searchBar(),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _searchBar({bool isMobile = false}) {
    return Container(
      width: isMobile ? double.infinity : 300,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isMobile ? Colors.white : const Color(0xFFF8F6F6),
        borderRadius: BorderRadius.circular(14),
        border: isMobile ? Border.all(color: Colors.black.withOpacity(0.05)) : null,
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search by ID, Name...",
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, color: Colors.grey, size: 20),
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _filterDropdown(
    String label,
    List<String> items,
    String value,
    Function(String?) onChanged, {
    bool isMobile = false,
  }) {
    final dropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: isMobile,
          items: items
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    i,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );

    if (isMobile) {
      return Row(
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: dropdown),
        ],
      );
    }

    return Row(
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(width: 12),
        dropdown,
      ],
    );
  }

  Widget _buildStudentGrid(double width) {
    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    int crossAxisCount = 3;
    if (isMobile) crossAxisCount = 1;
    else if (isTablet) crossAxisCount = 2;

    double childAspectRatio = 2.2;
    if (isMobile) childAspectRatio = 2.4;
    else if (isTablet) childAspectRatio = 1.8;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: isMobile ? 16 : 24,
        mainAxisSpacing: isMobile ? 16 : 24,
      ),
      itemCount: _students.length,
      itemBuilder: (context, index) => _studentCard(_students[index], index, isMobile),
    );
  }

  Widget _studentCard(Map<String, dynamic> s, int index, bool isMobile) {
    return Hero(
      tag: 'student_avatar_${s['roll']}',
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
          border: Border.all(color: Colors.black.withOpacity(0.03)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentDetailScreen(student: s),
              ),
            ),
            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: isMobile ? 60 : 70,
                      height: isMobile ? 60 : 70,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
                        image: DecorationImage(
                          image: NetworkImage(s['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: isMobile ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  s['roll'],
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              _statusSmallBadge(s['status']),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            s['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: isMobile ? 16 : 17,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            s['department'],
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: isMobile ? 10 : 11,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Divider(height: 1),
                SizedBox(height: isMobile ? 12 : 16),
                Row(
                  children: [
                    Expanded(child: _miniInfo(Icons.school_rounded, s['course'])),
                    if (!isMobile) ...[
                      const SizedBox(width: 16),
                      _miniInfo(Icons.stars_rounded, "CGPA: ${s['cgpa']}"),
                    ],
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
    .animate(delay: (index * 60).ms)
    .fadeIn()
    .scale(begin: const Offset(0.98, 0.98));
  }

  Widget _statusSmallBadge(String status) {
    bool isRegular = status == "Regular";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isRegular ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isRegular ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
