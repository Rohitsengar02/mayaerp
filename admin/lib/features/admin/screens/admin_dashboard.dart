import 'package:flutter/material.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

// --- Reusable Hover Widget for Interactive Elements ---
class HoverScaleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final EdgeInsetsGeometry? padding;

  const HoverScaleCard({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 1.03,
    this.padding,
  });

  @override
  State<HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<HoverScaleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.scale : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// --- Main Dashboard Screen ---
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 1100;
        double sidePadding = isMobile ? 16 : 32;

        return Container(
          color: const Color(0xFFF8F6F6), // background-light from HTML
          child: Column(
            children: [
              // 1. TOPBAR (Hidden on mobile as we have mobile navbar)
              if (!isMobile) _buildTopbar(),

              // 2. SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(sidePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroBanner(isMobile),
                      const SizedBox(height: 32),
                      _buildKPIRow(isMobile),
                      const SizedBox(height: 32),

                      // MAIN DASHBOARD GRID (Conditional for Mobile)
                      if (isMobile) ...[
                        _buildAttendance(),
                        const SizedBox(height: 24),
                        _buildPerformance(),
                        const SizedBox(height: 24),
                        _buildFinance(),
                        const SizedBox(height: 24),
                        _buildQuickActions(),
                        const SizedBox(height: 24),
                        _buildCriticalAlerts(),
                        const SizedBox(height: 24),
                        _buildInstantReports(),
                      ] else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left 2 columns
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: _buildAttendance()),
                                      const SizedBox(width: 24),
                                      Expanded(child: _buildPerformance()),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _buildFinance(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),

                            // Right 1 column
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _buildQuickActions(),
                                  const SizedBox(height: 24),
                                  _buildCriticalAlerts(),
                                  const SizedBox(height: 24),
                                  _buildInstantReports(),
                                ],
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 32),
                      _buildDepartmentsGrid(isMobile),
                      const SizedBox(height: 32),

                      // BOTTOM ROW
                      if (isMobile) ...[
                        _buildRecentActivity(),
                        const SizedBox(height: 24),
                        _buildSystemHealth(),
                      ] else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildRecentActivity()),
                            const SizedBox(width: 32),
                            Expanded(child: _buildSystemHealth()),
                          ],
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

  // --- TOPBAR ---
  Widget _buildTopbar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryRed.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Search
          Expanded(
            child: Container(
              height: 44,
              constraints: const BoxConstraints(maxWidth: 450),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), // slate-100
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search student records, faculty or fees...",
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Controls
          Row(
            children: [
              // Academic Year
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "AY 2023-24",
                      style: AppTheme.bodyStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Notifications
              _topbarIcon(Icons.notifications_outlined, hasBadge: true),
              const SizedBox(width: 12),

              // Settings
              _topbarIcon(Icons.settings_outlined),
              const SizedBox(width: 16),

              // Divider
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              const SizedBox(width: 16),

              // Profile Action
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Admin User",
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Super Administrator",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryRed.withOpacity(0.2),
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage("https://i.pravatar.cc/150?img=11"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topbarIcon(IconData icon, {bool hasBadge = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: Colors.grey.shade700, size: 20),
          if (hasBadge)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- HERO BANNER ---
  Widget _buildHeroBanner(bool isMobile) {
    return HoverScaleCard(
      scale: 1.01,
      child: Container(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        constraints: BoxConstraints(minHeight: isMobile ? 180 : 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF880E4F), Color(0xFFEC1349), Color(0xFFFF4081)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative Icon
            Positioned(
              right: -20,
              bottom: -40,
              child: Icon(
                Icons.school,
                size: isMobile ? 120 : 200,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome back,\nAdministrator",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Maya Institute",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome back, Administrator",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Managing Maya Institute of Technology & Sciences",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      // Date Widget
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.amberAccent,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Monday, 24 October 2023",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "System Time: 09:41 AM",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 32),
                // Bottom Tags
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Online",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Text(
                        "v4.2.0-LTS",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1);
  }

  // --- KPI STATS ---
  Widget _buildKPIRow(bool isMobile) {
    final kpiCards = [
      _buildKPICard(
        "Total Students",
        "1,240",
        "+12%",
        const Color(0xFF4F46E5),
        "https://images.unsplash.com/photo-1523050853063-bd8012fec0c8?w=400&q=80",
        isMobile: isMobile,
      ),
      _buildKPICard(
        "Total Staff",
        "86",
        "+2%",
        const Color(0xFF059669),
        "https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400&q=80",
        isMobile: isMobile,
      ),
      _buildKPICard(
        "Total Courses",
        "42",
        "Stable",
        const Color(0xFF7C3AED),
        "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&q=80",
        isStable: true,
        isMobile: isMobile,
      ),
      _buildKPICard(
        "Total Revenue",
        "\$452K",
        "+8%",
        const Color(0xFFE11D48),
        "https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&q=80",
        isMobile: isMobile,
      ),
    ];

    if (isMobile) {
      return SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: kpiCards.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: kpiCards[index],
          ),
        ),
      );
    }

    return Row(
      children: kpiCards
          .map(
            (card) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: card,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    String badge,
    Color color,
    String imageUrl, {
    bool isStable = false,
    bool isMobile = false,
  }) {
    return HoverScaleCard(
      child: Container(
        height: isMobile ? 160 : 190,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.3),
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.9),
                    color.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isStable
                              ? Colors.white.withOpacity(0.2)
                              : Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: isStable ? Colors.white : Colors.greenAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ATTENDANCE OVERVIEW ---
  Widget _buildAttendance() {
    return HoverScaleCard(
      scale: 1.02,
      child: _buildPanelBase(
        title: "Attendance Overview",
        actionIcon: Icons.more_vert,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: 0.85,
                    strokeWidth: 14,
                    color: AppColors.primaryRed,
                    backgroundColor: AppColors.primaryRed.withValues(
                      alpha: 0.1,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ).animate().scale(curve: Curves.easeOutBack, duration: 800.ms),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "85%",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "AVERAGE",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryRed.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "PRESENT",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "1,054",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ABSENT",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "186",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- PERFORMANCE TREND ---
  Widget _buildPerformance() {
    return HoverScaleCard(
      scale: 1.02,
      child: _buildPanelBase(
        title: "Performance Trend",
        actionWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "B.Tech CSE",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 16),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, m) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            [
                              'UNIT 1',
                              'UNIT 2',
                              'MID-TERM',
                              'UNIT 3',
                            ][v.toInt() % 4],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 30),
                        FlSpot(1, 45),
                        FlSpot(2, 40),
                        FlSpot(3, 70),
                      ],
                      isCurved: true,
                      color: const Color(0xFF8B5CF6), // Violet 500
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF8B5CF6).withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Color(0xFF8B5CF6),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overall Score Improvement",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "+14.2% from Semester 1",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- FINANCE & FEES ---
  Widget _buildFinance() {
    return HoverScaleCard(
      scale: 1.01,
      child: _buildPanelBase(
        title: "Fee Collection Strategy",
        actionWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "COLLECTED",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "PENDING",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 24),
            _feeProgressBar("Tuition Fees", 0.82),
            const SizedBox(height: 16),
            _feeProgressBar("Hostel & Mess", 0.65),
            const SizedBox(height: 16),
            _feeProgressBar("Transport", 0.94),
            const SizedBox(height: 32),

            // Alert Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.2),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.payments,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Due Payments Alert",
                            style: TextStyle(
                              color: Color(0xFF065F46),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "42 students have pending balances above \$1,000.",
                            style: TextStyle(
                              color: const Color(0xFF065F46).withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Send Reminders",
                      style: TextStyle(
                        color: Color(0xFF065F46),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _feeProgressBar(String label, double fill) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Text(
              "${(fill * 100).toInt()}%",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: fill,
          backgroundColor: const Color(0xFFF1F5F9),
          color: const Color(0xFF10B981),
          minHeight: 12,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }

  // --- QUICK ACTIONS ---
  Widget _buildQuickActions() {
    return HoverScaleCard(
      scale: 1.01,
      child: _buildPanelBase(
        title: "Quick Actions",
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    "Add Student",
                    Icons.person_add,
                    const Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    "Add Staff",
                    Icons.badge,
                    const Color(0xFF059669),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    "Create Course",
                    Icons.library_add,
                    const Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    "Fees Config",
                    Icons.settings_suggest,
                    const Color(0xFFD97706),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            HoverScaleCard(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.2),
                  border: Border.all(
                    color: AppColors.primaryRed.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.campaign, color: AppColors.primaryRed, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      "Publish Semester Results",
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String title, IconData icon, Color color) {
    return HoverScaleCard(
      scale: 1.05,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          border: Border.all(color: color.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                decorationThickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CRITICAL ALERTS ---
  Widget _buildCriticalAlerts() {
    return HoverScaleCard(
      scale: 1.01,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Critical Alerts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  "2 New",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _alertItem(
            Icons.warning_amber_rounded,
            "Attendance Shortage",
            "12 students in Semester 3 are below 75% attendance threshold.",
            Colors.amber,
          ),
          const SizedBox(height: 12),
          _alertItem(
            Icons.error_outline_rounded,
            "Fee Overdue",
            "Hostel fee payment deadline passed for Block B (15 students).",
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _alertItem(
    IconData icon,
    String title,
    String subtitle,
    MaterialColor color,
  ) {
    return HoverScaleCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.shade50,
          border: Border(left: BorderSide(color: color.shade500, width: 4)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color.shade600, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      color: color.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: color.shade700, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- INSTANT REPORTS ---
  Widget _buildInstantReports() {
    return HoverScaleCard(
      scale: 1.01,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // slate-900
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.1),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.save_as,
                size: 100,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Instant Reports",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _reportItem(
                  Icons.analytics,
                  "MIS Executive Summary",
                  Colors.lightBlueAccent,
                ),
                const SizedBox(height: 12),
                _reportItem(
                  Icons.request_quote,
                  "Finance Audit FY23",
                  Colors.greenAccent,
                ),
                const SizedBox(height: 12),
                _reportItem(
                  Icons.person_search,
                  "Monthly Attendance",
                  AppColors.primaryRed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportItem(IconData icon, String title, Color color) {
    return HoverScaleCard(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.download, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  // --- DEPARTMENTS GRID ---
  Widget _buildDepartmentsGrid(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Institute Departments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: isMobile ? 3 : 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _deptItem(
              Icons.meeting_room,
              "Admissions",
              const Color(0xFFE0F2FE),
              const Color(0xFF7DD3FC),
              const Color(0xFF0284C7),
              const Color(0xFF0C4A6E),
            ),
            _deptItem(
              Icons.fingerprint,
              "Attendance",
              const Color(0xFFCCFBF1),
              const Color(0xFF5EEAD4),
              const Color(0xFF0D9488),
              const Color(0xFF134E4A),
            ),
            _deptItem(
              Icons.history_edu,
              "Exams",
              const Color(0xFFEDE9FE),
              const Color(0xFFC4B5FD),
              const Color(0xFF7C3AED),
              const Color(0xFF2E1065),
            ),
            _deptItem(
              Icons.local_library,
              "Library",
              const Color(0xFFFFF7ED),
              const Color(0xFFFDBA74),
              const Color(0xFFEA580C),
              const Color(0xFF431407),
            ),
            _deptItem(
              Icons.engineering,
              "HR Portal",
              const Color(0xFFFCE7F3),
              const Color(0xFFF9A8D4),
              const Color(0xFFDB2777),
              const Color(0xFF500724),
            ),
            _deptItem(
              Icons.calculate,
              "Accounts",
              const Color(0xFFE0E7FF),
              const Color(0xFFA5B4FC),
              const Color(0xFF4338CA),
              const Color(0xFF1E1B4B),
            ),
          ],
        ),
      ],
    );
  }

  Widget _deptItem(
    IconData icon,
    String title,
    Color bg,
    Color borderColor,
    Color iconColor,
    Color textColor,
  ) {
    return HoverScaleCard(
      scale: 1.06,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 36),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- RECENT ACTIVITY & SYSTEM OVERVIEW ---
  Widget _buildRecentActivity() {
    return HoverScaleCard(
      scale: 1.01,
      child: _buildPanelBase(
        title: "Recent Activity",
        child: Column(
          children: [
            const SizedBox(height: 24),
            _activityItem(
              iconUrl: "https://i.pravatar.cc/150?img=12",
              text: "Rahul Sharma enrolled in B.Tech CSE",
              time: "10 Minutes Ago",
            ),
            _activityItem(
              iconUrl: "https://i.pravatar.cc/150?img=41",
              text: "Prof. Sarah Jenkins published Applied Physics Marks",
              time: "1 Hour Ago",
            ),
            _activityItem(
              icon: Icons.payments,
              iconBg: Colors.greenAccent.shade100,
              iconColor: Colors.green.shade700,
              text: "Fee Payment received for INV-9022 (\$1,450)",
              time: "3 Hours Ago",
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityItem({
    String? iconUrl,
    IconData? icon,
    Color? iconBg,
    Color? iconColor,
    required String text,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBg ?? Colors.white,
              border: Border.all(color: Colors.white, width: 2),
              image: iconUrl != null
                  ? DecorationImage(
                      image: NetworkImage(iconUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5),
              ],
            ),
            child: icon != null ? Icon(icon, color: iconColor) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  time.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealth() {
    return HoverScaleCard(
      scale: 1.01,
      child: _buildPanelBase(
        title: "System Health & Status",
        child: Column(
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "ACTIVE USERS",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "412",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Live Now",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "SERVER STATUS",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "EXCELLENT",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "99.9%",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Uptime",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
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
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_done,
                        color: AppColors.primaryRed,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Automated Backup",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "Last synced: 24 Oct, 03:00 AM",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "SECURE",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "STORAGE USAGE",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "4.2 TB / 10 TB",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.42,
                  backgroundColor: const Color(0xFFF1F5F9),
                  color: AppColors.primaryRed,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WRAPPER ---
  Widget _buildPanelBase({
    required String title,
    Widget? actionWidget,
    IconData? actionIcon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryRed.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (actionWidget != null)
                actionWidget
              else if (actionIcon != null)
                Icon(actionIcon, color: Colors.grey.shade400),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
