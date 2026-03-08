import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IssueBookScreen extends StatefulWidget {
  const IssueBookScreen({super.key});

  @override
  State<IssueBookScreen> createState() => _IssueBookScreenState();
}

class _IssueBookScreenState extends State<IssueBookScreen> {
  bool _showIssueForm = false;
  String? _selectedStudentId;
  String _searchQuery = "";
  final TextEditingController _bookSearchController = TextEditingController();

  // Mock Student Data
  final Map<String, Map<String, dynamic>> _studentsDatabase = {
    "MIT-2024-001": {
      "name": "Alice Smith",
      "branch": "Computer Science",
      "section": "A",
      "photo": "https://i.pravatar.cc/150?img=5",
      "active_issues": [
        {"title": "Clean Code", "due": "Mar 07, 2026", "overdue": false},
        {"title": "Design Patterns", "due": "Feb 28, 2026", "overdue": true},
      ],
      "fine": "₹ 120",
      "max_limit": 5,
    },
    "MIT-2023-015": {
      "name": "Bob Jones",
      "branch": "Mechanical",
      "section": "C",
      "photo": "https://i.pravatar.cc/150?img=11",
      "active_issues": [],
      "fine": "₹ 0",
      "max_limit": 5,
    },
    "MIT-2022-042": {
      "name": "Charlie Brown",
      "branch": "Electronics",
      "section": "B",
      "photo": "https://i.pravatar.cc/150?img=14",
      "active_issues": [
        {"title": "Basic Electronics", "due": "Mar 12, 2026", "overdue": false},
      ],
      "fine": "₹ 0",
      "max_limit": 5,
    },
  };

