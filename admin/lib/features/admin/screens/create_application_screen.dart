import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';

class CreateApplicationScreen extends StatefulWidget {
  const CreateApplicationScreen({super.key});

  @override
  State<CreateApplicationScreen> createState() =>
      _CreateApplicationScreenState();
}

class _CreateApplicationScreenState extends State<CreateApplicationScreen> {
  int _step = 0;
  bool _isSaving = false;
  String _selectedProgram = 'B.Tech CSE';
  String _selectedSession = '2024-25';
  String _selectedCategory = 'General';
  String _selectedGender = 'Male';
  String _selectedQualification = 'XII / HSC';

  final _programs = [
    'B.Tech CSE',
    'B.Tech ECE',
    'B.Tech Mech',
    'MBA Finance',
    'MBA HR',
    'MBA General',
    'B.Sc Physics',
    'B.Sc Data Science',
    'B.Com Honours',
  ];
  final _sessions = ['2024-25', '2023-24', '2022-23'];
  final _categories = ['General', 'OBC', 'SC', 'ST', 'EWS', 'PWD'];
  final _genders = ['Male', 'Female', 'Other'];
  final _qualifications = [
    'XII / HSC',
    'Diploma',
    'BSc',
    'BCom',
    'BA',
    'BE/BTech',
    'Other',
  ];
  final _stepLabels = [
    'Personal Details',
    'Academic Info',
    'Program Selection',
    'Documents',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 900;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F6F6),
          body: Row(
            children: [
              // ── LEFT GRADIENT PANEL (Desktop only) ──
              if (!isMobile)
                SizedBox(
                  width: 320,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF6B0F3A),
                          Color(0xFFEC1349),
                          Color(0xFFFF6B6B),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(top: -60, right: -60, child: _blob(220, 0.06)),
                        Positioned(bottom: -80, left: -40, child: _blob(260, 0.05)),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(28, 48, 28, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _backButton(context),
                                  const SizedBox(height: 32),
                                  _photoUpload(),
                                  const SizedBox(height: 32),
                                  _buildStepper(),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
                              child: Column(
                                children: [
                                  _infoTile(Icons.shield_rounded, "Secure Data"),
                                  const SizedBox(height: 12),
                                  _infoTile(Icons.notifications_active_rounded, "Auto Alerts"),
                                  const SizedBox(height: 12),
                                  _infoTile(Icons.track_changes_rounded, "Real-time Tracking"),
                                ],
                              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // ── RIGHT FORM PANEL ──
              Expanded(
                child: Column(
                  children: [
                    _formTopBar(isMobile),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 48,
                          vertical: isMobile ? 24 : 36,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 320),
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: Tween(
                                begin: const Offset(0.04, 0),
                                end: Offset.zero,
                              ).animate(anim),
                              child: child,
                            ),
                          ),
                          child: _buildStepContent(width: width, key: ValueKey(_step)),
                        ),
                      ),
                    ),
                    _buildNavBar(isMobile),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 15,
            ),
            SizedBox(width: 8),
            Text(
              "Back",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.2);
  }

  Widget _photoUpload() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 3,
                  ),
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 44),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primaryRed,
                    size: 14,
                  ),
                ),
              ),
            ],
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 10),
          const Text(
            "Applicant Photo",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "Tap to upload • Max 5MB",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildStepper() {
    return Column(
      children: List.generate(_stepLabels.length, (i) {
        final isDone = _step > i;
        final isActive = _step == i;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDone
                        ? Colors.greenAccent
                        : (isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.2)),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: isActive ? 1 : 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.black,
                            size: 16,
                          )
                        : Text(
                            "${i + 1}",
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.primaryRed
                                  : Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                  ),
                ),
                if (i < _stepLabels.length - 1)
                  Container(
                    width: 2,
                    height: 28,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                _stepLabels[i],
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.55),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );
      }),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _infoTile(IconData icon, String text) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  // ── TOP BAR ──
  Widget _formTopBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 14 : 18,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New Application",
                  style: AppTheme.titleStyle.copyWith(fontSize: isMobile ? 18 : 22),
                ),
                Text(
                  "Step ${_step + 1}: ${_stepLabels[_step]}",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            const Spacer(),
            SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${((_step + 1) / _stepLabels.length * 100).toInt()}% Complete",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (_step + 1) / _stepLabels.length,
                      color: AppColors.primaryRed,
                      backgroundColor: AppColors.primaryRed.withValues(
                        alpha: 0.1,
                      ),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepContent({required double width, required Key key}) {
    bool isMobile = width < 900;
    switch (_step) {
      case 0:
        return _stepPersonal(width: width, key: key);
      case 1:
        return _stepAcademic(width: width, key: key);
      case 2:
        return _stepProgram(width: width, key: key);
      case 3:
        return _stepDocuments(width: width, key: key);
      default:
        return _stepPersonal(width: width, key: key);
    }
  }

  Widget _stepPersonal({required double width, required Key key}) {
    bool isMobile = width < 700;
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          "Personal Details",
          "Enter the applicant's personal information",
          Icons.person_rounded,
        ),
        const SizedBox(height: 30),
        _row(isMobile, [
          _field("First Name", Icons.person_outline_rounded),
          _field("Last Name", Icons.person_outline_rounded),
        ]),
        const SizedBox(height: 18),
        _row(isMobile, [
          _field("Date of Birth", Icons.cake_rounded, hint: "DD / MM / YYYY"),
          _dropdown(
            "Gender",
            Icons.wc_rounded,
            _genders,
            _selectedGender,
            (v) => setState(() => _selectedGender = v!),
          ),
        ]),
        const SizedBox(height: 18),
        _field(
          "Email Address",
          Icons.alternate_email_rounded,
          hint: "applicant@example.com",
        ),
        const SizedBox(height: 18),
        _row(isMobile, [
          _field(
            "Mobile Number",
            Icons.phone_android_rounded,
            hint: "+91 9999 999 999",
          ),
          _field("Alternate Mobile", Icons.phone_outlined, hint: "Optional"),
        ]),
        const SizedBox(height: 18),
        _field(
          "Full Address",
          Icons.location_on_rounded,
          hint: "Street, City, State, PIN Code",
        ),
        const SizedBox(height: 18),
        _row(isMobile, [
          _field("City", Icons.location_city_rounded),
          _field("State", Icons.map_rounded),
          _field("PIN Code", Icons.pin_drop_rounded, hint: "6-digit"),
        ]),
      ],
    );
  }

  Widget _stepAcademic({required double width, required Key key}) {
    bool isMobile = width < 700;
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          "Academic Information",
          "Previous education & qualification scores",
          Icons.menu_book_rounded,
        ),
        const SizedBox(height: 30),
        _dropdown(
          "Highest Qualification",
          Icons.school_rounded,
          _qualifications,
          _selectedQualification,
          (v) => setState(() => _selectedQualification = v!),
        ),
        const SizedBox(height: 18),
        _row(isMobile, [
          _field(
            "Institution Name",
            Icons.account_balance_rounded,
            hint: "Previous school/college",
          ),
          _field("Board / University", Icons.corporate_fare_rounded),
        ]),
        const SizedBox(height: 18),
        _row(isMobile, [
          _field(
            "Percentage / CGPA",
            Icons.percent_rounded,
            hint: "e.g. 92.4 or 8.5",
          ),
          _field(
            "Year of Passing",
            Icons.calendar_today_rounded,
            hint: "e.g. 2023",
          ),
        ]),
        const SizedBox(height: 18),
        _row(isMobile, [
          _field("Subject 1 Marks", Icons.book_rounded),
          _field("Subject 2 Marks", Icons.book_rounded),
          _field("Subject 3 Marks", Icons.book_rounded),
        ]),
        const SizedBox(height: 18),
        _field(
          "Entrance Exam Score (if any)",
          Icons.assignment_rounded,
          hint: "e.g. JEE Main 85 percentile",
        ),
      ],
    );
  }

  Widget _stepProgram({required double width, required Key key}) {
    bool isMobile = width < 700;
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          "Program Selection",
          "Choose the course and intake session",
          Icons.library_books_rounded,
        ),
        const SizedBox(height: 30),
        GridView.count(
          crossAxisCount: width < 600 ? 1 : (width < 900 ? 2 : 3),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: width < 600 ? 1.8 : 2.2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: _programs.map((p) {
            final sel = _selectedProgram == p;
            return GestureDetector(
              onTap: () => setState(() => _selectedProgram = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primaryRed : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: sel ? AppColors.primaryRed : Colors.grey.shade200,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: sel
                          ? AppColors.primaryRed.withValues(alpha: 0.22)
                          : Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: sel ? Colors.white : AppColors.primaryRed,
                      size: 18,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: sel ? Colors.white : Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 22),
        _row(isMobile, [
          _dropdown(
            "Session Year",
            Icons.event_rounded,
            _sessions,
            _selectedSession,
            (v) => setState(() => _selectedSession = v!),
          ),
          _dropdown(
            "Category",
            Icons.category_rounded,
            _categories,
            _selectedCategory,
            (v) => setState(() => _selectedCategory = v!),
          ),
        ]),
        const SizedBox(height: 18),
        _field(
          "Statement of Purpose (Why this program?)",
          Icons.edit_note_rounded,
          hint: "Brief statement...",
        ),
      ],
    );
  }

  Widget _stepDocuments({required double width, required Key key}) {
    final docs = [
      {
        "name": "10th Marksheet",
        "icon": Icons.description_rounded,
        "color": const Color(0xFF4F46E5),
      },
      {
        "name": "12th Marksheet",
        "icon": Icons.description_rounded,
        "color": const Color(0xFF0891B2),
      },
      {
        "name": "Transfer Certificate",
        "icon": Icons.folder_rounded,
        "color": const Color(0xFF7C3AED),
      },
      {
        "name": "Aadhar Card",
        "icon": Icons.badge_rounded,
        "color": AppColors.primaryRed,
      },
      {
        "name": "Passport Photo",
        "icon": Icons.photo_camera_rounded,
        "color": const Color(0xFF059669),
      },
      {
        "name": "Entrance Score Card",
        "icon": Icons.assignment_rounded,
        "color": const Color(0xFFD97706),
      },
    ];
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          "Document Upload",
          "Attach all required scanned documents (PDF/JPG)",
          Icons.upload_file_rounded,
        ),
        const SizedBox(height: 30),
        GridView.count(
          crossAxisCount: width < 600 ? 1 : (width < 900 ? 2 : 3),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: width < 600 ? 1.8 : 1.5,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: docs.map((d) {
            final color = d['color'] as Color;
            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(d['icon'] as IconData, color: color, size: 22),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      d['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Tap to Upload",
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "All documents must be clearly scanned. Files should be below 2MB each in PDF or JPG format.",
                  style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // ── NAV BAR ──
  Widget _buildNavBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 48,
        vertical: isMobile ? 14 : 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Row(
        children: [
          if (_step > 0)
            OutlinedButton(
              onPressed: () => setState(() => _step--),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300, width: 2),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 12 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text("Previous", style: TextStyle(color: Colors.black)),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              if (_step < _stepLabels.length - 1) {
                setState(() => _step++);
              } else {
                _saveApplication();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 32 : 48,
                vertical: isMobile ? 12 : 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: Text(
              _step < _stepLabels.length - 1 ? "Next Step" : "Submit",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientBtn(IconData icon, String label, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isSaving ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        icon: _isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(icon, color: Colors.white, size: 17),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ── HELPERS ──
  Widget _stepHeader(String title, String sub, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.titleStyle.copyWith(fontSize: 24)),
              Text(
                sub,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _row(bool isMobile, List<Widget> children) {
    if (isMobile) {
      return Column(
        children: children
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: c,
                ))
            .toList(),
      );
    }
    return Row(
      children: children
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: c,
                ),
              ))
          .toList(),
    );
  }

  Widget _field(
    String label,
    IconData icon, {
    String? hint,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint ?? "Enter $label",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: Icon(icon, color: AppColors.primaryRed, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: Colors.grey.shade100),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: Colors.grey.shade100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
              ),
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

  Widget _dropdown(
    String label,
    IconData icon,
    List<String> items,
    String value,
    Function(String?) onChange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryRed, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                    onChanged: onChange,
                    items: items
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveApplication() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Application submitted successfully!")),
      );
    }
  }
}
