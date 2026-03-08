import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<Map<String, dynamic>> _transactions = [
    {
      "id": "TXN-001",
      "date": "Mar 06, 2026",
      "time": "10:30 AM",
      "student": "Alice Smith (MIT-2024-001)",
      "type": "Issue",
      "desc": "Issued 'Clean Code'",
      "status": "Success",
    },
    {
      "id": "TXN-002",
      "date": "Mar 05, 2026",
      "time": "02:15 PM",
      "student": "Bob Jones (MIT-2023-015)",
      "type": "Fine Payment",
      "desc": "Paid ₹ 120 via UPI",
      "status": "Success",
    },
    {
      "id": "TXN-003",
      "date": "Mar 04, 2026",
      "time": "11:45 AM",
      "student": "Charlie Brown (MIT-2022-042)",
      "type": "Return",
      "desc": "Returned 'To Kill a Mockingbird'",
      "status": "Success",
    },
    {
      "id": "TXN-004",
      "date": "Mar 04, 2026",
      "time": "09:00 AM",
      "student": "Eve Davis (MIT-2024-089)",
      "type": "Penalty",
      "desc": "Lost Book Penalty ('Design Patterns')",
      "status": "Pending",
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
            _buildTransactionsList(isMobile),
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
                "Transactions Log",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "History of all issues, returns, and fine payments.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildTransactionsList(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _transactions.length,
          itemBuilder: (context, index) {
            final t = _transactions[index];
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
              child: isMobile ? _buildMobileRow(t) : _buildDesktopRow(t),
            ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05);
          },
        ),
      ],
    );
  }

  Widget _buildDesktopRow(Map<String, dynamic> t) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t['date'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
              Text(t['time'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
        Expanded(flex: 1, child: _typeBadge(t['type'])),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t['desc'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
              Text(t['student'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ),
        Expanded(flex: 1, child: Text(t['id'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500, fontSize: 12))),
        Expanded(flex: 1, child: Align(alignment: Alignment.centerLeft, child: _statusBadge(t['status']))),
      ],
    );
  }

  Widget _buildMobileRow(Map<String, dynamic> t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _typeBadge(t['type']),
            _statusBadge(t['status']),
          ],
        ),
        const SizedBox(height: 12),
        Text(t['desc'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
        const SizedBox(height: 4),
        Text(t['student'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${t['date']} • ${t['time']}", style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold)),
            Text(t['id'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade400, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _typeBadge(String type) {
    Color bg, fg;
    IconData icon;
    switch (type) {
      case 'Issue':
        bg = Colors.blue.withOpacity(0.1);
        fg = Colors.blue;
        icon = Icons.call_made_rounded;
        break;
      case 'Return':
        bg = Colors.green.withOpacity(0.1);
        fg = Colors.green;
        icon = Icons.call_received_rounded;
        break;
      case 'Fine Payment':
        bg = Colors.orange.withOpacity(0.1);
        fg = Colors.orange;
        icon = Icons.payments_rounded;
        break;
      default:
        bg = Colors.red.withOpacity(0.1);
        fg = Colors.red;
        icon = Icons.warning_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(type, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: fg)),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    bool success = status == 'Success';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: (success ? Colors.green : Colors.orange).withOpacity(0.1), borderRadius: BorderRadius.circular(100)),
      child: Text(status.toUpperCase(), style: TextStyle(color: success ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
