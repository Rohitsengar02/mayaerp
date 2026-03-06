import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';

class CreateBranchScreen extends StatefulWidget {
  const CreateBranchScreen({super.key});

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left Sidebar (Guide)
          Container(
            width: 450,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFF8F6F6), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: const Border(right: BorderSide(color: Color(0xFFF1F1F1))),
            ),
            padding: const EdgeInsets.all(60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                ),
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.business_center_rounded,
                    color: AppColors.primaryRed,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "ESTABLISH NEW\nBRANCH",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Provide structural details to create a new institutional branch. This will serve as the parent node for upcoming departments and courses.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 60),
                _guideStep(
                  "01",
                  "Branch Identity",
                  "Define the unique code and official name.",
                ),
                _guideStep(
                  "02",
                  "Dean Allocation",
                  "Assign a primary administrator for this branch.",
                ),
                _guideStep(
                  "03",
                  "Operational Capacity",
                  "Specify initial course and student limits.",
                ),
              ],
            ),
          ),

          // Main Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 80,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Section 1: Identity & Parameters",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            "Branch Code (e.g., SOE)",
                            Icons.qr_code_rounded,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: _textField(
                            "Official Branch Name",
                            Icons.business_rounded,
                          ),
                        ),
                      ],
                    ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),
                    const SizedBox(height: 60),
                    const Text(
                      "Section 2: Leadership & Coordination",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 32),
                    _textField(
                      "Primary Dean / HOD Name",
                      Icons.person_pin_rounded,
                    ).animate(delay: 500.ms).fadeIn(),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            "Contact Email",
                            Icons.email_outlined,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: _textField(
                            "Contact Ext.",
                            Icons.phone_rounded,
                          ),
                        ),
                      ],
                    ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.1),
                    const SizedBox(height: 100),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "PROVISION BRANCH",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _guideStep(String num, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            num,
            style: TextStyle(
              color: AppColors.primaryRed.withOpacity(0.3),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.01)),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(24),
        ),
      ),
    );
  }
}
