import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import 'create_course_screen.dart';
import 'course_detail_screen.dart';

class BranchDetailScreen extends StatefulWidget {
  final Map<String, dynamic> branch;
  final VoidCallback onBack;

  const BranchDetailScreen({
    super.key,
    required this.branch,
    required this.onBack,
  });

  @override
  State<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> {
  Map<String, dynamic>? _selectedCourse;

  final List<Map<String, dynamic>> _courses = [
    {
      "name": "B.Tech Computer Science",
      "code": "BCSE-2024",
      "duration": "4 Years",
      "students": 120,
      "faculty": 12,
      "credits": 160,
      "status": "Active",
      "type": "Full-Time",
      "image": "https://api.dicebear.com/7.x/shapes/svg?seed=BCSE",
    },
    {
      "name": "M.Tech Data Science",
      "code": "MDS-2024",
      "duration": "2 Years",
      "students": 40,
      "faculty": 5,
      "credits": 80,
      "status": "Active",
      "type": "Research",
      "image": "https://api.dicebear.com/7.x/shapes/svg?seed=MDS",
    },
    {
      "name": "Artificial Intelligence",
      "code": "BAI-2024",
      "duration": "4 Years",
      "students": 60,
      "faculty": 8,
      "credits": 162,
      "status": "Pending",
      "type": "Specialization",
      "image": "https://api.dicebear.com/7.x/shapes/svg?seed=BAI",
    },
    {
      "name": "Cyber Security",
      "code": "BCS-2024",
      "duration": "4 Years",
      "students": 45,
      "faculty": 6,
      "credits": 158,
      "status": "Active",
      "type": "Vocational",
      "image": "https://api.dicebear.com/7.x/shapes/svg?seed=BCS",
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedCourse != null) {
      return CourseDetailScreen(
        course: _selectedCourse!,
        branch: widget.branch,
        onBack: () => setState(() => _selectedCourse = null),
      );
    }

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
                      _buildBranchBanner(isMobile),
                      SizedBox(height: isMobile ? 32 : 60),
                      if (isMobile)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Registered Courses",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _searchBar(isMobile),
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Registered Courses",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            _searchBar(isMobile),
                          ],
                        ),
                      const SizedBox(height: 32),
                      _buildCourseGrid(isMobile),
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
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: Colors.black,
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.branch['name'],
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateCourseScreen(branch: widget.branch),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.library_add_rounded, size: 20),
                label: const Text(
                  "Deploy New Course",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
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
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: Colors.black,
            iconSize: 20,
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.branch['name'],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Managing courses and academic schedules for ${widget.branch['code']}",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateCourseScreen(branch: widget.branch),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.library_add_rounded, size: 20),
            label: const Text(
              "Deploy New Course",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchBanner(bool isMobile) {
    if (isMobile) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.branch['color'] ?? Colors.blue,
              widget.branch['color']?.withOpacity(0.7) ??
                  Colors.blue.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.branch['code'] ?? "CODE",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.branch['name'] ?? "Branch Name",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bannerStat(
                  "${widget.branch['studentsCount'] ?? 0}",
                  "Students",
                  isMobile: true,
                ),
                _bannerStat(
                  "${widget.branch['coursesCount'] ?? 0}",
                  "Courses",
                  isMobile: true,
                ),
                _bannerStat(
                  "${widget.branch['occupancy']}%",
                  "Occupancy",
                  isMobile: true,
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.branch['color'] ?? Colors.blue,
            widget.branch['color']?.withOpacity(0.7) ??
                Colors.blue.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: (widget.branch['color'] ?? Colors.blue).withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              widget.branch['icon'] ?? Icons.school,
              size: 240,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.branch['code'] ?? "CODE",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.branch['name'] ?? "Branch Name",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_pin_rounded,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Dean: ${widget.branch['dean'] ?? 'N/A'}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bannerStat(
                      "${widget.branch['studentsCount'] ?? 0}",
                      "Active Students",
                    ),
                    const SizedBox(height: 20),
                    _bannerStat(
                      "${widget.branch['coursesCount'] ?? 0}",
                      "Primary Courses",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98));
  }

  Widget _bannerStat(String val, String label, {bool isMobile = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 20 : 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isMobile ? 10 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _searchBar(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 320,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search courses...",
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, color: Colors.grey, size: 20),
        ),
      ),
    );
  }

  Widget _buildCourseGrid(bool isMobile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 3,
        mainAxisSpacing: isMobile ? 20 : 32,
        crossAxisSpacing: isMobile ? 20 : 32,
        childAspectRatio: isMobile ? 1.0 : 1.2,
      ),
      itemCount: _courses.length,
      itemBuilder: (context, i) => _courseCard(_courses[i], i, isMobile),
    );
  }

  Widget _courseCard(Map<String, dynamic> course, int i, bool isMobile) {
    return InkWell(
      onTap: () => setState(() => _selectedCourse = course),
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.black.withOpacity(0.04)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
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
                    color: const Color(0xFFF8F6F6),
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(course['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          course['code'],
                          style: TextStyle(
                            color: AppColors.primaryRed,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _infoRow(Icons.timer_outlined, course['duration']),
                const Spacer(),
                _statusBadge(course['status']),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Color(0xFFF1F1F1)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _miniDetail(
                  Icons.groups_rounded,
                  "Students",
                  "${course['students']}",
                ),
                _miniDetail(
                  Icons.stars_rounded,
                  "Credits",
                  "${course['credits']}",
                ),
                _miniDetail(
                  Icons.school_rounded,
                  "Faculty",
                  "${course['faculty']}",
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFF8F6F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "View Curriculum",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (i * 100).ms);
  }

  Widget _miniDetail(IconData icon, String label, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    bool active = status == "Active";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (active ? Colors.green : Colors.orange).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: active ? Colors.green : Colors.orange,
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
