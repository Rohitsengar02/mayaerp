import 'package:flutter/material.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'create_payout_screen.dart';

class FinanceFeesScreen extends StatefulWidget {
  const FinanceFeesScreen({super.key});

  @override
  State<FinanceFeesScreen> createState() => _FinanceFeesScreenState();
}

class _FinanceFeesScreenState extends State<FinanceFeesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 900;
        final isNarrow = width < 600;

        return Container(
          color: const Color(0xFFF8F6F6),
          child: Column(
            children: [
              _buildTopBar(isMobile),
              _buildSubHeader(isMobile),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFeesTab(isMobile, isNarrow),
                    _buildPayoutsTab(isMobile, isNarrow)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 20 : 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Financial Control",
                  style: AppTheme.titleStyle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        Icons.add_card_rounded,
                        "New Fee",
                        Colors.white,
                        AppColors.primaryRed,
                        () {},
                        isMobile: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _actionButton(
                        Icons.payments_rounded,
                        "Payout",
                        AppColors.primaryRed,
                        Colors.white,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreatePayoutScreen(),
                            ),
                          );
                        },
                        isMobile: true,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Financial Control",
                      style: AppTheme.titleStyle.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Monitor revenue, outstanding dues, and staff payouts in real-time.",
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _actionButton(
                      Icons.add_card_rounded,
                      "New Fee Group",
                      Colors.white,
                      AppColors.primaryRed,
                      () {},
                    ),
                    const SizedBox(width: 14),
                    _actionButton(
                      Icons.payments_rounded,
                      "Initiate Payout",
                      AppColors.primaryRed,
                      Colors.white,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreatePayoutScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSubHeader(bool isMobile) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: Row(
        children: [
          _tabItem("Revenue & Fees", 0),
          _tabItem("Payouts & Payroll", 1),
        ],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    bool isSelected = _tabController.index == index;
    return InkWell(
      onTap: () => setState(() => _tabController.animateTo(index)),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primaryRed : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primaryRed : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildFeesTab(bool isMobile, bool isNarrow) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        children: [
          _buildFinanceOverview(isMobile, isNarrow),
          const SizedBox(height: 24),
          _buildRecentTransactions("Recent Fee Success", isMobile),
          const SizedBox(height: 24),
          _buildFeeStructureGrid(isMobile, isNarrow),
        ],
      ),
    );
  }

  Widget _buildPayoutsTab(bool isMobile, bool isNarrow) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        children: [
          _buildPayoutOverview(isMobile, isNarrow),
          const SizedBox(height: 24),
          _buildRecentTransactions("Recent Salary & Vendor Payouts", isMobile),
        ],
      ),
    );
  }

  Widget _buildFinanceOverview(bool isMobile, bool isNarrow) {
    if (isNarrow) {
      return Column(
        children: [
          _financeCard(
            "Total Receivable",
            "₹12.4M",
            "+8.2% vs LW",
            Icons.account_balance_rounded,
            [const Color(0xFF6366F1), const Color(0xFF818CF8)],
            isMobile: true,
          ),
          const SizedBox(height: 16),
          _financeCard(
            "Total Collected",
            "₹8.2M",
            "66% Target Met",
            Icons.check_circle_rounded,
            [const Color(0xFF10B981), const Color(0xFF34D399)],
            isMobile: true,
          ),
          const SizedBox(height: 16),
          _financeCard(
            "Outstanding Dues",
            "₹4.2M",
            "1,240 Students",
            Icons.warning_rounded,
            [const Color(0xFFEC1349), const Color(0xFFFF6B6B)],
            isMobile: true,
          ),
        ],
      ).animate().fadeIn().slideY(begin: 0.1);
    }
    return Row(
      children: [
        Expanded(
          child: _financeCard(
            "Total Receivable",
            "₹12.4M",
            "+8.2% vs LW",
            Icons.account_balance_rounded,
            [const Color(0xFF6366F1), const Color(0xFF818CF8)],
            isMobile: isMobile,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _financeCard(
            "Total Collected",
            "₹8.2M",
            "66% Target Met",
            Icons.check_circle_rounded,
            [const Color(0xFF10B981), const Color(0xFF34D399)],
            isMobile: isMobile,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _financeCard(
            "Outstanding Dues",
            "₹4.2M",
            "1,240 Students",
            Icons.warning_rounded,
            [const Color(0xFFEC1349), const Color(0xFFFF6B6B)],
            isMobile: isMobile,
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildPayoutOverview(bool isMobile, bool isNarrow) {
    if (isNarrow) {
      return Column(
        children: [
          _financeCard(
            "Salary Payouts",
            "₹48.5L",
            "March 2026",
            Icons.person_pin_rounded,
            [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
            isMobile: true,
          ),
          const SizedBox(height: 16),
          _financeCard(
            "Vendor Payments",
            "₹12.2L",
            "14 Pending",
            Icons.shopping_bag_rounded,
            [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
            isMobile: true,
          ),
          const SizedBox(height: 16),
          _financeCard(
            "Utility Bills",
            "₹1.4L",
            "Due in 3 days",
            Icons.bolt_rounded,
            [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)],
            isMobile: true,
          ),
        ],
      ).animate().fadeIn().slideY(begin: 0.1);
    }
    return Row(
      children: [
        Expanded(
          child: _financeCard(
            "Salary Payouts",
            "₹48.5L",
            "March 2026",
            Icons.person_pin_rounded,
            [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
            isMobile: isMobile,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _financeCard(
            "Vendor Payments",
            "₹12.2L",
            "14 Pending",
            Icons.shopping_bag_rounded,
            [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
            isMobile: isMobile,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _financeCard(
            "Utility Bills",
            "₹1.4L",
            "Due in 3 days",
            Icons.bolt_rounded,
            [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)],
            isMobile: isMobile,
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _financeCard(
    String title,
    String value,
    String sub,
    IconData icon,
    List<Color> colors, {
    bool isMobile = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.2),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: Colors.white60,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            sub,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(String title, bool isMobile) {
    final List<Map<String, dynamic>> txns = [
      {
        "name": "Rahul Gupta",
        "ref": "B.Tech Sem 5",
        "amount": "₹45,000",
        "status": "Success",
        "method": "Online",
        "date": "10 Min ago",
      },
      {
        "name": "Sanya Verma",
        "ref": "MBA Sem 1",
        "amount": "₹22,500",
        "status": "Pending",
        "method": "UPI",
        "date": "2 Hours ago",
      },
      {
        "name": "Sameer Khan",
        "ref": "Hostel Fee",
        "amount": "₹12,400",
        "status": "Failed",
        "method": "Bank",
        "date": "Yesterday",
      },
      {
        "name": "Dr. Arpit Mishra",
        "ref": "Salary Payout",
        "amount": "₹1,20,000",
        "status": "Success",
        "method": "IMPS",
        "date": "1 Day ago",
      },
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (!isMobile)
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Export Ledger",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...txns.map((t) => _txnListRow(t, isMobile)).toList(),
        ],
      ),
    );
  }

  Widget _txnListRow(Map<String, dynamic> t, bool isMobile) {
    Color statusColor = t['status'] == 'Success'
        ? Colors.green
        : (t['status'] == 'Pending' ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF8F6F6))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_rounded, color: statusColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  t['ref'],
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                t['amount'],
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              if (!isMobile)
                Text(
                  t['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          if (!isMobile) ...[
            const SizedBox(width: 24),
            Text(
              t['date'],
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
            ),
            const SizedBox(width: 16),
            _iconAction(Icons.more_vert_rounded),
          ],
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }

  Widget _buildFeeStructureGrid(bool isMobile, bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fee Frameworks",
          style: AppTheme.titleStyle.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: isNarrow ? 1 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: isNarrow ? 4 : (isMobile ? 2.5 : 3.5),
          children: [
            _frameworkCard(
              "B.Tech CSE - 2024",
              "₹1,80,000 / Year",
              "2 Installments",
            ),
            _frameworkCard(
              "MBA Executive",
              "₹3,50,000 / Year",
              "4 Installments",
            ),
          ],
        ),
      ],
    );
  }

  Widget _frameworkCard(String head, String cost, String schedule) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.layers_rounded,
              color: AppColors.primaryRed,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  head,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  cost,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    Color bg,
    Color fg,
    VoidCallback onTap, {
    bool isMobile = false,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 18 : 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: bg == Colors.white ? 0 : 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _iconAction(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: Colors.grey),
    );
  }
}
