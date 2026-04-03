import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/services/student_service.dart';
import '../../../core/services/faculty_service.dart';
import '../../../core/services/timetable_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/course_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> course;
  final Map<String, dynamic> branch;
  final VoidCallback onBack;

  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.branch,
    required this.onBack,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _students = [];
  List<dynamic> _faculty = [];
  Map<String, dynamic>? _timetable;
  late Map<String, dynamic> _courseData;
  bool _isLoading = true;
  int _activeSemester = 1;

  List<String> _timetableDays = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'];
  List<String> _timetableSlots = ['1st', '2nd', '3rd', '4th', 'BREAK', '5th', '6th', '7th', '8th', 'EXTRA CLASS'];

  late IO.Socket _socket;

  void _initSocket() {
    final serverUrl = dotenv.get('BACKEND_URL', fallback: 'http://localhost:5000/api').replaceAll('/api', '');
    _socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.connect();
    
    _socket.on('timetable_updated', (data) {
      if (mounted && 
          data['courseId'] == widget.course['_id'] && 
          data['branchId'] == widget.branch['_id'] && 
          data['semester'] == _activeSemester) {
          _loadAllData(showLoading: false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _courseData = Map<String, dynamic>.from(widget.course);
    _tabController = TabController(length: 4, vsync: this);
    _loadAllData();
    _initSocket();
  }

  @override
  void dispose() {
    _socket.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData({bool showLoading = true}) async {
    try {
      if (showLoading) setState(() => _isLoading = true);
      
      final results = await Future.wait([
        StudentService.getAllStudents(),
        FacultyService.getCourseFaculty(widget.course['_id']),
        TimetableService.getTimetable(widget.course['_id'], widget.branch['_id'], _activeSemester),
        CourseService.getCourseById(widget.course['_id']),
      ]);

      final allStudents = results[0] as List<dynamic>;
      final courseStudents = allStudents.where((s) => s['selectedProgram'] == widget.course['_id'] && s['selectedBranch'] == widget.branch['_id']).toList();
      
      if (mounted) {
        setState(() {
          _students = courseStudents;
          _faculty = results[1] as List<dynamic>;
          _timetable = (results[2] as Map<String, dynamic>)['schedule'] != null ? results[2] as Map<String, dynamic> : null;
          
          if (_timetable != null) {
            if (_timetable!['days'] != null) _timetableDays = List<String>.from(_timetable!['days']);
            if (_timetable!['slots'] != null) _timetableSlots = List<String>.from(_timetable!['slots']);
          }

          _courseData = results[3] as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 1100;
        double sidePadding = isMobile ? 20 : 40;

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
                      _buildCourseBanner(isMobile),
                      SizedBox(height: isMobile ? 32 : 48),
                      _buildStatsRow(isMobile),
                      SizedBox(height: isMobile ? 32 : 48),
                      _buildTabBar(isMobile),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 500,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildCurriculumTab(isMobile),
                            _buildStudentsTab(),
                            _buildFacultyTab(),
                            _buildResourcesTab(),
                          ],
                        ),
                      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.course['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 26),
                Text(
                  widget.course['code'],
                  style: TextStyle(
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "•",
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.branch['name'],
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.course['name'],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    widget.branch['name'],
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "•",
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.course['code'],
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            icon: const Icon(Icons.edit_note_rounded, color: Colors.black),
            label: const Text(
              "Edit Course Meta",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseBanner(bool isMobile) {
    if (isMobile) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.branch['icon'],
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _badge(widget.course['type'] ?? "Full-Time", Colors.blue),
                          const SizedBox(width: 8),
                          _badge(widget.course['status'] ?? "Active", Colors.green),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.course['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white10),
            const SizedBox(height: 16),
            const Text(
              "Enrolled Intake",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_isLoading ? '...' : _students.length}/${widget.course['intakeCapacity'] ?? 60}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  "Credits: 160",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: double.infinity,
                height: 4,
                child: LinearProgressIndicator(
                  value: _isLoading ? 0 : (_students.length) / (double.tryParse(widget.course['intakeCapacity'].toString()) ?? 60.0),
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation(Colors.green),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(widget.branch['icon'], color: Colors.white, size: 50),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _badge(widget.course['type'] ?? "Full-Time", Colors.blue),
                    const SizedBox(width: 12),
                    _badge(widget.course['status'] ?? "Active", Colors.green),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.course['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Credits Requirement: ${widget.course['credits'] ?? 160} • Professional Certification Track Included",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 80,
            color: Colors.white24,
            indent: 20,
            endIndent: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enrolled Students",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${_isLoading ? '...' : _students.length}/${widget.course['intakeCapacity'] ?? 60}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 140,
                  height: 4,
                  child: LinearProgressIndicator(
                    value: _isLoading ? 0 : (_students.length) / (double.tryParse(widget.course['intakeCapacity'].toString()) ?? 60.0),
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation(Colors.green),
                  ),
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98));
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    if (isMobile) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2,
        children: [
          _statBox(
            "12",
            "Faculty",
            Icons.people_outline_rounded,
            isMobile: true,
          ),
          _statBox(
            "8",
            "Semesters",
            Icons.calendar_today_rounded,
            isMobile: true,
          ),
          _statBox("24", "Lab Units", Icons.biotech_rounded, isMobile: true),
          _statBox(
            "94%",
            "Placement",
            Icons.trending_up_rounded,
            isMobile: true,
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: _statBox("12", "Faculty Nodes", Icons.people_outline_rounded)),
        const SizedBox(width: 24),
        Expanded(child: _statBox("8", "Semesters", Icons.calendar_today_rounded)),
        const SizedBox(width: 24),
        Expanded(child: _statBox("24", "Lab Units", Icons.biotech_rounded)),
        const SizedBox(width: 24),
        Expanded(child: _statBox("94%", "Placement Rate", Icons.trending_up_rounded)),
      ],
    );
  }

  Widget _statBox(
    String val,
    String label,
    IconData icon, {
    bool isMobile = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F6F6),
              borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
            ),
            child: Icon(
              icon,
              size: isMobile ? 16 : 20,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  val,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: isMobile ? 9 : 11,
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
    );
  }

  Widget _buildTabBar(bool isMobile) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppColors.primaryRed,
        indicatorWeight: 3,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: isMobile ? 13 : 15,
        ),
        padding: EdgeInsets.zero,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: "Curriculum Map"),
          Tab(text: "Student Roster"),
          Tab(text: "Faculty Allocation"),
          Tab(text: "Time Table"),
        ],
      ),
    );
  }

  Widget _buildCurriculumTab(bool isMobile) {
    final curriculum = (_courseData['curriculum'] as List? ?? []);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Semesters: ${curriculum.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _showAddSemesterDialog,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text("Add Semester"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: curriculum.isEmpty
              ? const Center(child: Text("No curriculum defined yet."))
              : ListView.separated(
                  itemCount: curriculum.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final sem = curriculum[i];
                    return _buildSemesterCard(sem, isMobile);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSemesterCard(Map<String, dynamic> sem, bool isMobile) {
    final subjects = (sem['subjects'] as List? ?? []);
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.02)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFF8F6F6),
                radius: 18,
                child: Text("${sem['semester']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Semester ${sem['semester']}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  Text("${sem['credits'] ?? 0} Total Credits", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showAddSubjectDialog(sem['semester']),
                icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.blue),
                tooltip: "Add Subject",
              ),
            ],
          ),
          if (subjects.isNotEmpty) ...[
            const Divider(height: 32),
            ...subjects.map((sub) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF8F6F6), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.book_rounded, size: 16, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sub['name'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text("${sub['code'] ?? ''} • ${sub['credits'] ?? 0} Credits", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                      ],
                    ),
                  ),
                  _badge(sub['type'] ?? 'Core', Colors.orange),
                ],
              ),
            )).toList(),
          ],
        ],
      ),
    );
  }

  void _showAddSemesterDialog() {
    final semController = TextEditingController();
    final creditsController = TextEditingController();
    _showBeautifulDialog(
      title: "Add Semester",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _beautifulTextField(controller: semController, label: "Semester Number", icon: Icons.numbers),
          const SizedBox(height: 16),
          _beautifulTextField(controller: creditsController, label: "Target Credits", icon: Icons.star_border_rounded),
        ],
      ),
      onConfirm: () async {
        final newCurriculum = List<Map<String, dynamic>>.from(_courseData['curriculum'] ?? []);
        newCurriculum.add({
          'semester': int.tryParse(semController.text) ?? (newCurriculum.length + 1),
          'credits': int.tryParse(creditsController.text) ?? 20,
          'subjects': [],
        });
        await _updateCurriculum(newCurriculum);
      },
    );
  }

  void _showAddSubjectDialog(int semester) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final creditsController = TextEditingController();
    _showBeautifulDialog(
      title: "Add Subject to Sem $semester",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _beautifulTextField(controller: nameController, label: "Subject Name", icon: Icons.book_outlined),
          const SizedBox(height: 16),
          _beautifulTextField(controller: codeController, label: "Subject Code", icon: Icons.qr_code_rounded),
          const SizedBox(height: 16),
          _beautifulTextField(controller: creditsController, label: "Credits", icon: Icons.grade_rounded),
        ],
      ),
      onConfirm: () async {
        final newCurriculum = List<Map<String, dynamic>>.from(_courseData['curriculum'] ?? []);
        final semIndex = newCurriculum.indexWhere((s) => s['semester'] == semester);
        if (semIndex != -1) {
          final subjects = List<Map<String, dynamic>>.from(newCurriculum[semIndex]['subjects'] ?? []);
          subjects.add({
            'name': nameController.text,
            'code': codeController.text,
            'credits': int.tryParse(creditsController.text) ?? 3,
          });
          newCurriculum[semIndex]['subjects'] = subjects;
          await _updateCurriculum(newCurriculum);
        }
      },
    );
  }

  Future<void> _updateCurriculum(List<Map<String, dynamic>> curriculum) async {
    try {
      final updated = await CourseService.updateCourse(widget.course['_id'], {'curriculum': curriculum});
      setState(() => _courseData = updated);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _buildFacultyTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Faculty Allocation", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5)),
                  Text("Technical instructors for this course", style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showAddFacultyDialog,
                icon: const Icon(Icons.person_add_rounded, size: 18),
                label: const Text("Assign New"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _faculty.isEmpty
              ? _buildEmptyState(Icons.group_off_rounded, "No faculty assigned")
              : ListView.separated(
                  itemCount: _faculty.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final f = _faculty[i];
                    final user = f['userId'] ?? {};
                    final name = "${user['firstName'] ?? ''} ${user['lastName'] ?? ''}";
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black.withOpacity(0.04)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primaryRed.withOpacity(0.1),
                            backgroundImage: user['profilePhoto'] != null ? NetworkImage(user['profilePhoto']) : null,
                            child: user['profilePhoto'] == null ? Text(user['firstName']?[0] ?? 'F', style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold)) : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(user['email'] ?? "", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                                if (f['subjects'] != null && (f['subjects'] as List).isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Wrap(
                                      spacing: 8,
                                      children: (f['subjects'] as List).map((s) => _badge(s.toString(), Colors.blue)).toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey),
                            onPressed: () async {
                              await FacultyService.deleteFaculty(f['_id']);
                              _loadAllData();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStudentsTab() {
    if (_students.isEmpty) {
      return _buildEmptyState(Icons.person_off_rounded, "No students enrolled yet");
    }
    return ListView.separated(
      itemCount: _students.length,
      padding: const EdgeInsets.symmetric(vertical: 24),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final student = _students[i];
        final name = "${student['firstName']} ${student['lastName']}";
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withOpacity(0.04)),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(student['applicantPhoto'] ?? "https://ui-avatars.com/api/?name=$name&background=random"),
            ),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(student['email'] ?? "No email"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(student['status'] ?? "Active", style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ),
        );
      },
    );
  }

  void _showAddFacultyDialog() async {
    List<dynamic> allUsers = [];
    List<dynamic> filteredUsers = [];
    String subjectTeaching = "";

    try {
      final fetchedUsers = await UserService.getAllUsers();
      allUsers = fetchedUsers.where((u) => u['role']?.toString().toLowerCase() != 'admin').toList();
      filteredUsers = List.from(allUsers);
    } catch (e) {
      print("Error loading users: $e");
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Assign Faculty member", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                const SizedBox(height: 24),
                _beautifulTextField(
                  label: "Search Users",
                  icon: Icons.search,
                  onChanged: (val) {
                    setDialogState(() {
                      filteredUsers = allUsers.where((u) {
                        final name = "${u['firstName']} ${u['lastName']}".toLowerCase();
                        final email = (u['email'] ?? "").toString().toLowerCase();
                        return name.contains(val.toLowerCase()) || email.contains(val.toLowerCase());
                      }).toList();
                    });
                  },
                ),
                const SizedBox(height: 16),
                _beautifulTextField(
                  label: "Teaching Subject(s)",
                  icon: Icons.auto_stories_rounded,
                  onChanged: (val) => setDialogState(() => subjectTeaching = val),
                ),
                const SizedBox(height: 24),
                const Text("Available Users", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    itemCount: filteredUsers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F1F1)),
                    itemBuilder: (context, i) {
                      final u = filteredUsers[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text(u['firstName'][0])),
                        title: Text("${u['firstName']} ${u['lastName']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(u['email'] ?? ""),
                        onTap: () async {
                          try {
                            print("Attempting to add faculty: courseId=${widget.course['_id']}, userId=${u['_id']}");
                            await FacultyService.addFaculty({
                              'userId': u['_id'],
                              'courseId': widget.course['_id'],
                              'subjects': subjectTeaching.isNotEmpty ? [subjectTeaching] : [],
                            });
                            _loadAllData();
                            if (context.mounted) Navigator.pop(context);
                          } catch (e) {
                            print("Error assigning faculty: $e");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"))]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResourcesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_view_week_rounded, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 24),
          const Text("Live Academic Timetable", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5)),
          const Text("Manage weekly schedules and slot allocations", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showTimetableFullscreen,
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text("Open Full Timetable View"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showTimetableFullscreen() {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Navigator.pop(context)),
                title: const Text("Weekly Timetable Builder", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _semesterDropdown(),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildTimetableGrid(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableGrid() {
    return Column(
      children: [
        _buildDynamicHeader(),
        _buildRoutineSubheader(),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.2)),
                child: Column(
                  children: [
                    _buildSlotsHeaderRow(),
                    ..._timetableDays.map((day) => _buildDayRow(day)),
                    _buildAddDayRow(),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildCommitSaveButton(),
        const SizedBox(height: 12),
        _buildPDFExportButton(),
      ],
    );
  }

  Widget _buildPDFExportButton() {
     return SizedBox(
       width: double.infinity,
       child: ElevatedButton.icon(
         onPressed: _exportTimetableToPDF,
         icon: const Icon(Icons.picture_as_pdf_outlined),
         label: const Text("EXPORT BEAUTIFUL PDF RECAP"),
         style: ElevatedButton.styleFrom(
           backgroundColor: Colors.white,
           foregroundColor: Colors.black,
           padding: const EdgeInsets.all(20),
           side: const BorderSide(color: Colors.black12),
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
         ),
       ),
     );
  }

  Future<void> _exportTimetableToPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Header
              pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(12),
                decoration: const pw.BoxDecoration(color: PdfColors.blue900),
                child: pw.Text("MAYA COLLAGE PRO - ACADEMIC PORTAL", style: pw.TextStyle(color: PdfColors.yellow, fontWeight: pw.FontWeight.bold, fontSize: 24)),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                   pw.Text("COURSE: ${widget.course['name']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                   pw.Text("SEMESTER: $_activeSemester", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                   pw.Text("DATE: ${DateTime.now().toString().split(' ')[0]}", style: pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 20),
              
              // Grid
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Slots Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.green),
                    children: [
                      _pdfHeaderCell("DAYS"),
                      ..._timetableSlots.map((s) => _pdfHeaderCell(s)),
                    ],
                  ),
                  // Day Rows
                  ..._timetableDays.map((day) {
                    return pw.TableRow(
                      children: [
                        _pdfHeaderCell(day),
                        ..._timetableSlots.asMap().entries.map((e) {
                          final slotName = e.value;
                          if (slotName == 'BREAK') return _pdfHeaderCell("BREAK");
                          
                          final sched = _getSlot(day, slotName);
                          if (sched != null) {
                             return pw.Container(
                               height: 60,
                               padding: const pw.EdgeInsets.all(4),
                               child: pw.Column(
                                 mainAxisAlignment: pw.MainAxisAlignment.center,
                                 children: [
                                   pw.Text(sched['subject'], style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                   pw.SizedBox(height: 2),
                                   pw.Text(sched['facultyName'], style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                                 ],
                               ),
                             );
                          }
                          return pw.Container(height: 60);
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _pdfHeaderCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      alignment: pw.Alignment.center,
      child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _buildDynamicHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF1B3E5F)), 
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: const Center(
        child: Text("DYNAMIC TIME TABLE", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 2)),
      ),
    );
  }

  Widget _buildRoutineSubheader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFFFFFF00)),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text("ROUTINE FOR ${widget.course['name'].toString().toUpperCase()} - SEMESTER $_activeSemester", style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildSlotsHeaderRow() {
    return Row(
      children: [
        _gridCell("DAYS", color: const Color(0xFF76C44B), isHeader: true),
        ..._timetableSlots.asMap().entries.map((e) => Stack(
          children: [
            _gridCell(e.value, color: const Color(0xFF76C44B), isHeader: true),
            Positioned(
              top: 0, right: 0,
              child: InkWell(
                onTap: () => setState(() => _timetableSlots.removeAt(e.key)),
                child: const Icon(Icons.remove_circle, size: 14, color: Colors.white70),
              ),
            ),
          ],
        )),
        _gridCell("+ SLOT", color: Colors.green.shade700, isHeader: true, onTap: _addNewSlot),
      ],
    );
  }

  Widget _buildDayRow(String day) {
    List<Widget> slotWidgets = [];
    slotWidgets.add(_gridCell(day, color: const Color(0xFF76C44B), isHeader: true, onLongPress: () => _removeDay(day)));

    int skipUntil = -1;
    for (int i = 0; i < _timetableSlots.length; i++) {
       if (i <= skipUntil) continue;
       
       final slotName = _timetableSlots[i];
       if (slotName == 'BREAK') {
          slotWidgets.add(_gridCell("BREAK", color: const Color(0xFF76C44B), isBreak: true));
          continue;
       }

       final scheduleSlot = _getSlot(day, slotName);
       final int span = scheduleSlot != null ? (scheduleSlot['span'] ?? 1) : 1;
       
       slotWidgets.add(_gridCell(
         scheduleSlot != null ? scheduleSlot['subject'] : null,
         faculty: scheduleSlot?['facultyName'],
         span: span,
         onTap: () => _showManageSlotDialog(day, slotName),
         isScheduled: scheduleSlot != null,
       ));

       if (span > 1) {
         skipUntil = i + span - 1;
       }
    }
    
    return Row(children: slotWidgets);
  }

  Widget _buildAddDayRow() {
    return InkWell(
      onTap: _addNewDay,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: 130.0 + (_timetableSlots.length * 130) + 130, // Rough calculation for headers
        color: Colors.grey.shade50,
        child: const Center(child: Text("+ ADD NEW DAY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
      ),
    );
  }

  Widget _buildCommitSaveButton() {
     return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveTimetable,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3E5F), foregroundColor: Colors.white, padding: const EdgeInsets.all(22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("COMMIT CHANGES & PERSIST TO DB", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5)),
            ),
          ),
        );
  }

  Widget _gridCell(String? text, {Color? color, bool isHeader = false, bool isBreak = false, int span = 1, VoidCallback? onTap, VoidCallback? onLongPress, String? faculty, bool isScheduled = false}) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 130.0 * span,
        height: 100,
        decoration: BoxDecoration(
          color: color ?? (isScheduled ? Colors.white : Colors.transparent),
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        alignment: Alignment.center,
        child: isHeader || isBreak 
          ? (isBreak ? const RotatedBox(quarterTurns: 1, child: Text("BREAK", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22))) : Text(text ?? "", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13), textAlign: TextAlign.center))
          :Stack(
            children: [
              if (isScheduled) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(text?.toUpperCase() ?? "", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF1B3E5F)), textAlign: TextAlign.center, maxLines: 2),
                      const SizedBox(height: 4),
                      Text(faculty ?? "", style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 1),
                      if (span > 1) Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: _badge("MERGED ($span slots)", Colors.orange),
                      ),
                    ],
                  ),
                ),
                Positioned(top: 4, right: 4, child: Icon(Icons.edit_note_rounded, size: 14, color: Colors.grey.shade400)),
              ] else Icon(Icons.add_rounded, size: 20, color: Colors.grey.withOpacity(0.3)),
            ],
          ),
      ),
    );
  }

  void _addNewDay() {
    _beautifulTextFieldDialog(
      title: "Add New Day", 
      label: "Day Name (e.g. SATURDAY)", 
      icon: Icons.calendar_month,
      onConfirm: (val) => setState(() => _timetableDays.add(val.toUpperCase())),
    );
  }

  void _addNewSlot() {
    _beautifulTextFieldDialog(
      title: "Add Time Slot", 
      label: "Slot Name (e.g. 9th or LUNCH)", 
      icon: Icons.timer,
      onConfirm: (val) => setState(() => _timetableSlots.add(val)),
    );
  }

  void _removeDay(String day) {
    setState(() => _timetableDays.remove(day));
  }

  void _beautifulTextFieldDialog({required String title, required String label, required IconData icon, required Function(String) onConfirm}) {
    final controller = TextEditingController();
    _showBeautifulDialog(
      title: title, 
      content: _beautifulTextField(controller: controller, label: label, icon: icon),
      onConfirm: () => onConfirm(controller.text),
    );
  }

  Widget _tableHeader(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }

  Widget _beautifulTextField({TextEditingController? controller, required String label, required IconData icon, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.black54, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12, width: 1)),
      ),
    );
  }

  void _showBeautifulDialog({required String title, required Widget content, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
              const SizedBox(height: 24),
              content,
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () { onConfirm(); Navigator.pop(context); },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Map<String, dynamic>? _getSlot(String day, String time) {
    if (_timetable == null || _timetable!['schedule'] == null) return null;
    final scheduleList = (_timetable!['schedule'] as List<dynamic>);
    final daySched = scheduleList.firstWhere((s) => (s as Map)['day'] == day, orElse: () => null);
    if (daySched == null) return null;
    final slotsList = (daySched['slots'] as List<dynamic>);
    final slot = slotsList.firstWhere((s) => (s as Map)['startTime'] == time, orElse: () => null);
    if (slot == null) return null;
    
    // Find faculty name for display
    String facultyName = "No Faculty";
    if (slot['facultyUserId'] != null) {
      if (slot['facultyUserId'] is Map) {
        facultyName = "${slot['facultyUserId']['firstName'] ?? ''} ${slot['facultyUserId']['lastName'] ?? ''}";
      } else {
        final fac = _faculty.firstWhere((f) => (f as Map)['userId']['_id'] == slot['facultyUserId'], orElse: () => null);
        if (fac != null) facultyName = "${fac['userId']['firstName']} ${fac['userId']['lastName']}";
      }
    }
    
    return {
      'subject': slot['subject'],
      'facultyName': facultyName,
      'span': slot['span'] ?? 1,
    };
  }

  Widget _semesterDropdown() {
    final curriculum = (_courseData['curriculum'] as List? ?? []);
    if (curriculum.isEmpty) return const SizedBox();
    
    return DropdownButton<int>(
      value: _activeSemester,
      onChanged: (val) {
        if (val != null) {
          setState(() => _activeSemester = val);
          _loadAllData();
        }
      },
      items: curriculum.map<DropdownMenuItem<int>>((sem) {
        return DropdownMenuItem<int>(
          value: sem['semester'],
          child: Text("Semester ${sem['semester']}"),
        );
      }).toList(),
    );
  }

  void _showManageSlotDialog(String day, String time) {
    final curriculum = (_courseData['curriculum'] as List? ?? []);
    final currentSem = curriculum.firstWhere((s) => (s as Map)['semester'] == _activeSemester, orElse: () => null);
    final scheduleSlot = _getSlot(day, time);
    final subjects = (currentSem?['subjects'] as List? ?? []);
    
    String? selectedSubject;
    String? selectedFaculty;
    String customPeriodName = "";
    int selectedSpan = scheduleSlot != null ? (scheduleSlot['span'] ?? 1) : 1;
    bool isCustomMode = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => DefaultTabController(
          length: 2,
          child: AlertDialog(
            title: Text("Manage Session: $day $time"),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    onTap: (index) => setDialogState(() => isCustomMode = index == 1),
                    tabs: const [Tab(text: "Subjects"), Tab(text: "Custom Period")],
                  ),
                  const SizedBox(height: 16),
                  if (!isCustomMode)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Select Subject"),
                      value: scheduleSlot != null ? scheduleSlot['subject'] : null,
                      items: subjects.map<DropdownMenuItem<String>>((s) => DropdownMenuItem(value: s['name'], child: Text(s['name']))).toList(),
                      onChanged: (v) => setDialogState(() => selectedSubject = v),
                    )
                  else
                    _beautifulTextField(
                      label: "Period Name (e.g. LUNCH, PROJECT)", 
                      icon: Icons.edit,
                      onChanged: (v) => setDialogState(() => customPeriodName = v),
                    ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Select Faculty"),
                    items: _faculty.map<DropdownMenuItem<String>>((f) {
                      final name = "${f['userId']['firstName']} ${f['userId']['lastName']}";
                      return DropdownMenuItem(value: f['userId']['_id'], child: Text(name));
                    }).toList(),
                    onChanged: (v) => setDialogState(() => selectedFaculty = v),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text("Span: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Slider(
                          value: selectedSpan.toDouble(),
                          min: 1, max: 4, divisions: 3,
                          onChanged: (v) => setDialogState(() => selectedSpan = v.toInt()),
                        ),
                      ),
                      Text("$selectedSpan slots"),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              if (scheduleSlot != null)
                TextButton(
                  onPressed: () async { 
                    await _clearSlot(day, time); 
                    Navigator.pop(context); 
                  }, 
                  child: const Text("Remove Content", style: TextStyle(color: Colors.red))
                ),
              ElevatedButton(
                onPressed: () async {
                  final finalSubject = isCustomMode ? customPeriodName : (selectedSubject ?? (scheduleSlot != null ? scheduleSlot['subject'] : ""));
                  if (finalSubject.isNotEmpty && selectedFaculty != null) {
                     await _updateLocalSlot(day, time, finalSubject, selectedFaculty!, selectedSpan);
                     Navigator.pop(context);
                  }
                },
                child: const Text("Confirm"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateLocalSlot(String day, String time, String subject, String facultyId, [int span = 1]) async {
    setState(() {
      _timetable ??= {'schedule': []};
      final schedule = List<Map<String, dynamic>>.from(_timetable!['schedule'] ?? []);
      int dayIndex = schedule.indexWhere((s) => (s as Map)['day'] == day);
      if (dayIndex == -1) {
        schedule.add({'day': day, 'slots': []});
        dayIndex = schedule.length - 1;
      }
      
      final slots = List<Map<String, dynamic>>.from(schedule[dayIndex]['slots'] ?? []);
      final slotIndex = slots.indexWhere((s) => (s as Map)['startTime'] == time);
      final newSlot = {'subject': subject, 'facultyUserId': facultyId, 'startTime': time, 'endTime': '', 'span': span};
      
      if (slotIndex == -1) {
        slots.add(newSlot);
      } else {
        slots[slotIndex] = newSlot;
      }
      
      schedule[dayIndex]['slots'] = slots;
      _timetable!['schedule'] = schedule;
    });
    
    await _saveTimetable(silent: true);
  }

  Future<void> _clearSlot(String day, String time) async {
    if (_timetable == null) return;
    setState(() {
      final schedule = List<Map<String, dynamic>>.from(_timetable!['schedule'] ?? []);
      final dayIndex = schedule.indexWhere((s) => (s as Map)['day'] == day);
      if (dayIndex != -1) {
        final slots = List<Map<String, dynamic>>.from(schedule[dayIndex]['slots'] ?? []);
        slots.removeWhere((s) => (s as Map)['startTime'] == time);
        schedule[dayIndex]['slots'] = slots;
        _timetable!['schedule'] = schedule;
      }
    });
    
    await _saveTimetable(silent: true);
  }

  Future<void> _saveTimetable({bool silent = false}) async {
    try {
      await TimetableService.saveTimetable({
        'courseId': widget.course['_id'],
        'branchId': widget.branch['_id'],
        'semester': _activeSemester,
        'schedule': _timetable!['schedule'],
        'days': _timetableDays,
        'slots': _timetableSlots,
      });
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Timetable updated successfully!")));
      }
      _loadAllData(showLoading: !silent);
    } catch (e) {
      if (!silent) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
