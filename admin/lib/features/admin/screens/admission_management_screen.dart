import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import 'create_application_screen.dart';
import 'application_detail_screen.dart';

class AdmissionManagementScreen extends StatefulWidget {
  const AdmissionManagementScreen({super.key});

  @override
  State<AdmissionManagementScreen> createState() =>
      _AdmissionManagementScreenState();
}

class _AdmissionManagementScreenState extends State<AdmissionManagementScreen> {
  String _activeFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Approved', 'Rejected'];

  final List<Map<String, dynamic>> _applications = [
    {
      "name": "Rahul Sharma",
      "course": "B.Tech CSE",
      "score": "92.4%",
      "date": "Aug 15",
      "status": "Pending",
      "city": "Mumbai",
      "avatar": "https://i.pravatar.cc/150?img=14",
    },
    {
      "name": "Priya Patel",
      "course": "MBA Finance",
      "score": "88.1%",
      "date": "Aug 16",
      "status": "Approved",
      "city": "Ahmedabad",
      "avatar": "https://i.pravatar.cc/150?img=47",
    },
    {
      "name": "Arjun Singh",
      "course": "B.Sc Data Science",
      "score": "79.5%",
      "date": "Aug 16",
      "status": "Rejected",
      "city": "Delhi",
      "avatar": "https://i.pravatar.cc/150?img=33",
    },
    {
      "name": "Divya Nair",
      "course": "B.Tech Mech",
      "score": "96.2%",
      "date": "Aug 17",
      "status": "Approved",
      "city": "Kochi",
      "avatar": "https://i.pravatar.cc/150?img=48",
    },
    {
      "name": "Karan Mehta",
      "course": "B.Tech ECE",
      "score": "83.7%",
      "date": "Aug 18",
      "status": "Pending",
      "city": "Pune",
      "avatar": "https://i.pravatar.cc/150?img=12",
    },
    {
      "name": "Sneha Rao",
      "course": "MBA HR",
      "score": "91.0%",
      "date": "Aug 19",
      "status": "Approved",
      "city": "Bangalore",
      "avatar": "https://i.pravatar.cc/150?img=45",
    },
    {
      "name": "Amit Gupta",
      "course": "B.Com Hons",
      "score": "74.2%",
      "date": "Aug 20",
      "status": "Rejected",
      "city": "Jaipur",
      "avatar": "https://i.pravatar.cc/150?img=32",
    },
    {
      "name": "Meena Krishnan",
      "course": "B.Sc Physics",
      "score": "89.5%",
      "date": "Aug 21",
      "status": "Pending",
      "city": "Chennai",
      "avatar": "https://i.pravatar.cc/150?img=49",
    },
    {
      "name": "Rohan Verma",
      "course": "MBA General",
      "score": "85.0%",
      "date": "Aug 22",
      "status": "Approved",
      "city": "Lucknow",
      "avatar": "https://i.pravatar.cc/150?img=21",
    },
    {
      "name": "Nisha Joshi",
      "course": "B.Sc Hons",
      "score": "77.3%",
      "date": "Aug 23",
      "status": "Pending",
      "city": "Indore",
      "avatar": "https://i.pravatar.cc/150?img=56",
    },
    {
      "name": "Vikram Das",
      "course": "B.Tech CSE",
      "score": "94.1%",
      "date": "Aug 24",
      "status": "Approved",
      "city": "Hyderabad",
      "avatar": "https://i.pravatar.cc/150?img=53",
    },
    {
      "name": "Anjali Menon",
      "course": "MBA Finance",
      "score": "90.8%",
      "date": "Aug 25",
      "status": "Pending",
      "city": "Kolkata",
      "avatar": "https://i.pravatar.cc/150?img=44",
    },
  ];

  final List<Map<String, dynamic>> _programs = [
    {
      "name": "Computer Science",
      "fill": 0.85,
      "total": 120,
      "filled": 102,
      "color": const Color(0xFF4F46E5),
    },
    {
      "name": "Mechanical Eng.",
      "fill": 0.65,
      "total": 80,
      "filled": 52,
      "color": const Color(0xFFEA580C),
    },
    {
      "name": "MBA General",
      "fill": 0.95,
      "total": 60,
      "filled": 57,
      "color": const Color(0xFF7C3AED),
    },
    {
      "name": "B.Sc Honours",
      "fill": 0.55,
      "total": 100,
      "filled": 55,
      "color": const Color(0xFF0D9488),
    },
    {
      "name": "B.Tech ECE",
      "fill": 0.72,
      "total": 90,
      "filled": 65,
      "color": const Color(0xFFDB2777),
    },
    {
      "name": "MBA Finance",
      "fill": 0.90,
      "total": 50,
      "filled": 45,
      "color": const Color(0xFF059669),
    },
  ];

