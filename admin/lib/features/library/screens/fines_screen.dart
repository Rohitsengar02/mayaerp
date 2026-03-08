import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FinesScreen extends StatefulWidget {
  const FinesScreen({super.key});

  @override
  State<FinesScreen> createState() => _FinesScreenState();
}

class _FinesScreenState extends State<FinesScreen> {
  final List<Map<String, dynamic>> _fines = [
    {
      "student": "Bob Jones",
      "id": "MIT-2023-015",
      "book": "Clean Code",
      "days": 12,
      "amount": "₹ 120",
      "status": "Unpaid",
      "date": "Feb 25, 2026",
    },
    {
      "student": "Eve Davis",
      "id": "MIT-2024-089",
      "book": "Design Patterns",
      "days": 5,
      "amount": "₹ 50",
      "status": "Unpaid",
      "date": "Mar 01, 2026",
    },
    {
      "student": "Alice Smith",
      "id": "MIT-2024-001",
      "book": "Introduction to Algorithms",
      "days": 2,
      "amount": "₹ 20",
      "status": "Paid",
      "date": "Feb 20, 2026",
    },
  ];

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
            _buildStatsRow(isMobile),
            const SizedBox(height: 32),
            _buildFinesList(isMobile),
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
                "Fines & Penalties",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Manage student dues, overdues, and lost book penalties.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildStatsRow(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _statCard("Total Collected", "₹ 2,450", Icons.check_circle_outline, Colors.green, isMobile),
        _statCard("Pending Dues", "₹ 170", Icons.warning_amber_rounded, Colors.orange, isMobile),
        _statCard("Overdue Books", "12", Icons.book_rounded, Colors.red, isMobile),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _statCard(String title, String value, IconData icon, Color color, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13))),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildFinesList(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(flex: 2, child: _headerText("STUDENT")),
                Expanded(flex: 2, child: _headerText("BOOK")),
                Expanded(flex: 1, child: _headerText("OVERDUE")),
                Expanded(flex: 1, child: _headerText("FINE")),
                Expanded(flex: 1, child: _headerText("STATUS")),
                SizedBox(width: 100, child: _headerText("ACTIONS", align: TextAlign.center)),
              ],
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _fines.length,
          itemBuilder: (context, index) {
            final f = _fines[index];
            return Container(
              margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: isMobile ? _buildMobileFineRow(f) : _buildDesktopFineRow(f),
            ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05);
          },
        ),
      ],
    );
  }

  Text _headerText(String t, {TextAlign? align}) => Text(t, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500, fontSize: 12, letterSpacing: 0.5), textAlign: align);

  Widget _buildDesktopFineRow(Map<String, dynamic> f) {
    bool unpaid = f['status'] == 'Unpaid';
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(f['student'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(f['id'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(f['book'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
              Text("Due: ${f['date']}", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
        Expanded(flex: 1, child: Text("${f['days']} Days", style: TextStyle(color: unpaid ? Colors.red : Colors.grey, fontWeight: FontWeight.bold))),
        Expanded(flex: 1, child: Text(f['amount'], style: TextStyle(color: unpaid ? Colors.orange : Colors.green, fontWeight: FontWeight.w900, fontSize: 16))),
        Expanded(flex: 1, child: Align(alignment: Alignment.centerLeft, child: _statusBadge(f['status']))),
        SizedBox(
          width: 100,
          child: unpaid
              ? Flexible(
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text("Pay", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
              )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildMobileFineRow(Map<String, dynamic> f) {
    bool unpaid = f['status'] == 'Unpaid';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(f['student'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
            _statusBadge(f['status']),
          ],
        ),
        Text(f['id'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.book_rounded, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Expanded(child: Text(f['book'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${f['days']} Days Overdue", style: TextStyle(color: unpaid ? Colors.red : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                Text(f['amount'], style: TextStyle(color: unpaid ? Colors.orange : Colors.green, fontWeight: FontWeight.w900, fontSize: 18)),
              ],
            ),
            if (unpaid)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text("Pay Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    bool unpaid = status == 'Unpaid';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: (unpaid ? Colors.red : Colors.green).withOpacity(0.1), borderRadius: BorderRadius.circular(100)),
      child: Text(status.toUpperCase(), style: TextStyle(color: unpaid ? Colors.red : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
