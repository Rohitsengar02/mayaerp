import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';

class IssueBookScreen extends StatefulWidget {
  const IssueBookScreen({super.key});

  @override
  State<IssueBookScreen> createState() => _IssueBookScreenState();
}

class _IssueBookScreenState extends State<IssueBookScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedBranch;
  String? _selectedSection;
  String? _selectedStudent;
  String? _selectedBook;

  final List<String> _branches = [
    "Computer Science",
    "Mechanical",
    "Civil",
    "Electrical",
    "MBA",
  ];
  final List<String> _sections = ["A", "B", "C", "D"];
  final List<String> _students = [
    "Alice Smith (MIT-2024-001)",
    "Bob Jones (MIT-2023-015)",
    "Charlie Brown (MIT-2022-042)",
    "David Wilson (MIT-2024-089)",
  ];
  final List<String> _books = []; // No longer needed for dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: Row(
        children: [
          // ── LEFT: Library Policy Sidebar ──
          _buildPolicySidebar(),

          // ── RIGHT: Issue Form ──
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(60),
                    child: _buildIssueForm(),
                  ),
                ),
                _buildFooterActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySidebar() {
    return Container(
      width: 380,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Icon(
              Icons.library_books_rounded,
              size: 200,
              color: Colors.white.withValues(alpha: 0.03),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _backButton(),
                const SizedBox(height: 60),
                const Text(
                  "Issue Book Vault",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 34,
                    letterSpacing: -1.2,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Lending transactions must comply with institute library policies. Ensure valid student ID verification before submission.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 60),

                _policyItem(
                  "Standard Loan Period",
                  "Students: 15 Days | Faculty: 45 Days",
                  Icons.calendar_today_rounded,
                ),
                const SizedBox(height: 24),
                _policyItem(
                  "Late Return Fine",
                  "₹10 per delay day after due date",
                  Icons.gavel_rounded,
                ),
                const SizedBox(height: 24),
                _policyItem(
                  "Maximum Limit",
                  "Up to 5 books at a time per student",
                  Icons.warning_amber_rounded,
                ),

                const Spacer(),
                _libStatsSmall(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _policyItem(String title, String sub, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blueAccent, size: 20),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _libStatsSmall() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _miniStat("Total Stock", "22.4K"),
          _miniStat("Issued", "1.8K"),
          _miniStat("Available", "20.6K"),
        ],
      ),
    );
  }

  static Widget _miniStat(String l, String v) => Column(
    children: [
      Text(l, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      const SizedBox(height: 4),
      Text(
        v,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ],
  );

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.auto_stories_rounded, color: AppColors.primaryRed),
          const SizedBox(width: 16),
          Text(
            "Library Circulation",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
          const Text(
            "New Lending Transaction",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const Spacer(),
          _availabilityBadge("Stock Synchronized"),
        ],
      ),
    );
  }

  Widget _availabilityBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 3, backgroundColor: Colors.green),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lending Details",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Select the student and book details below to process the issue request.",
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 48),

          _sectionTitle("1. Student Selection"),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _dropdownField(
                  "BRANCH",
                  _branches,
                  _selectedBranch,
                  (v) => setState(() => _selectedBranch = v),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _dropdownField(
                  "SECTION",
                  _sections,
                  _selectedSection,
                  (v) => setState(() => _selectedSection = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _dropdownField(
            "SEARCH STUDENT",
            _students,
            _selectedStudent,
            (v) => setState(() => _selectedStudent = v),
          ),

          const SizedBox(height: 48),
          _sectionTitle("2. Book Details"),
          const SizedBox(height: 20),
          _inputField(
            "BOOK TITLE",
            "Enter book name or ISBN...",
            (v) => _selectedBook = v,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _datePickerField("ISSUE DATE", "Mar 05, 2026")),
              const SizedBox(width: 24),
              Expanded(
                child: _datePickerField("RETURN DEADLINE", "Mar 20, 2026"),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05);
  }

  Widget _sectionTitle(String t) => Text(
    t,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.blueAccent,
    ),
  );

  Widget _inputField(String label, String hint, Function(String) onCh) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            onChanged: onCh,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: const TextStyle(fontSize: 13, color: Colors.black26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField(
    String label,
    List<String> items,
    String? val,
    Function(String?) onCh,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: val,
              isExpanded: true,
              hint: Text(
                "Select $label",
                style: const TextStyle(fontSize: 13, color: Colors.black26),
              ),
              items: items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onCh,
            ),
          ),
        ),
      ],
    );
  }

  Widget _datePickerField(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const Icon(
                Icons.calendar_month_rounded,
                size: 18,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.grey, size: 16),
              SizedBox(width: 12),
              Text(
                "E-Receipt will be shared with the student automatically.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _mainBtn("Confirm Issue"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mainBtn(String l) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          l,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _backButton() => InkWell(
    onTap: () => Navigator.pop(context),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white,
        size: 16,
      ),
    ),
  );
}
