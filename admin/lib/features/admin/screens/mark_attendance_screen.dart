import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final List<Map<String, dynamic>> _students = [
    {
      "name": "Rahul Sharma",
      "id": "BT2034",
      "avatar": "https://i.pravatar.cc/150?img=11",
      "isPresent": true,
      "isLate": false,
    },
    {
      "name": "Sanjana Gupta",
      "id": "BT2035",
      "avatar": "https://i.pravatar.cc/150?img=41",
      "isPresent": true,
      "isLate": false,
    },
    {
      "name": "Amit Kumar",
      "id": "BT2036",
      "avatar": "https://i.pravatar.cc/150?img=12",
      "isPresent": false,
      "isLate": false,
    },
    {
      "name": "Priya Patel",
      "id": "BT2037",
      "avatar": "https://i.pravatar.cc/150?img=42",
      "isPresent": true,
      "isLate": true,
    },
    {
      "name": "Karan Singh",
      "id": "BT2038",
      "avatar": "https://i.pravatar.cc/150?img=13",
      "isPresent": true,
      "isLate": false,
    },
    {
      "name": "Anjali Bose",
      "id": "BT2039",
      "avatar": "https://i.pravatar.cc/150?img=43",
      "isPresent": false,
      "isLate": false,
    },
    {
      "name": "Vikram Das",
      "id": "BT2040",
      "avatar": "https://i.pravatar.cc/150?img=14",
      "isPresent": true,
      "isLate": false,
    },
    {
      "name": "Nisha Verma",
      "id": "BT2041",
      "avatar": "https://i.pravatar.cc/150?img=44",
      "isPresent": true,
      "isLate": true,
    },
  ];

  String? _selectedDept = 'Engineering';
  String? _selectedCourse = 'CSE';
  String? _selectedSection = 'Section A';

  final List<String> _depts = ['Engineering', 'Management', 'Science'];
  final List<String> _courses = ['CSE', 'ECE', 'ME', 'Finance', 'HR'];
  final List<String> _sections = ['Section A', 'Section B', 'Section C'];

  @override
  Widget build(BuildContext context) {
    int presentCount = _students.where((s) => s['isPresent']).length;
    int absentCount = _students.length - presentCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: Row(
        children: [
          // ── LEFT: Filters ──
          Container(
            width: 340,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E1E2C), Color(0xFF2D2D44)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(top: -50, right: -50, child: _blob(200, 0.05)),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _backButton(context),
                      const SizedBox(height: 48),
                      const Text(
                        "Attendance Tracking",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Select class criteria to load student list and mark attendance.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 40),

                      _filterLabel("DEPARTMENT"),
                      _sidebarDropdown(
                        _depts,
                        _selectedDept,
                        (v) => setState(() => _selectedDept = v),
                      ),
                      const SizedBox(height: 20),

                      _filterLabel("COURSE / BRANCH"),
                      _sidebarDropdown(
                        _courses,
                        _selectedCourse,
                        (v) => setState(() => _selectedCourse = v),
                      ),
                      const SizedBox(height: 20),

                      _filterLabel("CLASS SECTION"),
                      _sidebarDropdown(
                        _sections,
                        _selectedSection,
                        (v) => setState(() => _selectedSection = v),
                      ),

                      const Spacer(),

                      _miniStat(
                        "Total",
                        _students.length.toString(),
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _miniStat(
                        "Present Today",
                        presentCount.toString(),
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _miniStat(
                        "Absent",
                        absentCount.toString(),
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── RIGHT: Student List ──
          Expanded(
            child: Column(
              children: [
                _buildListHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(32),
                    itemCount: _students.length,
                    itemBuilder: (context, index) =>
                        _studentAttendanceRow(_students[index], index),
                  ),
                ),
                _buildBulkActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(opacity),
    ),
  );

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 14,
            ),
            SizedBox(width: 8),
            Text(
              "Back",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget _sidebarDropdown(
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF2D2D44),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white54,
          ),
          isExpanded: true,
          hint: Text(
            "Select",
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 13,
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.fact_check_rounded,
                  color: AppColors.primaryRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$_selectedCourse - $_selectedSection",
                    style: AppTheme.titleStyle.copyWith(fontSize: 22),
                  ),
                  Row(
                    children: [
                      Text(
                        "Thursday, 5th March 2026",
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "• 10:00 AM Session",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _headerActionBtn("Mark All Present", Colors.green, () {
                setState(() {
                  for (var s in _students) {
                    s['isPresent'] = true;
                  }
                });
              }),
              const SizedBox(width: 12),
              _headerActionBtn("Mark All Absent", Colors.red, () {
                setState(() {
                  for (var s in _students) {
                    s['isPresent'] = false;
                  }
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerActionBtn(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _studentAttendanceRow(Map<String, dynamic> student, int index) {
    bool present = student['isPresent'];
    bool late = student['isLate'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(student['avatar']),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                Text(
                  student['id'],
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Late Toggle
          InkWell(
            onTap: () => setState(() => student['isLate'] = !student['isLate']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: late ? Colors.orange : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: late ? Colors.white : Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    late ? "LATE" : "ON TIME",
                    style: TextStyle(
                      color: late ? Colors.white : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),

          // Attendance Toggle
          Row(
            children: [
              _attendanceStatusBtn(
                "ABSENT",
                !present,
                Colors.red,
                () => setState(() => student['isPresent'] = false),
              ),
              const SizedBox(width: 8),
              _attendanceStatusBtn(
                "PRESENT",
                present,
                Colors.green,
                () => setState(() => student['isPresent'] = true),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (index * 40).ms).fadeIn().slideX(begin: 0.05);
  }

  Widget _attendanceStatusBtn(
    String label,
    bool active,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? color : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? color : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey.shade400,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulkActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.grey.shade400,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                "Tip: Click 'Mark All Present' to quickly finish marking for the day.",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRed.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.cloud_done_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                "Save & Submit Attendance",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
