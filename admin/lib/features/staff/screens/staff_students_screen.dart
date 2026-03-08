import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StaffStudentsScreen extends StatefulWidget {
  const StaffStudentsScreen({super.key});

  @override
  State<StaffStudentsScreen> createState() => _StaffStudentsScreenState();
}

class _StaffStudentsScreenState extends State<StaffStudentsScreen> {
  String _searchQuery = '';
  String? _selectedCourse;
  String? _selectedClass;

  final List<String> _courses = ["B.Tech CS", "B.Tech IT", "B.Tech ME"];
  final List<String> _classes = ["1st Year", "2nd Year", "3rd Year", "Final Year"];

  final List<Map<String, dynamic>> _students = [
    {"id": "CS2024-001", "name": "Alice Smith", "course": "B.Tech CS", "class": "2nd Year", "contact": "+91 9876543210", "attendance": 85},
    {"id": "CS2024-002", "name": "Bob Jones", "course": "B.Tech CS", "class": "2nd Year", "contact": "+91 9876543211", "attendance": 92},
    {"id": "CS2024-015", "name": "Charlie Brown", "course": "B.Tech CS", "class": "3rd Year", "contact": "+91 9876543212", "attendance": 76},
    {"id": "IT2023-042", "name": "Eve Davis", "course": "B.Tech IT", "class": "Final Year", "contact": "+91 9876543213", "attendance": 95},
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    final filteredStudents = _students.where((s) {
      if (_searchQuery.isNotEmpty && !s['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) && !s['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) return false;
      if (_selectedCourse != null && s['course'] != _selectedCourse) return false;
      if (_selectedClass != null && s['class'] != _selectedClass) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile),
            const SizedBox(height: 32),
            _buildFiltersAndActions(isMobile),
            const SizedBox(height: 24),
            _buildStudentsList(filteredStudents, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Student Management", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -1)),
        const SizedBox(height: 4),
        Text("View and manage students enrolled in your classes.", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildFiltersAndActions(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: "Search by name or ID...",
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF10B981))),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _dropdown("Course", _courses, _selectedCourse, (v) => setState(() => _selectedCourse = v)),
                const SizedBox(width: 12),
                _dropdown("Class", _classes, _selectedClass, (v) => setState(() => _selectedClass = v)),
                if (_selectedCourse != null || _selectedClass != null || _searchQuery.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  _clearFiltersBtn(),
                ],
              ],
            ),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: "Search by name or ID...",
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF10B981))),
            ),
          ),
        ),
        _dropdown("Course", _courses, _selectedCourse, (v) => setState(() => _selectedCourse = v)),
        _dropdown("Class", _classes, _selectedClass, (v) => setState(() => _selectedClass = v)),
        if (_selectedCourse != null || _selectedClass != null || _searchQuery.isNotEmpty)
          _clearFiltersBtn(),
      ],
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _clearFiltersBtn() {
    return TextButton.icon(
      onPressed: () => setState(() { _selectedCourse = null; _selectedClass = null; _searchQuery = ''; }),
      icon: const Icon(Icons.clear_rounded, size: 16),
      label: const Text("Clear Filters", style: TextStyle(fontWeight: FontWeight.bold)),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        backgroundColor: Colors.red.withOpacity(0.05),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _dropdown(String hint, List<String> items, String? val, Function(String?) onCh) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: val,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onCh,
        ),
      ),
    );
  }

  Widget _buildStudentsList(List<Map<String, dynamic>> students, bool isMobile) {
    if (students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text("No students found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text("STUDENT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500))),
                Expanded(flex: 2, child: Text("COURSE & CLASS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500))),
                Expanded(flex: 2, child: Text("CONTACT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500))),
                Expanded(flex: 1, child: Text("ATTENDANCE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500))),
                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text("ACTIONS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500)))),
              ],
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final s = students[index];
            return Container(
              margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: isMobile ? _buildMobileRow(s) : _buildDesktopRow(s),
            ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05);
          },
        ),
      ],
    );
  }

  Widget _buildDesktopRow(Map<String, dynamic> s) {
    Color attColor = s['attendance'] >= 75 ? Colors.green : (s['attendance'] >= 60 ? Colors.orange : Colors.red);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              CircleAvatar(backgroundColor: const Color(0xFF10B981).withOpacity(0.1), backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=${s['id']}")),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text(s['id'], style: TextStyle(color: Colors.grey.shade500, fontSize: 13))],
              ),
            ],
          ),
        ),
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s['course'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), Text(s['class'], style: TextStyle(color: Colors.grey.shade500, fontSize: 13))])),
        Expanded(flex: 2, child: Text(s['contact'], style: TextStyle(color: Colors.grey.shade700, fontSize: 14))),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: attColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text("${s['attendance']}%", style: TextStyle(color: attColor, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'profile', child: Row(children: [Icon(Icons.person_rounded, size: 18, color: Colors.blue), SizedBox(width: 8), Text("View Profile")])),
                const PopupMenuItem(value: 'attendance', child: Row(children: [Icon(Icons.how_to_reg_rounded, size: 18, color: Colors.green), SizedBox(width: 8), Text("Attendance Report")])),
                const PopupMenuItem(value: 'history', child: Row(children: [Icon(Icons.history_edu_rounded, size: 18, color: Colors.purple), SizedBox(width: 8), Text("Academic History")])),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileRow(Map<String, dynamic> s) {
    Color attColor = s['attendance'] >= 75 ? Colors.green : (s['attendance'] >= 60 ? Colors.orange : Colors.red);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: const Color(0xFF10B981).withOpacity(0.1), backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=${s['id']}")),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text(s['id'], style: TextStyle(color: Colors.grey.shade500, fontSize: 13))],
                ),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'profile', child: Row(children: [Icon(Icons.person_rounded, size: 18, color: Colors.blue), SizedBox(width: 8), Text("View Profile")])),
                const PopupMenuItem(value: 'attendance', child: Row(children: [Icon(Icons.how_to_reg_rounded, size: 18, color: Colors.green), SizedBox(width: 8), Text("Attendance Report")])),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s['course'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), Text(s['class'], style: TextStyle(color: Colors.grey.shade500, fontSize: 13))]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: attColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text("${s['attendance']}% Att.", style: TextStyle(color: attColor, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      ],
    );
  }
}
