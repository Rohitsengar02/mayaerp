import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../admin/widgets/premium_stats_card.dart';
import '../../../widgets/bubble_animation.dart';

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

class LibraryDashboardScreen extends StatefulWidget {
  const LibraryDashboardScreen({super.key});

  @override
  State<LibraryDashboardScreen> createState() => _LibraryDashboardScreenState();
}

class _LibraryDashboardScreenState extends State<LibraryDashboardScreen> {
  bool _showAllActions = false;

  final List<Map<String, dynamic>> _quickActions = [
    {"icon": Icons.add_box_rounded, "label": "Add Books", "color": Color(0xFF4F46E5)},
    {"icon": Icons.outbox_rounded, "label": "Issue Book", "color": Color(0xFF10B981)},
    {"icon": Icons.inbox_rounded, "label": "Return Book", "color": Color(0xFFF59E0B)},
    {"icon": Icons.people_alt_rounded, "label": "Members", "color": Color(0xFF8B5CF6)},
    {"icon": Icons.monetization_on_rounded, "label": "Fines", "color": Color(0xFFF43F5E)},
    {"icon": Icons.receipt_long_rounded, "label": "Transactions", "color": Color(0xFF06B6D4)},
    {"icon": Icons.inventory_2_rounded, "label": "Inventory", "color": Color(0xFF64748B)},
    {"icon": Icons.settings_rounded, "label": "Settings", "color": Color(0xFFEC4899)},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isMobile = width < 850;
        
        return Scaffold(
          backgroundColor: isMobile ? Colors.transparent : const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 8 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPremiumStats(width),
                const SizedBox(height: 32),
                
                if (isMobile) ...[
                  _buildMobileQuickActions(width),
                  const SizedBox(height: 32),
                  _buildChartCard(),
                  const SizedBox(height: 32),
                  _buildRecentTransactions(),
                  const SizedBox(height: 32),
                  _buildOverduePanel(),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildChartCard(),
                            const SizedBox(height: 32),
                            _buildQuickActionsDesktop(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 1, 
                        child: Column(
                          children: [
                            _buildOverduePanel(),
                            const SizedBox(height: 32),
                            _buildRecentTransactionsSide(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumStats(double width) {
    bool isMobile = width < 850;
    final kpiCards = [
      PremiumStatsCard(
        title: "Total Books",
        subValue: "Library Collection",
        value: "24,532",
        percentage: "+2.4%",
        icon: Icons.menu_book_rounded,
        gradientColors: const [Color(0xFF6366F1), Color(0xFF4F46E5)],
        chartColor: const Color(0xFF6366F1),
        chartPoints: const [Offset(0, 0.5), Offset(1, 0.7), Offset(2, 0.6), Offset(3, 0.8), Offset(4, 0.9), Offset(5, 1.0)],
      ),
      PremiumStatsCard(
        title: "Issued Today",
        subValue: "Daily Circulation",
        value: "142 Books",
        percentage: "+12%",
        icon: Icons.outbox_rounded,
        gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
        chartColor: const Color(0xFF10B981),
        chartPoints: const [Offset(0, 0.2), Offset(1, 0.4), Offset(2, 0.3), Offset(3, 0.5), Offset(4, 0.4), Offset(5, 0.8)],
      ),
      PremiumStatsCard(
        title: "Overdue Books",
        subValue: "Action Required",
        value: "38 Books",
        percentage: "High",
        icon: Icons.warning_rounded,
        gradientColors: const [Color(0xFFF43F5E), Color(0xFFE11D48)],
        chartColor: const Color(0xFFF43F5E),
        chartPoints: const [Offset(0, 0.4), Offset(1, 0.5), Offset(2, 0.3), Offset(3, 0.6), Offset(4, 0.5), Offset(5, 0.9)],
      ),
    ];

    double carouselHeight = isMobile ? 260 : 310;
    double cardWidth = isMobile ? width * 0.85 : 360;

    return SizedBox(
      height: carouselHeight,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: kpiCards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) => SizedBox(
          width: cardWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BubbleAnimation(
              bubbleCount: 4,
              bubbleColor: Colors.white70,
              child: kpiCards[index],
            ),
          ),
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
         .moveY(begin: 0, end: -8, duration: 2000.ms, curve: Curves.easeInOut),
      ),
    );
  }

  Widget _buildMobileQuickActions(double width) {
    final actionsToShow = _showAllActions ? _quickActions : _quickActions.take(7).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: actionsToShow.length + 1,
          itemBuilder: (context, index) {
            if (index == actionsToShow.length) {
              return _buildActionButton(
                _showAllActions ? Icons.expand_less_rounded : Icons.grid_view_rounded,
                _showAllActions ? "Less" : "More",
                Colors.grey.shade400,
                onTap: () => setState(() => _showAllActions = !_showAllActions),
              );
            }
            final action = actionsToShow[index];
            return _buildActionButton(action['icon'], action['label'], action['color']);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return HoverScaleCard(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: BubbleAnimation(
              bubbleCount: 2,
              bubbleColor: Colors.white12,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)), textAlign: TextAlign.center),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildQuickActionsDesktop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Management Hub", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.2,
          ),
          itemCount: _quickActions.length,
          itemBuilder: (context, index) {
            final action = _quickActions[index];
            return _actionBtnDesktop(action['label'], action['icon'], action['color']);
          },
        ),
      ],
    );
  }

  Widget _actionBtnDesktop(String title, IconData icon, Color color) {
    return HoverScaleCard(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsSide() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Activity Log", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text("All")),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Clean Code", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        Text("Returned by Alex", style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Book Issue Trends", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Last 7 Days Activity", style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "This Week",
                  style: TextStyle(color: Color(0xFF4F46E5), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 200,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            days[value.toInt()],
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeBar(0, 120, 80),
                  _makeBar(1, 150, 100),
                  _makeBar(2, 90, 120),
                  _makeBar(3, 140, 90),
                  _makeBar(4, 180, 150),
                  _makeBar(5, 60, 40),
                  _makeBar(6, 40, 30),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1);
  }

  BarChartGroupData _makeBar(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: const Color(0xFF4F46E5),
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        BarChartRodData(
          toY: y2,
          color: const Color(0xFF10B981),
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildOverduePanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: Colors.red.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Overdue Books",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.red),
                      ),
                      const SizedBox(height: 4),
                      Text("Requires immediate action", style: TextStyle(fontSize: 13, color: Colors.red.shade400)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                  child: const Text("38 Pending", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: 4,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.book_rounded, color: Colors.grey),
                ),
                title: const Text("The Pragmatic Programmer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text("Student: John Doe • 5 days late", style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notification_important_rounded),
                  color: Colors.amber,
                  tooltip: "Send Reminder",
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("View All Overdue Books"),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
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
              const Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text("View All")),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 12),
              columns: const [
                DataColumn(label: Text('BOOK TITLE')),
                DataColumn(label: Text('STUDENT')),
                DataColumn(label: Text('DATE')),
                DataColumn(label: Text('TYPE')),
                DataColumn(label: Text('STATUS')),
              ],
              rows: List.generate(5, (index) {
                bool isIssue = index % 2 == 0;
                return DataRow(
                  cells: [
                    DataCell(Row(
                      children: [
                        const Icon(Icons.menu_book_rounded, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('Clean Code', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    )),
                    const DataCell(Text('Alex Smith')),
                    DataCell(Text('Oct ${24 - index}, 2023')),
                    DataCell(
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isIssue ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isIssue ? "ISSUE" : "RETURN",
                          style: TextStyle(
                            color: isIssue ? Colors.blue : Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ),
                    const DataCell(Text('Completed', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600))),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }
}
