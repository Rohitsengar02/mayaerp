import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import 'issue_book_screen.dart';

class LibraryManagementScreen extends StatefulWidget {
  const LibraryManagementScreen({super.key});

  @override
  State<LibraryManagementScreen> createState() =>
      _LibraryManagementScreenState();
}

class _LibraryManagementScreenState extends State<LibraryManagementScreen> {
  final List<Map<String, dynamic>> _issuedBooks = [
    {
      "student": "Alice Smith",
      "roll": "MIT-2024-001",
      "book": "Flutter for Beginners",
      "date": "Feb 20, 2026",
      "due": "Mar 07, 2026",
      "status": "Active",
    },
    {
      "student": "Bob Jones",
      "roll": "MIT-2023-015",
      "book": "Algorithms (Cormen)",
      "date": "Jan 28, 2026",
      "due": "Feb 12, 2026",
      "status": "Overdue",
    },
    {
      "student": "Charlie Brown",
      "roll": "MIT-2022-042",
      "book": "Psychology 101",
      "date": "Feb 28, 2026",
      "due": "Mar 15, 2026",
      "status": "Active",
    },
  ];

  String _issuedSearchQuery = "";
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 1100;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F6F6),
          body: Column(
            children: [
              _buildHeader(isMobile),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 20 : 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInventoryStats(isMobile),
                      const SizedBox(height: 32),
                      _buildCirculationLedger(isMobile),
                      const SizedBox(height: 32),
                      _buildLibraryConfigBlocks(isMobile),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 16 : 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Library Administration",
                      style: AppTheme.titleStyle.copyWith(
                        fontSize: isMobile ? 20 : 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Central database for stock selection & book circulation tracking",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isMobile)
                Row(
                  children: [
                    _headerActionBtn(
                      Icons.assignment_ind_rounded,
                      "Lending Rules",
                      Colors.white,
                      Colors.black,
                      () {},
                    ),
                    const SizedBox(width: 16),
                    _headerActionBtn(
                      Icons.auto_stories_rounded,
                      "Issue Book",
                      AppColors.primaryRed,
                      Colors.white,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const IssueBookScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _headerActionBtn(
                    Icons.assignment_ind_rounded,
                    "Rules",
                    Colors.white,
                    Colors.black,
                    () {},
                    isMobile: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _headerActionBtn(
                    Icons.auto_stories_rounded,
                    "Issue",
                    AppColors.primaryRed,
                    Colors.white,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const IssueBookScreen(),
                        ),
                      );
                    },
                    isMobile: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _headerActionBtn(
    IconData icon,
    String label,
    Color bg,
    Color fg,
    VoidCallback onTap, {
    bool isMobile = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: bg != Colors.white
            ? [
                BoxShadow(
                  color: bg.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 20,
              vertical: isMobile ? 12 : 14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: fg, size: isMobile ? 18 : 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 12 : 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryStats(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _libStat(
            "Issued Hub",
            "1,840",
            Icons.bookmark_added_rounded,
            Colors.blue,
            "8% of stock",
            isMobile: true,
          ),
          const SizedBox(height: 16),
          _libStat(
            "Fine Ledger",
            "₹12,200",
            Icons.currency_rupee_rounded,
            Colors.orange,
            "94% collected",
            isMobile: true,
          ),
          const SizedBox(height: 16),
          _libStat(
            "Daily Traffic",
            "342",
            Icons.groups_rounded,
            Colors.teal,
            "Peak at 2 PM",
            isMobile: true,
          ),
        ],
      ).animate().fadeIn().slideY(begin: 0.1);
    }
    return Row(
      children: [
        Expanded(
          child: _libStat(
            "Issued Hub",
            "1,840",
            Icons.bookmark_added_rounded,
            Colors.blue,
            "8% of stock",
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _libStat(
            "Fine Ledger",
            "₹12,200",
            Icons.currency_rupee_rounded,
            Colors.orange,
            "94% collected",
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _libStat(
            "Daily Traffic",
            "342",
            Icons.groups_rounded,
            Colors.teal,
            "Peak at 2 PM",
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _libStat(
    String title,
    String val,
    IconData icon,
    Color color,
    String trend, {
    bool isMobile = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: isMobile ? 24 : 28),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            val,
            style: AppTheme.titleStyle.copyWith(
              fontSize: isMobile ? 28 : 32,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCirculationLedger(bool isMobile) {
    final filteredIssues = _issuedBooks.where((b) {
      final query = _issuedSearchQuery.toLowerCase();
      return b['student'].toLowerCase().contains(query) ||
          b['roll'].toLowerCase().contains(query);
    }).toList();

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            const Text(
              "Active Circulation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _circulationSearch(isMobile),
          ] else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Active Book Circulation",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                _circulationSearch(isMobile),
              ],
            ),
          const SizedBox(height: 32),
          const Divider(),
          if (filteredIssues.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  "No lending records found matching '$_issuedSearchQuery'",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
            )
          else
            ...List.generate(
              filteredIssues.length,
              (index) => _issuedBookRow(filteredIssues[index], isMobile),
            ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _circulationSearch(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 320,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: (v) => setState(() => _issuedSearchQuery = v),
        decoration: const InputDecoration(
          hintText: "Search Student ID or Name...",
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, size: 18, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _issuedBookRow(Map<String, dynamic> data, bool isMobile) {
    bool isOverdue = data['status'] == 'Overdue';

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isOverdue ? Colors.red : Colors.blue).withValues(
                      alpha: 0.05,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: isOverdue ? Colors.red : Colors.blue,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['student'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        data['roll'],
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusBadge(data['status']),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['book'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Text(
                        "Lent on Card",
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Due Date",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    Text(
                      data['due'],
                      style: TextStyle(
                        color: isOverdue ? Colors.red : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                _rowActionBtn(data),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isOverdue ? Colors.red : Colors.blue).withValues(
                alpha: 0.05,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: isOverdue ? Colors.red : Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['student'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  data['roll'],
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['book'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const Text(
                  "Lent on Library Card",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Due Date",
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              Text(
                data['due'],
                style: TextStyle(
                  color: isOverdue ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(width: 60),
          _statusBadge(data['status']),
          const SizedBox(width: 24),
          _rowActionBtn(data),
        ],
      ),
    );
  }

  Widget _rowActionBtn(Map<String, dynamic> data) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
      onSelected: (newStatus) {
        setState(() {
          data['status'] = newStatus;
        });
      },
      itemBuilder: (context) => [
        _statusMenuItem("Active", Colors.blue),
        _statusMenuItem("Overdue", Colors.red),
        _statusMenuItem("Returned", Colors.green),
        _statusMenuItem("Lost", Colors.orange),
      ],
    );
  }

  PopupMenuItem<String> _statusMenuItem(String val, Color color) {
    return PopupMenuItem(
      value: val,
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 12),
          Text(
            val,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryConfigBlocks(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _configCard(
            "Fine Rules",
            Icons.gavel_rounded,
            "₹10 / Overdue Day",
            isMobile: true,
          ),
          const SizedBox(height: 16),
          _configCard(
            "Issue Limits",
            Icons.assignment_rounded,
            "Staff: 15 | Student: 05",
            isMobile: true,
          ),
          const SizedBox(height: 16),
          _configCard(
            "Digital Access",
            Icons.computer_rounded,
            "Enabled globally",
            isMobile: true,
          ),
        ],
      ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1);
    }
    return Row(
      children: [
        Expanded(
          child: _configCard(
            "Fine Rules",
            Icons.gavel_rounded,
            "₹10 / Overdue Day",
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _configCard(
            "Issue Limits",
            Icons.assignment_rounded,
            "Staff: 15 | Student: 05",
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _configCard(
            "Digital Access",
            Icons.computer_rounded,
            "Enabled globally",
          ),
        ),
      ],
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1);
  }

  Widget _configCard(
    String title,
    IconData icon,
    String val, {
    bool isMobile = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryRed, size: isMobile ? 28 : 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            val,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color c = Colors.green;
    if (status == 'Overdue') c = Colors.red;
    if (status == 'Active') c = Colors.blue;
    if (status == 'Lost') c = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: c,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
