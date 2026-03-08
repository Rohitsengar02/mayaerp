import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StaffProfileScreen extends StatelessWidget {
  const StaffProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile),
            const SizedBox(height: 32),
            isMobile
                ? Column(children: [_buildProfileCard(), const SizedBox(height: 32), _buildSettingsCard()])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildProfileCard()),
                      const SizedBox(width: 32),
                      Expanded(flex: 3, child: _buildSettingsCard()),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Profile & Settings", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -1)),
        const SizedBox(height: 4),
        Text("Manage your personal information and account settings.", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 5))]),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF10B981), width: 3)), child: const CircleAvatar(radius: 60, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=41'))),
                Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text("Dr. Sarah Jenkins", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
          const SizedBox(height: 4),
          Text("Associate Professor", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text("Computer Science Dept.", style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 12))),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          _profileInfoRow(Icons.email_rounded, "sarah.j@mayainstitute.edu"),
          const SizedBox(height: 16),
          _profileInfoRow(Icons.phone_rounded, "+1 (555) 123-4567"),
          const SizedBox(height: 16),
          _profileInfoRow(Icons.location_on_rounded, "Faculty Block B, Room 304"),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _profileInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 16),
        Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Account Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
          const SizedBox(height: 32),
          _settingsRow(Icons.lock_outline_rounded, "Change Password", "Update your account password"),
          const Divider(height: 32),
          _settingsRow(Icons.notifications_none_rounded, "Notifications", "Manage email and push notifications"),
          const Divider(height: 32),
          _settingsRow(Icons.security_rounded, "Two-Factor Authentication", "Add an extra layer of security"),
          const Divider(height: 32),
          _settingsRow(Icons.language_rounded, "Language Preference", "English (United States)"),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 18),
              label: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: Colors.red.shade200)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1);
  }

  Widget _settingsRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.grey.shade600, size: 24)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      ],
    );
  }
}