  List<Map<String, dynamic>> get _filtered => _activeFilter == 'All'
      ? _applications
      : _applications.where((a) => a['status'] == _activeFilter).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F6F6),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKPICards(),
                  const SizedBox(height: 36),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _buildProgramAllocation()),
                      const SizedBox(width: 28),
                      Expanded(flex: 3, child: _buildAdmissionFunnel()),
                    ],
                  ),
                  const SizedBox(height: 36),
                  _buildApplicationsCardSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────── HEADER ───────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
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
                "Enrollment & Admissions",
                style: AppTheme.titleStyle.copyWith(fontSize: 26),
              ),
              Text(
                "Academic Year 2023–24 • Intake open",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
          Row(
            children: [
              _headerBtn(
                Icons.file_download_rounded,
                "Export Report",
                const Color(0xFF4F46E5),
              ),
              const SizedBox(width: 14),
              _gradientBtn(context, Icons.post_add_rounded, "New Application"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerBtn(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.08),
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      icon: Icon(icon, color: color, size: 18),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _gradientBtn(BuildContext context, IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(
          context,
          _slideRoute(const CreateApplicationScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ─────────── KPI CARDS ───────────
  Widget _buildKPICards() {
    final cards = [
      {
        "label": "Total Applications",
        "value": "2,847",
        "sub": "+18% this month",
        "icon": Icons.inbox_rounded,
        "colors": [const Color(0xFF880E4F), const Color(0xFFEC1349)],
      },
      {
        "label": "Pending Review",
        "value": "154",
        "sub": "Needs attention",
        "icon": Icons.pending_actions_rounded,
        "colors": [const Color(0xFFB45309), const Color(0xFFF59E0B)],
      },
      {
        "label": "Approved",
        "value": "1,940",
        "sub": "Offer letters sent",
        "icon": Icons.check_circle_rounded,
        "colors": [const Color(0xFF065F46), const Color(0xFF10B981)],
      },
      {
        "label": "Seats Filled",
        "value": "1,200",
        "sub": "of 1,500 total",
        "icon": Icons.event_seat_rounded,
        "colors": [const Color(0xFF312E81), const Color(0xFF6366F1)],
      },
    ];
    return Row(
      children: List.generate(cards.length, (i) {
        final c = cards[i];
        final colors = c['colors'] as List<Color>;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < cards.length - 1 ? 20 : 0),
            child: _kpiCard(
              c['label'] as String,
              c['value'] as String,
              c['sub'] as String,
              c['icon'] as IconData,
              colors,
              i,
            ),
          ),
        );
      }),
    );
  }

  Widget _kpiCard(
    String label,
    String value,
    String sub,
    IconData icon,
    List<Color> colors,
    int index,
  ) {
    return _HoverCard(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colors.last.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -16,
              bottom: -16,
              child: Icon(
                icon,
                size: 80,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(height: 20),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 80).ms).fadeIn().slideY(begin: 0.2);
  }

  // ─────────── PROGRAM ALLOCATION ───────────
  Widget _buildProgramAllocation() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: _panelDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Program-wise Seat Allocation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _liveBadge(),
            ],
          ),
          const SizedBox(height: 28),
          ...List.generate(_programs.length, (i) {
            final p = _programs[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _programBar(
                p['name'],
                p['fill'],
                p['total'],
                p['filled'],
                p['color'],
                i,
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1);
  }

  Widget _liveBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFF0FDF4),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Row(
      children: [
        Icon(Icons.circle, color: Colors.green, size: 8),
        SizedBox(width: 6),
        Text(
          "Live",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    ),
  );

  Widget _programBar(
    String name,
    double fill,
    int total,
    int filled,
    Color color,
    int index,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$filled",
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: " / $total",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fill,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.65)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "${(fill * 100).toInt()}% filled",
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ─────────── FUNNEL ───────────
  Widget _buildAdmissionFunnel() {
    final steps = [
      {"label": "Applied", "value": 2847, "color": const Color(0xFF6366F1)},
      {"label": "Shortlisted", "value": 1980, "color": const Color(0xFFEC1349)},
      {"label": "Verified", "value": 1420, "color": const Color(0xFFF59E0B)},
      {"label": "Admitted", "value": 1200, "color": const Color(0xFF10B981)},
    ];
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: _panelDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Admission Pipeline",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Funnel overview • AY 2023-24",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 28),
          ...List.generate(steps.length, (i) {
            final s = steps[i];
            final pct = (s['value'] as int) / 2847;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s['label'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        (s['value'] as int).toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: s['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: pct,
                        child: Container(
                          height: 34,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (s['color'] as Color).withValues(alpha: 0.85),
                                (s['color'] as Color).withValues(alpha: 0.4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                      .animate(delay: (i * 120).ms)
                      .scaleX(
                        alignment: Alignment.centerLeft,
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryRed.withValues(alpha: 0.06),
                  AppColors.primaryPink.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primaryRed.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.primaryRed,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Conversion Rate",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "42.1%  ",
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const TextSpan(
                            text: "Applied → Admitted",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
  }

  // ─────────── APPLICATION CARDS ───────────
  Widget _buildApplicationsCardSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Applications",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${_filtered.length} applicants found",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
            Row(
              children: [
                // Filter tabs
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: _filters.map((t) {
                      final sel = _activeFilter == t;
                      return GestureDetector(
                        onTap: () => setState(() => _activeFilter = t),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primaryRed
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: sel
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryRed.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontWeight: sel
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 13,
                              color: sel ? Colors.white : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                // Generate merit list
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryRed.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.primaryRed,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Generate Merit List",
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // CARD GRID
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.72,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: _filtered.length,
          itemBuilder: (_, i) => _applicationCard(_filtered[i], i),
        ),
      ],
    );
  }

  Widget _applicationCard(Map<String, dynamic> app, int index) {
    final status = app['status'] as String;
    final statusColor = status == 'Approved'
        ? Colors.green
        : status == 'Rejected'
        ? Colors.red
        : Colors.orange;
    final statusGrad = status == 'Approved'
        ? [const Color(0xFF065F46), const Color(0xFF10B981)]
        : status == 'Rejected'
        ? [const Color(0xFF7F1D1D), const Color(0xFFEF4444)]
        : [const Color(0xFF78350F), const Color(0xFFF59E0B)];

    return _HoverCard(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Gradient top banner ──
            Container(
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: statusGrad
                      .map((c) => c.withValues(alpha: 0.85))
                      .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      app['score'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Avatar (overlapping the banner) ──
            Transform.translate(
              offset: const Offset(0, -28),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(app['avatar']),
                ),
              ),
            ),

            // ── Info ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Text(
                      app['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        app['course'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryRed,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // City + Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          app['city'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          app['date'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Score bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Merit",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Text(
                              app['score'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value:
                                double.parse(app['score'].replaceAll('%', '')) /
                                100,
                            color: statusColor,
                            backgroundColor: statusColor.withValues(alpha: 0.1),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: _cardActionBtn(
                            Icons.visibility_rounded,
                            Colors.blue,
                            () => Navigator.push(
                              context,
                              _slideRoute(
                                ApplicationDetailScreen(application: app),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (status == 'Pending') ...[
                          Expanded(
                            child: _cardActionBtn(
                              Icons.check_rounded,
                              Colors.green,
                              () {},
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _cardActionBtn(
                              Icons.close_rounded,
                              Colors.red,
                              () {},
                            ),
                          ),
                        ] else
                          Expanded(
                            child: _cardActionBtn(
                              Icons.edit_note_rounded,
                              Colors.orange,
                              () {},
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 55).ms).fadeIn().slideY(begin: 0.15);
  }

  Widget _cardActionBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 17),
      ),
    );
  }

  BoxDecoration _panelDecor() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  Route _slideRoute(Widget page) => PageRouteBuilder(
    pageBuilder: (_, a, __) => page,
    transitionsBuilder: (_, a, __, child) => SlideTransition(
      position: a.drive(
        Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
      ),
      child: child,
    ),
  );
}

// ── Hover lift ──
class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.035 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
