import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import 'create_user_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _users = [
    {
      "name": "Robert Fox",
      "email": "robert.fox@maya.edu",
      "role": "Admin",
      "dept": "Administration",
      "status": "Active",
      "phone": "+91 98765 43210",
      "joined": "Jan 2023",
      "avatar": "https://i.pravatar.cc/150?img=11",
    },
    {
      "name": "Annette Black",
      "email": "annette.b@maya.edu",
      "role": "Staff",
      "dept": "Academic",
      "status": "Active",
      "phone": "+91 98765 43211",
      "joined": "Mar 2022",
      "avatar": "https://i.pravatar.cc/150?img=47",
    },
    {
      "name": "Cody Fisher",
      "email": "cody.f@maya.edu",
      "role": "Accountant",
      "dept": "Finance",
      "status": "Inactive",
      "phone": "+91 98765 43212",
      "joined": "Jul 2021",
      "avatar": "https://i.pravatar.cc/150?img=33",
    },
    {
      "name": "Jane Cooper",
      "email": "jane.c@maya.edu",
      "role": "Librarian",
      "dept": "Library",
      "status": "Active",
      "phone": "+91 98765 43213",
      "joined": "Nov 2023",
      "avatar": "https://i.pravatar.cc/150?img=48",
    },
    {
      "name": "Wade Warren",
      "email": "wade.w@maya.edu",
      "role": "Faculty",
      "dept": "Academic",
      "status": "Active",
      "phone": "+91 98765 43214",
      "joined": "Aug 2020",
      "avatar": "https://i.pravatar.cc/150?img=32",
    },
    {
      "name": "Esther Howard",
      "email": "esther.h@maya.edu",
      "role": "HOD",
      "dept": "Academic",
      "status": "Active",
      "phone": "+91 98765 43215",
      "joined": "Feb 2019",
      "avatar": "https://i.pravatar.cc/150?img=45",
    },
    {
      "name": "Cameron Williamson",
      "email": "cam.w@maya.edu",
      "role": "Staff",
      "dept": "HR",
      "status": "Inactive",
      "phone": "+91 98765 43216",
      "joined": "Oct 2022",
      "avatar": "https://i.pravatar.cc/150?img=12",
    },
    {
      "name": "Brooklyn Simmons",
      "email": "brook.s@maya.edu",
      "role": "Admin",
      "dept": "IT Support",
      "status": "Active",
      "phone": "+91 98765 43217",
      "joined": "May 2021",
      "avatar": "https://i.pravatar.cc/150?img=49",
    },
  ];

  final List<String> _filters = [
    'All',
    'Admin',
    'Staff',
    'Faculty',
    'Accountant',
    'Librarian',
  ];

  List<Map<String, dynamic>> get _filtered => _selectedFilter == 'All'
      ? _users
      : _users.where((u) => u['role'] == _selectedFilter).toList();

  @override
  Widget build(BuildContext context) {
    final stats = {
      'Total Users': _users.length,
      'Active': _users.where((u) => u['status'] == 'Active').length,
      'Inactive': _users.where((u) => u['status'] == 'Inactive').length,
      'Admins': _users.where((u) => u['role'] == 'Admin').length,
    };

    return Container(
      color: const Color(0xFFF8F6F6),
      child: Column(
        children: [
          // ── TOPBAR ──
          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── STATS ROW ──
                  _buildStatsRow(stats),
                  const SizedBox(height: 32),

                  // ── FILTERS ──
                  _buildFilters(),
                  const SizedBox(height: 32),

                  // ── USER CARDS GRID ──
                  _buildUsersGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                "User Management",
                style: AppTheme.titleStyle.copyWith(fontSize: 28),
              ),
              Text(
                "Manage all portal accounts and permissions",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              // Search
              Container(
                width: 250,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search users...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Create button
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    _slideRoute(const CreateUserScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    "Create New User",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(Map<String, int> stats) {
    final colors = [
      AppColors.primaryRed,
      Colors.green,
      Colors.orange,
      Colors.indigo,
    ];
    final icons = [
      Icons.people_alt_rounded,
      Icons.verified_rounded,
      Icons.person_off_rounded,
      Icons.admin_panel_settings_rounded,
    ];

    return Row(
      children: List.generate(stats.length, (i) {
        final key = stats.keys.elementAt(i);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < stats.length - 1 ? 20 : 0),
            child: _statCard(key, stats[key]!, icons[i], colors[i], i),
          ),
        );
      }),
    );
  }

  Widget _statCard(
    String label,
    int value,
    IconData icon,
    Color color,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (index * 80).ms).fadeIn().slideY(begin: 0.2);
  }

  Widget _buildFilters() {
    return Row(
      children: [
        const Text(
          "Filter by Role:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 16),
        Wrap(
          spacing: 10,
          children: _filters.map((f) {
            final isSelected = _selectedFilter == f;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryRed : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryRed
                        : Colors.grey.shade200,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryRed.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const Spacer(),
        Text(
          "${_filtered.length} user${_filtered.length != 1 ? 's' : ''}",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildUsersGrid() {
    final users = _filtered;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.78,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) => _userCard(users[index], index),
    );
  }

  Widget _userCard(Map<String, dynamic> user, int index) {
    final isActive = user['status'] == 'Active';
    final roleColor = _roleColor(user['role']);

    return _HoverCard(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Top gradient accent
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      roleColor.withValues(alpha: 0.15),
                      roleColor.withValues(alpha: 0.02),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                ),
              ),
            ),

            // Status dot
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isActive
                        ? Colors.green.withValues(alpha: 0.3)
                        : Colors.red.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user['status'],
                      style: TextStyle(
                        color: isActive
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: roleColor.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user['avatar']),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    user['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['email'],
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Role & Dept chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      _chip(user['role'], roleColor),
                      _chip(user['dept'], Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Info row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(
                        user['phone'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 12,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Joined ${user['joined']}",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _actionBtn(
                          Icons.edit_note_rounded,
                          Colors.blue,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _actionBtn(
                          Icons.lock_reset_rounded,
                          Colors.orange,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _actionBtn(
                          Icons.delete_outline_rounded,
                          Colors.red,
                          () {},
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
    ).animate(delay: (index * 60).ms).fadeIn().slideY(begin: 0.15);
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'Admin':
        return AppColors.primaryRed;
      case 'Staff':
        return const Color(0xFF7C3AED);
      case 'Faculty':
        return Colors.blue;
      case 'Accountant':
        return Colors.green;
      case 'Librarian':
        return Colors.orange;
      case 'HOD':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
          ),
          child: child,
        );
      },
    );
  }
}

// ── Hover-elevate card wrapper ──
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
        scale: _hovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
