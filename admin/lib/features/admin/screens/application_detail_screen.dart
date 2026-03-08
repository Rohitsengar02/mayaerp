import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> application;

  const ApplicationDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 900;

        final status = application['status'] as String;
        final statusColor = status == 'Approved'
            ? Colors.green
            : status == 'Rejected'
            ? Colors.red
            : Colors.orange;
        final bannerGrad = status == 'Approved'
            ? [const Color(0xFF065F46), const Color(0xFF10B981)]
            : status == 'Rejected'
            ? [const Color(0xFF7F1D1D), const Color(0xFFEF4444)]
            : [const Color(0xFF880E4F), const Color(0xFFEC1349)];

        Widget leftPanel = Container(
          width: isMobile ? double.infinity : 340,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: bannerGrad,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(top: -50, right: -60, child: _blob(260, 0.07)),
              Positioned(bottom: -80, left: -40, child: _blob(300, 0.05)),
              SafeArea(
                bottom: !isMobile,
                child: Column(
                  mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
                      child: Row(
                        children: [
                          _backIcon(context),
                          const SizedBox(width: 14),
                          const Text(
                            "Application Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    _profileContent(status, statusColor),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _statPill("Merit Score", application['score']),
                          const SizedBox(width: 12),
                          _statPill("Applied On", application['date']),
                        ],
                      ),
                    ),
                    if (!isMobile) const Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, isMobile ? 32 : 0, 24, 32),
                      child: _actionButtons(context, status),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        Widget rightContent = SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section("Personal Information", [
                _infoRow(Icons.person_rounded, "Full Name", application['name']),
                _infoRow(Icons.location_city_rounded, "City", application['city']),
                _infoRow(Icons.phone_android_rounded, "Mobile", "+91 98765 43210"),
                _infoRow(Icons.alternate_email_rounded, "Email", "${(application['name'] as String).toLowerCase().replaceAll(' ', '.')}@example.com"),
                _infoRow(Icons.location_on_rounded, "Address", "123, Main Road, ${application['city']} - 400001"),
              ], 0),
              const SizedBox(height: 28),
              _section("Academic Details", [
                _infoRow(Icons.school_rounded, "Qualification", "XII / HSC"),
                _infoRow(Icons.account_balance_rounded, "Institution", "Govt Senior Secondary School"),
                _infoRow(Icons.percent_rounded, "Percentage", application['score']),
                _infoRow(Icons.calendar_today_rounded, "Year of Passing", "2023"),
                _infoRow(Icons.assignment_rounded, "Entrance Score", "JEE Mains — 87.4 Percentile"),
              ], 1),
              const SizedBox(height: 28),
              _section("Program Selection", [
                _infoRow(Icons.library_books_rounded, "Applied Course", application['course']),
                _infoRow(Icons.event_rounded, "Academic Session", "2024-25"),
                _infoRow(Icons.category_rounded, "Category", "General"),
                _infoRow(Icons.calendar_month_rounded, "Date", "Aug ${application['date'].split(' ').last}, 2023"),
              ], 2),
              const SizedBox(height: 28),
              _section("Uploaded Documents", [], 3, customChild: _docGrid(width)),
              const SizedBox(height: 28),
              _section("Application Timeline", [], 4, customChild: _timeline(status)),
            ],
          ),
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF8F6F6),
          body: isMobile
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      leftPanel,
                      rightContent,
                    ],
                  ),
                )
              : Row(
                  children: [
                    leftPanel,
                    Expanded(child: rightContent),
                  ],
                ),
        );
      },
    );
  }

  Widget _backIcon(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _profileContent(String status, Color statusColor) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage(application['avatar']),
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
        const SizedBox(height: 20),
        Text(
          application['name'],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Text(
            application['course'],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                status,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButtons(BuildContext context, String status) {
    if (status == 'Pending') {
      return Column(
        children: [
          _actionButton("✓  Approve Application", Colors.green, () => Navigator.pop(context)),
          const SizedBox(height: 12),
          _actionButton("✕  Reject Application", Colors.red, () => Navigator.pop(context)),
        ],
      );
    }
    return _actionButton(
      "← Back to Applications",
      Colors.white.withValues(alpha: 0.15),
      () => Navigator.pop(context),
      textColor: Colors.white,
    );
  }

  Widget _blob(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: opacity),
    ),
  );

  Widget _statPill(String label, String val) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _actionButton(
    String label,
    Color bg,
    VoidCallback onTap, {
    Color textColor = Colors.white,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _section(
    String title,
    List<Widget> rows,
    int index, {
    Widget? customChild,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (rows.isNotEmpty) ...[
            const SizedBox(height: 20),
            ...rows.map(
              (r) =>
                  Padding(padding: const EdgeInsets.only(bottom: 14), child: r),
            ),
          ],
          if (customChild != null) ...[const SizedBox(height: 20), customChild],
        ],
      ),
    ).animate(delay: (index * 80).ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _infoRow(IconData icon, String label, String val) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryRed, size: 16),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              val,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _docGrid(double width) {
    final docs = [
      {
        "name": "10th Marksheet",
        "color": const Color(0xFF4F46E5),
        "status": "Uploaded",
      },
      {
        "name": "12th Marksheet",
        "color": const Color(0xFF0891B2),
        "status": "Uploaded",
      },
      {
        "name": "Transfer Cert",
        "color": const Color(0xFF7C3AED),
        "status": "Uploaded",
      },
      {
        "name": "Aadhar Card",
        "color": AppColors.primaryRed,
        "status": "Uploaded",
      },
      {
        "name": "Passport Photo",
        "color": const Color(0xFF059669),
        "status": "Pending",
      },
      {
        "name": "Entrance Score",
        "color": const Color(0xFFD97706),
        "status": "Pending",
      },
    ];
    return GridView.count(
      crossAxisCount: width < 600 ? 1 : (width < 1200 ? 2 : 3),
      childAspectRatio: width < 650 ? 3.5 : 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      children: docs.map((d) {
        final color = d['color'] as Color;
        final isUploaded = d['status'] == 'Uploaded';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(
                isUploaded
                    ? Icons.check_circle_rounded
                    : Icons.upload_file_rounded,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      d['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      d['status'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _timeline(String status) {
    final events = [
      {
        "title": "Application Submitted",
        "date": "Aug 15, 2023 • 10:30 AM",
        "done": true,
      },
      {
        "title": "Documents Verified",
        "date": "Aug 17, 2023 • 02:15 PM",
        "done": true,
      },
      {
        "title": "Under Review",
        "date": "Aug 19, 2023 • 09:00 AM",
        "done": status != 'Pending',
      },
      {
        "title": status == 'Approved'
            ? "Application Approved"
            : status == 'Rejected'
            ? "Application Rejected"
            : "Decision Pending",
        "date": status != 'Pending'
            ? "Aug 21, 2023 • 11:45 AM"
            : "Awaiting admin decision",
        "done": status != 'Pending',
      },
    ];
    return Column(
      children: List.generate(events.length, (i) {
        final e = events[i];
        final isDone = e['done'] as bool;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDone ? AppColors.primaryRed : Colors.grey.shade200,
                    shape: BoxShape.circle,
                    boxShadow: isDone
                        ? [
                            BoxShadow(
                              color: AppColors.primaryRed.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    isDone ? Icons.check_rounded : Icons.schedule_rounded,
                    color: isDone ? Colors.white : Colors.grey,
                    size: 14,
                  ),
                ),
                if (i < events.length - 1)
                  Container(
                    width: 2,
                    height: 36,
                    color: isDone
                        ? AppColors.primaryRed.withValues(alpha: 0.3)
                        : Colors.grey.shade200,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e['title'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDone ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    e['date'] as String,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
