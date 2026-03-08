import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StaffNoticesScreen extends StatefulWidget {
  const StaffNoticesScreen({super.key});

  @override
  State<StaffNoticesScreen> createState() => _StaffNoticesScreenState();
}

class _StaffNoticesScreenState extends State<StaffNoticesScreen> {
  String? _targetClass;
  final List<String> _classes = ["All Classes", "B.Tech CS 2nd Yr", "B.Tech IT 3rd Yr", "MCA 1st Yr"];

  final List<Map<String, dynamic>> _notices = [
    {"title": "Upcoming Lab Assignment", "desc": "Please complete the data structures assignment before Friday.", "class": "B.Tech CS 2nd Yr", "date": "10 Apr 2026", "color": Colors.blue},
    {"title": "Guest Lecture Postponed", "desc": "The scheduled guest lecture on AI is moved to next Wednesday.", "class": "All Classes", "date": "08 Apr 2026", "color": Colors.orange},
  ];

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
                ? Column(children: [_buildForm(), const SizedBox(height: 32), _buildNoticesList()])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildForm()),
                      const SizedBox(width: 32),
                      Expanded(flex: 2, child: _buildNoticesList()),
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
        const Text("Notices & Communication", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -1)),
        const SizedBox(height: 4),
        Text("Publish notices, announcements, and assignments for your classes.", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Create Notice", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1E293B))),
          const SizedBox(height: 24),
          _textField("Title", "Enter notice title..."),
          const SizedBox(height: 20),
          _textField("Description", "Enter detailed notice content...", maxLines: 4),
          const SizedBox(height: 20),
          _dropdown("Target Class", _classes, _targetClass, (v) => setState(() => _targetClass = v)),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: const Row(children: [Icon(Icons.attach_file_rounded, color: Colors.grey, size: 20), SizedBox(width: 8), Text("Attach File (Optional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey))])),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              label: const Text("Publish Notice", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.schedule_rounded, color: Colors.black87, size: 18),
              label: const Text("Schedule for Later", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: Colors.grey.shade300)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY();
  }

  Widget _textField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF10B981))),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, List<String> items, String? val, Function(String?) onCh) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: val,
              isExpanded: true,
              hint: Text("Select $label", style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onCh,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoticesList() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recent Notices", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1E293B))),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _notices.length,
            separatorBuilder: (context, index) => const Divider(height: 32),
            itemBuilder: (context, index) {
              final n = _notices[index];
              final color = n['color'] as Color;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(n['class'], style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11))),
                      Text(n['date'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(n['title'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E293B))),
                  const SizedBox(height: 8),
                  Text(n['desc'], style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.visibility_rounded, size: 16, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text("142 views", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                      const Spacer(),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints(), splashRadius: 20),
                      const SizedBox(width: 16),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints(), splashRadius: 20),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
  }
}
