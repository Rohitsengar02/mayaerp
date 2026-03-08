import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StaffAttendanceScreen extends StatefulWidget {
  const StaffAttendanceScreen({super.key});

  @override
  State<StaffAttendanceScreen> createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen> {
  String? _selectedCourse;
  String? _selectedClass;
  String? _selectedSubject;
  DateTime _selectedDate = DateTime.now();
  bool _studentsLoaded = false;
  
  // present, absent, leave
  final Map<String, String> _attendanceState = {};

  final List<String> _courses = ["B.Tech CS", "B.Tech IT"];
  final List<String> _classes = ["2nd Year", "3rd Year"];
  final List<String> _subjects = ["Data Structures", "Computer Networks", "Algorithms Lab"];

  final List<Map<String, dynamic>> _dummyStudents = [
    {"id": "CS-001", "name": "Alice Smith"},
    {"id": "CS-002", "name": "Bob Jones"},
    {"id": "CS-015", "name": "Charlie Brown"},
    {"id": "CS-042", "name": "Eve Davis"},
    {"id": "CS-055", "name": "Frank White"},
    {"id": "CS-060", "name": "Grace Hopper"},
  ];

  @override
  void initState() {
    super.initState();
    for (var s in _dummyStudents) {
      _attendanceState[s['id']] = 'Present'; // default
    }
  }

  void _markAll(String status) {
    setState(() {
      for (var s in _dummyStudents) {
        _attendanceState[s['id']] = status;
      }
    });
  }

  int _getCount(String status) => _attendanceState.values.where((v) => v == status).length;

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile),
            const SizedBox(height: 32),
            _buildSelectionPanel(isMobile),
            const SizedBox(height: 32),
            if (_studentsLoaded) ...[
              _buildStatsRow(),
              const SizedBox(height: 24),
              _buildAttendanceList(isMobile),
            ],
            if (!_studentsLoaded)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 64),
                  child: Column(
                    children: [
                      Icon(Icons.how_to_reg_rounded, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text("Select class details to load students", style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Attendance Management", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -1)),
        const SizedBox(height: 4),
        Text("Mark daily attendance and generate monthly reports.", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildSelectionPanel(bool isMobile) {
    Widget content;
    
    if (isMobile) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _dropdown("Course", _courses, _selectedCourse, (v) => setState(() => _selectedCourse = v)),
                const SizedBox(width: 16),
                _dropdown("Class", _classes, _selectedClass, (v) => setState(() => _selectedClass = v)),
                const SizedBox(width: 16),
                _dropdown("Subject", _subjects, _selectedSubject, (v) => setState(() => _selectedSubject = v)),
                const SizedBox(width: 16),
                _datePickerField(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_selectedCourse != null && _selectedClass != null && _selectedSubject != null) {
                  setState(() => _studentsLoaded = true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select course, class and subject")));
                }
              },
              icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
              label: const Text("Load Students", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      );
    } else {
      content = Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _dropdown("Course", _courses, _selectedCourse, (v) => setState(() => _selectedCourse = v)),
          _dropdown("Class", _classes, _selectedClass, (v) => setState(() => _selectedClass = v)),
          _dropdown("Subject", _subjects, _selectedSubject, (v) => setState(() => _selectedSubject = v)),
          _datePickerField(),
          ElevatedButton.icon(
            onPressed: () {
              if (_selectedCourse != null && _selectedClass != null && _selectedSubject != null) {
                setState(() => _studentsLoaded = true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select course, class and subject")));
              }
            },
            icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
            label: const Text("Load Students", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 5))],
      ),
      child: content,
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _dropdown(String label, List<String> items, String? val, Function(String?) onCh) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: val,
              hint: Text("Select", style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onCh,
            ),
          ),
        ),
      ],
    );
  }

  Widget _datePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2101));
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            width: 150,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Icon(Icons.calendar_today_rounded, size: 16, color: Colors.grey.shade500),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _statBadge("Total", _dummyStudents.length, Colors.blue),
          const SizedBox(width: 12),
          _statBadge("Present", _getCount('Present'), Colors.green),
          const SizedBox(width: 12),
          _statBadge("Late", _getCount('Late'), Colors.amber),
          const SizedBox(width: 12),
          _statBadge("Absent", _getCount('Absent'), Colors.red),
          const SizedBox(width: 16),
          _bulkActionsBtn(),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _bulkActionsBtn() {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
        child: const Icon(Icons.more_vert_rounded, color: Colors.black87, size: 20),
      ),
      tooltip: "Bulk Actions",
      onSelected: (v) => _markAll(v),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'Present', child: Row(children: [Icon(Icons.check_circle_rounded, color: Colors.green, size: 18), SizedBox(width: 8), Text("Mark All Present")])),
        const PopupMenuItem(value: 'Late', child: Row(children: [Icon(Icons.access_time_filled_rounded, color: Colors.amber, size: 18), SizedBox(width: 8), Text("Mark All Late")])),
        const PopupMenuItem(value: 'Absent', child: Row(children: [Icon(Icons.cancel_rounded, color: Colors.red, size: 18), SizedBox(width: 8), Text("Mark All Absent")])),
      ],
    );
  }

  Widget _statBadge(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Text("$count", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildAttendanceList(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dummyStudents.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final student = _dummyStudents[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24, vertical: 16),
                child: isMobile 
                  ? Column(
                      children: [
                        Row(
                          children: [
                            _buildAvatar(student['id'], _attendanceState[student['id']]!),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInfo(student['name'], student['id'])),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildAttendanceControls(student['id'], isMobile: true),
                      ],
                    )
                  : Row(
                      children: [
                        _buildAvatar(student['id'], _attendanceState[student['id']]!),
                        const SizedBox(width: 16),
                        Expanded(child: _buildInfo(student['name'], student['id'])),
                        _buildAttendanceControls(student['id'], isMobile: false),
                      ],
                    ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Attendance Submitted Successfully!"), backgroundColor: Colors.green));
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                  label: const Text("Submit Attendance", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildAvatar(String id, String status) {
    Color color = status == 'Present' ? Colors.green : (status == 'Absent' ? Colors.red : Colors.amber);
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: color.withOpacity(0.1),
        backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=$id"),
      ),
    );
  }

  Widget _buildInfo(String name, String id) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E293B))),
      Text(id, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildAttendanceControls(String studentId, {required bool isMobile}) {
    return Row(
      mainAxisAlignment: isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
      children: [
        _attButton(studentId, 'Present', Colors.green, Icons.check_circle_rounded, isMobile),
        const SizedBox(width: 8),
        _attButton(studentId, 'Late', Colors.amber, Icons.access_time_filled_rounded, isMobile),
        const SizedBox(width: 8),
        _attButton(studentId, 'Absent', Colors.red, Icons.cancel_rounded, isMobile),
      ],
    );
  }

  Widget _attButton(String studentId, String value, Color color, IconData icon, bool isMobile) {
    bool isSelected = _attendanceState[studentId] == value;
    return Expanded(
      flex: isMobile ? 1 : 0,
      child: GestureDetector(
        onTap: () => setState(() => _attendanceState[studentId] = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color : Colors.grey.shade200),
            boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey.shade400),
              if (!isMobile || isSelected) ...[
                const SizedBox(width: 6),
                Text(value, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
