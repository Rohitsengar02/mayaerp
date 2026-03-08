import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';

class InquiriesScreen extends StatefulWidget {
  const InquiriesScreen({super.key});

  @override
  State<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends State<InquiriesScreen> {
  String _activeFilter = 'All';
  bool _showAddSheet = false;

  final List<String> _filters = [
    'All',
    'New',
    'Followup',
    'Resolved',
    'Dropped',
  ];

  final List<Map<String, dynamic>> _inquiries = [
    {
      "name": "Ramesh Kumar",
      "phone": "+91 98765 43200",
      "email": "ramesh@gmail.com",
      "course": "B.Tech CSE",
      "city": "Mumbai",
      "source": "Walk-in",
      "status": "New",
      "date": "5 Mar 2026",
      "note": "Interested in CSE, wants hostel info.",
      "avatar": "https://i.pravatar.cc/150?img=13",
    },
    {
      "name": "Anita Sharma",
      "phone": "+91 98765 43201",
      "email": "anita.s@gmail.com",
      "course": "MBA Finance",
      "city": "Delhi",
      "source": "Phone",
      "status": "Followup",
      "date": "4 Mar 2026",
      "note": "Called for fee structure details.",
      "avatar": "https://i.pravatar.cc/150?img=47",
    },
    {
      "name": "Nikhil Patel",
      "phone": "+91 98765 43202",
      "email": "nikhil.p@gmail.com",
      "course": "B.Sc Physics",
      "city": "Surat",
      "source": "Online Form",
      "status": "Resolved",
      "date": "3 Mar 2026",
      "note": "Applied online. Form submitted.",
      "avatar": "https://i.pravatar.cc/150?img=22",
    },
    {
      "name": "Pooja Mehta",
      "phone": "+91 98765 43203",
      "email": "pooja.m@gmail.com",
      "course": "B.Com Hons",
      "city": "Jaipur",
      "source": "Walk-in",
      "status": "New",
      "date": "5 Mar 2026",
      "note": "Came with parents. Wants scholarship info.",
      "avatar": "https://i.pravatar.cc/150?img=44",
    },
    {
      "name": "Suresh Nair",
      "phone": "+91 98765 43204",
      "email": "suresh.n@gmail.com",
      "course": "B.Tech ECE",
      "city": "Kochi",
      "source": "Referral",
      "status": "Dropped",
      "date": "2 Mar 2026",
      "note": "No response after initial call.",
      "avatar": "https://i.pravatar.cc/150?img=52",
    },
    {
      "name": "Kavya Reddy",
      "phone": "+91 98765 43205",
      "email": "kavya.r@gmail.com",
      "course": "MBA HR",
      "city": "Hyderabad",
      "source": "Walk-in",
      "status": "Followup",
      "date": "4 Mar 2026",
      "note": "Wants to visit campus before confirming.",
      "avatar": "https://i.pravatar.cc/150?img=46",
    },
  ];

  List<Map<String, dynamic>> get _filtered => _activeFilter == 'All'
      ? _inquiries
      : _inquiries.where((i) => i['status'] == _activeFilter).toList();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 850;

        return Stack(
          children: [
            Container(
              color: const Color(0xFFF8F6F6),
              child: Column(
                children: [
                  _buildHeader(context, isMobile),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isMobile ? 16 : 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatsRow(isMobile),
                          SizedBox(height: isMobile ? 24 : 32),
                          _buildFiltersAndGrid(isMobile, width),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Slide-up Add Inquiry Sheet
            if (_showAddSheet) _buildAddSheet(context, isMobile),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 16 : 22,
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
                   "Inquiries Management",
                   style: AppTheme.titleStyle.copyWith(fontSize: 22),
                 ),
                 const SizedBox(height: 16),
                 Row(
                   children: [
                     Expanded(
                       child: _headerActionBtn(
                         "Export", 
                         Icons.file_download_rounded, 
                         const Color(0xFF4F46E5),
                       ),
                     ),
                     const SizedBox(width: 12),
                     Expanded(
                       child: _headerActionBtn(
                         "Add Inquiry", 
                         Icons.add_rounded, 
                         AppColors.primaryRed,
                         isPrimary: true,
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
                      "Inquiries Management",
                      style: AppTheme.titleStyle.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Track and manage student walk-in & phone inquiries",
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _headerActionBtn(
                      "Export", 
                      Icons.file_download_rounded, 
                      const Color(0xFF4F46E5),
                    ),
                    const SizedBox(width: 14),
                    _headerActionBtn(
                      "Add Inquiry", 
                      Icons.add_rounded, 
                      AppColors.primaryRed,
                      isPrimary: true,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _headerActionBtn(String label, IconData icon, Color color, {bool isPrimary = false}) {
    if (isPrimary) {
      return Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => setState(() => _showAddSheet = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(icon, color: Colors.white, size: 18),
          label: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.08),
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, color: color, size: 17),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    final stats = [
      {
        "label": "Total Inquiries",
        "value": _inquiries.length.toString(),
        "icon": Icons.question_answer_rounded,
        "colors": [const Color(0xFF880E4F), const Color(0xFFEC1349)],
      },
      {
        "label": "New Today",
        "value": _inquiries
            .where((i) => i['status'] == 'New')
            .length
            .toString(),
        "icon": Icons.fiber_new_rounded,
        "colors": [const Color(0xFF065F46), const Color(0xFF10B981)],
      },
      {
        "label": "Follow-ups",
        "value": _inquiries
            .where((i) => i['status'] == 'Followup')
            .length
            .toString(),
        "icon": Icons.phone_callback_rounded,
        "colors": [const Color(0xFFB45309), const Color(0xFFF59E0B)],
      },
      {
        "label": "Resolved",
        "value": _inquiries
            .where((i) => i['status'] == 'Resolved')
            .length
            .toString(),
        "icon": Icons.check_circle_rounded,
        "colors": [const Color(0xFF312E81), const Color(0xFF6366F1)],
      },
    ];

    if (isMobile) {
      return SizedBox(
        height: 180,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: stats.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, i) {
            final s = stats[i];
            return SizedBox(
              width: 220,
              child: _statCard(
                s['label'] as String,
                s['value'] as String,
                s['icon'] as IconData,
                s['colors'] as List<Color>,
                i,
              ),
            );
          },
        ),
      );
    }

    return Row(
      children: List.generate(stats.length, (i) {
        final s = stats[i];
        final colors = s['colors'] as List<Color>;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < stats.length - 1 ? 20 : 0),
            child: _statCard(
              s['label'] as String,
              s['value'] as String,
              s['icon'] as IconData,
              colors,
              i,
            ),
          ),
        );
      }),
    );
  }

  Widget _statCard(
    String label,
    String value,
    IconData icon,
    List<Color> colors,
    int index,
  ) {
    return _HoverCard(
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -14,
              bottom: -14,
              child: Icon(
                icon,
                size: 70,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 16),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 70).ms).fadeIn().slideY(begin: 0.2);
  }

  Widget _buildFiltersAndGrid(bool isMobile, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "All Inquiries",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildFilterTabs(),
              ),
            ],
          )
        else
          Row(
            children: [
              const Text(
                "All Inquiries",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              _buildFilterTabs(),
            ],
          ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width < 600 ? 1 : (width < 900 ? 2 : (width < 1400 ? 3 : 4)),
            childAspectRatio: width < 600 ? 1.4 : 1.6,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: _filtered.length,
          itemBuilder: (_, i) => _inquiryCard(_filtered[i], i),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: _filters.map((f) {
          final sel = _activeFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: sel ? AppColors.primaryRed : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: sel
                    ? [
                        BoxShadow(
                          color: AppColors.primaryRed.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 6,
                        ),
                      ]
                    : [],
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontWeight: sel ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                  color: sel ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _inquiryCard(Map<String, dynamic> inq, int index) {
    final status = inq['status'] as String;
    final statusColor = _statusColor(status);
    return _HoverCard(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: avatar + status + source
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(inq['avatar']),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inq['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          inq['phone'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusChip(status, statusColor),
                ],
              ),
              const SizedBox(height: 14),

              // Course chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  inq['course'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Note
              Text(
                inq['note'],
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),

              // Bottom: source + date + actions
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 12,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    inq['city'],
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.sensors_rounded,
                    size: 12,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    inq['source'],
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                  const Spacer(),
                  Text(
                    inq['date'],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _iconBtn(Icons.phone_rounded, Colors.green),
                  const SizedBox(width: 8),
                  _iconBtn(Icons.edit_note_rounded, Colors.blue),
                  const SizedBox(width: 8),
                  _iconBtn(Icons.delete_outline_rounded, Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (index * 55).ms).fadeIn().slideY(begin: 0.12);
  }

  Widget _statusChip(String status, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ],
    ),
  );

  Widget _iconBtn(IconData icon, Color color) => InkWell(
    onTap: () {},
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 16),
    ),
  );

  Color _statusColor(String status) {
    switch (status) {
      case 'New':
        return AppColors.primaryRed;
      case 'Followup':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      case 'Dropped':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  // ── ADD INQUIRY SHEET ──
  Widget _buildAddSheet(BuildContext context, bool isMobile) {

    return GestureDetector(
      onTap: () => setState(() => _showAddSheet = false),
      child: Container(
        color: Colors.black.withOpacity(0.45),
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {}, // prevent closing when tapping inside
            child:
                Container(
                  width: isMobile ? double.infinity : 480,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sheet header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 24,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF880E4F), Color(0xFFEC1349)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Add New Inquiry",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Record a student inquiry",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () =>
                                  setState(() => _showAddSheet = false),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sheetField("Student Name", Icons.person_rounded),
                              const SizedBox(height: 16),
                              _sheetField(
                                "Phone Number",
                                Icons.phone_android_rounded,
                                hint: "+91 9999 999 999",
                              ),
                              const SizedBox(height: 16),
                              _sheetField(
                                "Email Address",
                                Icons.alternate_email_rounded,
                                hint: "student@example.com",
                              ),
                              const SizedBox(height: 16),
                              _sheetField(
                                "City / Location",
                                Icons.location_city_rounded,
                              ),
                              const SizedBox(height: 16),
                              _sheetField(
                                "Course Interested In",
                                Icons.school_rounded,
                                hint: "e.g. B.Tech CSE",
                              ),
                              const SizedBox(height: 16),
                              _sheetField(
                                "Inquiry Source",
                                Icons.sensors_rounded,
                                hint: "Walk-in / Phone / Online / Referral",
                              ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Notes / Remarks",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F6F6),
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: const TextField(
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Any additional notes about the inquiry...",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              // Save button
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryRed.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      setState(() => _showAddSheet = false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 17,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.save_rounded,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Save Inquiry",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().slideX(
                  begin: 1.0,
                  duration: 300.ms,
                  curve: Curves.easeOutCubic,
                ),
          ),
        ),
      ),
    );
  }

  Widget _sheetField(String label, IconData icon, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F6F6),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint ?? "Enter $label",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: Icon(icon, color: AppColors.primaryRed, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