  final List<Map<String, dynamic>> _allCirculations = [
    {
      "student": "David Wilson",
      "id": "MIT-2024-089",
      "book": "The Pragmatic Programmer",
      "issueDate": "Mar 05, 2026",
      "dueDate": "Mar 20, 2026",
      "fine": "₹ 0",
      "status": "Issued"
    },
    {
      "student": "Alice Smith",
      "id": "MIT-2024-001",
      "book": "Introduction to Algorithms",
      "issueDate": "Mar 04, 2026",
      "dueDate": "Mar 19, 2026",
      "fine": "₹ 0",
      "status": "Issued"
    },
    {
      "student": "Charlie Brown",
      "id": "MIT-2022-042",
      "book": "To Kill a Mockingbird",
      "issueDate": "Feb 15, 2026",
      "dueDate": "Mar 01, 2026",
      "fine": "₹ 0",
      "status": "Returned"
    },
    {
      "student": "Bob Jones",
      "id": "MIT-2023-015",
      "book": "Clean Code",
      "issueDate": "Feb 10, 2026",
      "dueDate": "Feb 25, 2026",
      "fine": "₹ 120",
      "status": "Overdue"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: _showIssueForm
              ? _buildIssueFormFull(isMobile)
              : _buildIssuesList(isMobile),
        );
      },
    );
  }

  // --- VIEW: ISSUES LIST ---
  Widget _buildIssuesList(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Book Circulations",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Manage current and past book lending transactions.",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _showIssueForm = true),
                    icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                    label: const Text("Issue New Book", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds, color: Colors.white24),
            ],
          ).animate().fadeIn().slideY(begin: -0.1),
          if (isMobile) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _showIssueForm = true),
                  icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  label: const Text("Issue New Book", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds, color: Colors.white24),
            ),
          ],
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text("BOOK", style: _headerStyle())),
                      Expanded(flex: 2, child: Text("STUDENT", style: _headerStyle())),
                      Expanded(flex: 2, child: Text("ISSUE / DUE", style: _headerStyle())),
                      Expanded(flex: 1, child: Text("FINE", style: _headerStyle())),
                      Expanded(flex: 2, child: Text("STATUS", style: _headerStyle())),
                      SizedBox(width: 120, child: Text("ACTIONS", style: _headerStyle(), textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _allCirculations.length,
                itemBuilder: (context, index) {
                  final c = _allCirculations[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                    padding: EdgeInsets.all(isMobile ? 16 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: isMobile
                        ? _buildMobileCirculationRow(c)
                        : _buildDesktopCirculationRow(c),
                  ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05, curve: Curves.easeOutQuad);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500, fontSize: 12, letterSpacing: 0.5);

  Widget _buildMobileCirculationRow(Map<String, dynamic> c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                c['book'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
              ),
            ),
            _statusBadge(c['status']),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.person_rounded, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Text("${c['student']} (${c['id']})", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Issue: ${c['issueDate']}", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                const SizedBox(height: 2),
                Text("Due: ${c['dueDate']}", style: TextStyle(color: c['status'] == 'Overdue' ? Colors.red : Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                if (c['fine'] != "₹ 0")
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)),
                    child: Text(c['fine'], style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 18), padding: const EdgeInsets.all(6), constraints: const BoxConstraints()),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopCirculationRow(Map<String, dynamic> c) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.book_rounded, color: Color(0xFF4F46E5), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  c['book'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(c['student'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87)),
              Text(c['id'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(c['issueDate'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              Text(c['dueDate'], style: TextStyle(color: c['status'] == 'Overdue' ? Colors.red : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(c['fine'], style: TextStyle(color: c['fine'] == "₹ 0" ? Colors.grey : Colors.orange, fontWeight: FontWeight.w900, fontSize: 14)),
        ),
        Expanded(
          flex: 2,
          child: Align(alignment: Alignment.centerLeft, child: _statusBadge(c['status'])),
        ),
        SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (c['status'] == 'Issued' || c['status'] == 'Overdue')
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Return", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                ),
              if (c['status'] == 'Issued' || c['status'] == 'Overdue') const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 18), splashRadius: 20, constraints: const BoxConstraints(), padding: const EdgeInsets.all(8)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- VIEW: ISSUE FORM ---
  Widget _buildIssueFormFull(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => setState(() => _showIssueForm = false),
              ),
              const SizedBox(width: 8),
              const Text(
                "Issue New Book",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ).animate().fadeIn().slideX(begin: -0.1),
          const SizedBox(height: 32),
          if (isMobile) ...[
            _buildStudentSearchSection(),
            const SizedBox(height: 32),
            if (_selectedStudentId != null) ...[
              _buildStudentProfileCard(),
              const SizedBox(height: 32),
              _buildIssueForm(),
            ],
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _buildStudentSearchSection(),
                      const SizedBox(height: 24),
                      if (_selectedStudentId != null) _buildStudentProfileCard(),
                    ],
                  ),
                ),
                if (_selectedStudentId != null) ...[
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 5,
                    child: _buildIssueForm(),
                  ),
                ] else ...[
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_search_rounded, size: 80, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text("Search and select a student\nto issue books.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStudentSearchSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "1. Select Student",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                  if (_studentsDatabase.containsKey(_searchQuery)) {
                    _selectedStudentId = _searchQuery;
                  } else {
                    _selectedStudentId = null;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: "Enter Student Roll No. (e.g. MIT-2024-001)",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty && _selectedStudentId == null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "No student found with ID '$_searchQuery'. Try MIT-2024-001, MIT-2023-015.",
                style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildStudentProfileCard() {
    final student = _studentsDatabase[_selectedStudentId]!;
    final activeIssues = student['active_issues'] as List;
    final maxLimit = student['max_limit'] as int;
    final availableLimit = maxLimit - activeIssues.length;
    final hasOverdue = activeIssues.any((element) => element['overdue'] == true);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: hasOverdue ? Colors.red.shade300 : const Color(0xFF4F46E5).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: hasOverdue ? Colors.red.withOpacity(0.05) : const Color(0xFF4F46E5).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: hasOverdue ? Colors.red.shade50 : const Color(0xFFF1F5F9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(student['photo']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$_selectedStudentId • ${student['branch']} (${student['section']})",
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (hasOverdue)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red, size: 14),
                        SizedBox(width: 4),
                        Text("Overdue", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text("Clear Status", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statBadge("Active Issues", "${activeIssues.length}", Icons.menu_book_rounded),
                    _statBadge("Available Limit", "$availableLimit", Icons.check_circle_outline),
                    _statBadge("Pending Fine", student['fine'], Icons.currency_rupee_rounded, color: student['fine'] == "₹ 0" ? Colors.green : Colors.orange),
                  ],
                ),
                if (activeIssues.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text("Currently Issued Books", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 12),
                  ...activeIssues.map((issue) {
                    bool overdue = issue['overdue'];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: overdue ? Colors.red.shade200 : Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.book_outlined, color: overdue ? Colors.red : Colors.grey, size: 16),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              issue['title'],
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                          Text(
                            "Due: ${issue['due']}",
                            style: TextStyle(color: overdue ? Colors.red : Colors.grey.shade600, fontSize: 12, fontWeight: overdue ? FontWeight.bold : FontWeight.normal),
                          ),
                        ],
                      ),
                    );
                  }),
                ]
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _statBadge(String label, String value, IconData icon, {Color color = const Color(0xFF4F46E5)}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
      ],
    );
  }

  Widget _buildIssueForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "2. Issue Book Parameters",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 24),
          _textField("Scan or Search Book", "Enter Accession No. / ISBN / Title", Icons.search),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
              label: const Text("Scan Barcode"),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _datePickerField("Issue Date", "Mar 06, 2026")),
              const SizedBox(width: 20),
              Expanded(child: _datePickerField("Return Date", "Mar 21, 2026")),
            ],
          ),
          const SizedBox(height: 24),
          _textField("Remarks (Optional)", "Add any notes about book condition...", Icons.edit_note_rounded),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() => _showIssueForm = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Book successfully issued to student!")),
                );
              },
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              label: const Text("Confirm Issue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05);
  }

  Widget _textField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: icon == Icons.search ? _bookSearchController : null,
          decoration: InputDecoration(
             hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4F46E5)),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Icon(Icons.calendar_today_rounded, size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'Issued':
        color = Colors.blue;
        break;
      case 'Returned':
        color = Colors.green;
        break;
      case 'Overdue':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
