import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                          _badge(widget.course['type'], Colors.blue),
                          const SizedBox(width: 8),
                          _badge(widget.course['status'], Colors.green),
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
                  "${widget.course['students']}/120",
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
                  value: widget.course['students'] / 120,
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
                    _badge(widget.course['type'], Colors.blue),
                    const SizedBox(width: 12),
                    _badge(widget.course['status'], Colors.green),
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
                  "Credits Requirement: ${widget.course['credits']} • Professional Certification Track Included",
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
                "Enrolled Intake",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.course['students']}/120",
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
                    value: widget.course['students'] / 120,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation(Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ],
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
        _statBox("12", "Faculty Nodes", Icons.people_outline_rounded),
        const SizedBox(width: 24),
        _statBox("8", "Semesters", Icons.calendar_today_rounded),
        const SizedBox(width: 24),
        _statBox("24", "Lab Units", Icons.biotech_rounded),
        const SizedBox(width: 24),
        _statBox("94%", "Placement Rate", Icons.trending_up_rounded),
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
          Tab(text: "Resource Inventory"),
        ],
      ),
    );
  }

  Widget _buildCurriculumTab(bool isMobile) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 24),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) => Container(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          border: Border.all(color: Colors.black.withOpacity(0.02)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFF8F6F6),
              radius: isMobile ? 16 : 20,
              child: Text(
                "${i + 1}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 13 : 16,
                ),
              ),
            ),
            SizedBox(width: isMobile ? 16 : 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Semester ${i + 1}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isMobile
                        ? "Core subjects and practical labs."
                        : "Core subjects, practical labs and elective projects focused for this semester.",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: isMobile ? 11 : 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!isMobile) ...[
              _badge("24 Credits", Colors.orange),
              const SizedBox(width: 24),
            ],
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsTab() =>
      const Center(child: Text("Student Management System coming soon."));
  Widget _buildFacultyTab() =>
      const Center(child: Text("Faculty Assignment System coming soon."));
  Widget _buildResourcesTab() =>
      const Center(child: Text("Resource Management coming soon."));
}
