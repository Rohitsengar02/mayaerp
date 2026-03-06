import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import 'branch_detail_screen.dart';
import 'create_branch_screen.dart';

class AcademicManagementScreen extends StatefulWidget {
  const AcademicManagementScreen({super.key});

  @override
  State<AcademicManagementScreen> createState() =>
      _AcademicManagementScreenState();
}

class _AcademicManagementScreenState extends State<AcademicManagementScreen> {
  Map<String, dynamic>? _selectedBranch;

  final List<Map<String, dynamic>> _branches = [
    {
      "name": "School of Computer Science",
      "code": "SCS",
      "dean": "Dr. Rohit Kumar",
      "coursesCount": 12,
      "studentsCount": 420,
      "occupancy": 85,
      "departments": 5,
      "researchHubs": 3,
      "color": Colors.blue,
      "icon": Icons.computer_rounded,
      "gradient": [Color(0xFF2196F3), Color(0xFF00BCD4)],
    },
    {
      "name": "School of Business",
      "code": "SOB",
      "dean": "Dr. Anita Sharma",
      "coursesCount": 8,
      "studentsCount": 280,
      "occupancy": 72,
      "departments": 3,
      "researchHubs": 1,
      "color": Colors.purple,
      "icon": Icons.business_center_rounded,
      "gradient": [Color(0xFF9C27B0), Color(0xFFE91E63)],
    },
    {
      "name": "Mechanical Engineering",
      "code": "SMED",
      "dean": "Dr. Vikas Singh",
      "coursesCount": 6,
      "studentsCount": 150,
      "occupancy": 64,
      "departments": 4,
      "researchHubs": 2,
      "color": Colors.orange,
      "icon": Icons.settings_rounded,
      "gradient": [Color(0xFFFF9800), Color(0xFFFF5722)],
    },
    {
      "name": "Applied Sciences",
      "code": "SAS",
      "dean": "Dr. Priya Patel",
      "coursesCount": 5,
      "studentsCount": 120,
      "occupancy": 58,
      "departments": 2,
      "researchHubs": 4,
      "color": Colors.green,
      "icon": Icons.science_rounded,
      "gradient": [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedBranch != null) {
      return BranchDetailScreen(
        branch: _selectedBranch!,
        onBack: () => setState(() => _selectedBranch = null),
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
                      _buildAcademicOverview(isMobile),
                      SizedBox(height: isMobile ? 32 : 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Institutional Branches",
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.filter_list_rounded,
                              size: 18,
                            ),
                            label: Text(
                              isMobile ? "Filter" : "Filter Branches",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 16 : 32),
                      _buildBranchGrid(isMobile),
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
              "Academic Structure",
              style: AppTheme.titleStyle.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateBranchScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_business_rounded, size: 20),
                label: const Text(
                  "Add New Branch",
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Academic Structure",
                style: AppTheme.titleStyle.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Configure branches, departments, and course curricula",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateBranchScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.add_business_rounded, size: 20),
            label: const Text(
              "Add New Branch",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicOverview(bool isMobile) {
    final items = [
      _overviewCard(
        "Total Branches",
        "08",
        Icons.account_tree_rounded,
        Colors.blue,
        isMobile: isMobile,
      ),
      _overviewCard(
        "Active Courses",
        "42",
        Icons.menu_book_rounded,
        Colors.purple,
        isMobile: isMobile,
      ),
      _overviewCard(
        "Departments",
        "16",
        Icons.hub_rounded,
        Colors.orange,
        isMobile: isMobile,
      ),
      _overviewCard(
        "Faculty Count",
        "124",
        Icons.people_alt_rounded,
        Colors.green,
        isMobile: isMobile,
      ),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: items
              .map(
                (card) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(width: 240, child: card),
                ),
              )
              .toList(),
        ),
      );
    }

    return Row(
      children: items
          .map(
            (card) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: card,
              ),
            ),
          )
          .toList(),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _overviewCard(
    String label,
    String val,
    IconData icon,
    Color color, {
    bool isMobile = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  val,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
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

  Widget _buildBranchGrid(bool isMobile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        mainAxisSpacing: isMobile ? 24 : 32,
        crossAxisSpacing: isMobile ? 24 : 32,
        childAspectRatio: isMobile ? 1.1 : 1.6,
      ),
      itemCount: _branches.length,
      itemBuilder: (context, i) => _branchCard(_branches[i], i, isMobile),
    );
  }

  Widget _branchCard(Map<String, dynamic> branch, int i, bool isMobile) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.black.withOpacity(0.03)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _selectedBranch = branch),
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 24 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: isMobile ? 60 : 90,
                          height: isMobile ? 60 : 90,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: branch['gradient'],
                            ),
                            borderRadius: BorderRadius.circular(
                              isMobile ? 18 : 28,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: branch['color'].withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            branch['icon'],
                            color: Colors.white,
                            size: isMobile ? 28 : 38,
                          ),
                        ),
                        SizedBox(width: isMobile ? 20 : 28),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: branch['color'].withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      branch['code'],
                                      style: TextStyle(
                                        color: branch['color'],
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.more_horiz_rounded,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                branch['name'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline_rounded,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    branch['dean'],
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Divider(height: 1, color: Color(0xFFF1F1F1)),
                    const SizedBox(height: 24),
                    if (isMobile)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _iconStat(
                              Icons.library_books_rounded,
                              "${branch['coursesCount']} Units",
                            ),
                            const SizedBox(width: 20),
                            _iconStat(
                              Icons.groups_rounded,
                              "${branch['studentsCount']} Seats",
                            ),
                            const SizedBox(width: 20),
                            _iconStat(
                              Icons.hub_rounded,
                              "${branch['departments']} Depts",
                            ),
                            const SizedBox(width: 20),
                            _iconStat(
                              Icons.biotech_rounded,
                              "${branch['researchHubs']} Hubs",
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _iconStat(
                            Icons.library_books_rounded,
                            "${branch['coursesCount']} Units",
                          ),
                          _iconStat(
                            Icons.groups_rounded,
                            "${branch['studentsCount']} Seats",
                          ),
                          _iconStat(
                            Icons.hub_rounded,
                            "${branch['departments']} Depts",
                          ),
                          _iconStat(
                            Icons.biotech_rounded,
                            "${branch['researchHubs']} Hubs",
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: branch['occupancy'] / 100,
                        backgroundColor: const Color(0xFFF1F1F1),
                        valueColor: AlwaysStoppedAnimation(branch['color']),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Occupancy Rate",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${branch['occupancy']}% Capacity",
                          style: TextStyle(
                            fontSize: 11,
                            color: branch['color'],
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (i * 100).ms)
        .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _iconStat(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
