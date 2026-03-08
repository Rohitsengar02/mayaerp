import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final List<Map<String, dynamic>> _members = [
    {
      "id": "MIT-2024-001",
      "name": "Alice Smith",
      "branch": "Computer Science",
      "role": "Student",
      "issues": 2,
      "fine": "₹ 120",
      "status": "Active",
      "photo": "https://i.pravatar.cc/150?img=5",
    },
    {
      "id": "MIT-2023-015",
      "name": "Bob Jones",
      "branch": "Mechanical",
      "role": "Student",
      "issues": 0,
      "fine": "₹ 0",
      "status": "Active",
      "photo": "https://i.pravatar.cc/150?img=11",
    },
    {
      "id": "MIT-2022-042",
      "name": "Charlie Brown",
      "branch": "Electronics",
      "role": "Student",
      "issues": 1,
      "fine": "₹ 0",
      "status": "Active",
      "photo": "https://i.pravatar.cc/150?img=14",
    },
    {
      "id": "FAC-CS-005",
      "name": "Prof. David Wilson",
      "branch": "Computer Science",
      "role": "Faculty",
      "issues": 4,
      "fine": "₹ 0",
      "status": "Active",
      "photo": "https://i.pravatar.cc/150?img=33",
    },
    {
      "id": "MIT-2024-089",
      "name": "Eve Davis",
      "branch": "Civil",
      "role": "Student",
      "issues": 5,
      "fine": "₹ 0",
      "status": "Suspended",
      "photo": "https://i.pravatar.cc/150?img=20",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile),
                const SizedBox(height: 32),
                _buildSearchAndFilter(isMobile),
                const SizedBox(height: 24),
                _buildMembersList(isMobile),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Library Members",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Manage student and faculty library memberships.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildSearchAndFilter(bool isMobile) {
    return isMobile
        ? Column(
            children: [
              _searchField(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _filterDropdown("Role", ["All Roles", "Student", "Faculty"])),
                  const SizedBox(width: 12),
                  Expanded(child: _filterDropdown("Status", ["All", "Active", "Suspended"])),
                ],
              ),
            ],
          ).animate().fadeIn(delay: 100.ms)
        : Row(
            children: [
              Expanded(flex: 2, child: _searchField()),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _filterDropdown("Role", ["All Roles", "Student", "Faculty"])),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _filterDropdown("Status", ["All", "Active", "Suspended"])),
            ],
          ).animate().fadeIn(delay: 100.ms);
  }

  Widget _searchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search members by name or ID...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _filterDropdown(String hint, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.first,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: (v) {},
        ),
      ),
    );
  }

  Widget _buildMembersList(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text("MEMBER", style: _headerStyle())),
                Expanded(flex: 2, child: Text("ROLE / DEPT", style: _headerStyle())),
                Expanded(flex: 2, child: Text("ISSUED BOOKS", style: _headerStyle())),
                Expanded(flex: 2, child: Text("FINE", style: _headerStyle())),
                Expanded(flex: 2, child: Text("STATUS", style: _headerStyle())),
                SizedBox(width: 80, child: Text("ACTIONS", style: _headerStyle(), textAlign: TextAlign.center)),
              ],
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _members.length,
          itemBuilder: (context, index) {
            final member = _members[index];
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
                  ? _buildMobileMemberRow(member)
                  : _buildDesktopMemberRow(member),
            ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05, curve: Curves.easeOutQuad);
          },
        ),
      ],
    );
  }

  TextStyle _headerStyle() => TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500, fontSize: 12, letterSpacing: 0.5);

  Widget _buildMobileMemberRow(Map<String, dynamic> member) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 24, backgroundImage: NetworkImage(member['photo'])),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
              const SizedBox(height: 2),
              Text("${member['id']} • ${member['role']}", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.menu_book_rounded, size: 14, color: Color(0xFF4F46E5)),
                      ),
                      const SizedBox(width: 8),
                      Text("${member['issues']} Issues", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  _statusBadge(member['status']),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopMemberRow(Map<String, dynamic> member) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(member['photo'])),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                  Text(member['id'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member['role'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87)),
              Text(member['branch'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.menu_book_rounded, size: 16, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(width: 12),
              Text("${member['issues']} Books", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(member['fine'], style: TextStyle(color: member['fine'] == "₹ 0" ? Colors.grey : Colors.orange, fontWeight: FontWeight.w900, fontSize: 14)),
        ),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: _statusBadge(member['status']))),
        SizedBox(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.visibility_rounded, color: Colors.blue, size: 18), splashRadius: 20, constraints: const BoxConstraints(), padding: const EdgeInsets.all(8)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color color = status == "Active" ? Colors.green : Colors.red;
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
