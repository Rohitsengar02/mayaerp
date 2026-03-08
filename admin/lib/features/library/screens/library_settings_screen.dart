import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LibrarySettingsScreen extends StatefulWidget {
  const LibrarySettingsScreen({super.key});

  @override
  State<LibrarySettingsScreen> createState() => _LibrarySettingsScreenState();
}

class _LibrarySettingsScreenState extends State<LibrarySettingsScreen> {
  bool _autoReminders = true;
  bool _allowRenewals = false;
  bool _strictFine = true;

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile),
            const SizedBox(height: 32),
            isMobile ? Column(children: _buildSections()) : Row(crossAxisAlignment: CrossAxisAlignment.start, children: _buildSections().map((e) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 24), child: e))).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Library Settings",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -1),
              ),
              const SizedBox(height: 4),
              Text("Configure lending rules, fine rates, and system preferences.", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
            ],
          ),
        ),
        if (!isMobile)
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_rounded, color: Colors.white),
            label: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: const Color(0xFF4F46E5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  List<Widget> _buildSections() {
    return [
      _buildCard(
        "Lending Rules",
        Icons.rule_rounded,
        Colors.blue,
        [
          _textField("Max Books per Student", "e.g., 5"),
          _textField("Max Books per Faculty", "e.g., 10"),
          _textField("Issue Duration (Days)", "e.g., 14"),
          _switchRow("Allow Book Renewals", _allowRenewals, (v) => setState(() => _allowRenewals = v)),
        ],
      ),
      _buildCard(
        "Fine & Overdue",
        Icons.money_off_rounded,
        Colors.orange,
        [
          _textField("Fine Rate per Day (₹)", "e.g., 5"),
          _textField("Max Fine Limit (₹)", "e.g., 500"),
          _switchRow("Strict Fine Collection", _strictFine, (v) => setState(() => _strictFine = v)),
          _switchRow("Auto Overdue Reminders", _autoReminders, (v) => setState(() => _autoReminders = v)),
        ],
      ),
    ];
  }

  Widget _buildCard(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            ],
          ),
          const SizedBox(height: 24),
          ...children.map((e) => Padding(padding: const EdgeInsets.only(bottom: 16), child: e)),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }

  Widget _textField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF4F46E5),
        ),
      ],
    );
  }
}
