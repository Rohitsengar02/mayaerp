import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'create_shelf_screen.dart';
import 'add_books_to_shelf_dialog.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Map<String, dynamic>> _shelves = [
    {
      "name": "Shelf A1",
      "category": "Computer Science",
      "capacity": 200,
      "current": 145,
      "aisle": "A",
      "status": "Active",
    },
    {
      "name": "Shelf B2",
      "category": "Mathematics",
      "capacity": 150,
      "current": 140,
      "aisle": "B",
      "status": "Warning (Near Full)",
    },
    {
      "name": "Shelf C4",
      "category": "Literature",
      "capacity": 300,
      "current": 80,
      "aisle": "C",
      "status": "Active",
    },
    {
      "name": "Shelf D1",
      "category": "History",
      "capacity": 100,
      "current": 100,
      "aisle": "D",
      "status": "Full",
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
            _buildShelvesList(isMobile),
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
                "Book Shelves",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Manage library physical inventory, add new shelves, and categorize space.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        if (!isMobile)
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateShelfScreen()));
              },
              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              label: const Text("Create New Shelf", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds, color: Colors.white24),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildShelvesList(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateShelfScreen()));
                },
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                label: const Text("Create New Shelf", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds, color: Colors.white24),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: isMobile ? 2.2 : 1.4,
          ),
          itemCount: _shelves.length,
          itemBuilder: (context, index) {
            final s = _shelves[index];
            double fillRatio = s['current'] / s['capacity'];
            Color fillCol = fillRatio > 0.9 ? Colors.red : (fillRatio > 0.7 ? Colors.orange : Colors.green);

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.storage_rounded, color: Color(0xFF4F46E5), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s['name'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                              Text("Aisle ${s['aisle']}", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AddBooksToShelfDialog(shelfName: s['name']),
                              );
                            },
                            icon: const Icon(Icons.add_rounded, size: 16),
                            label: const Text("Add Books", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF4F46E5),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              backgroundColor: const Color(0xFF4F46E5).withOpacity(0.1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded, color: Colors.grey), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(s['category'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Capacity: ${s['current']} / ${s['capacity']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("${(fillRatio * 100).toInt()}%", style: TextStyle(fontWeight: FontWeight.w900, color: fillCol, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: fillRatio,
                      backgroundColor: Colors.grey.shade100,
                      color: fillCol,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (50 * index).ms).slideY(begin: 0.1);
          },
        ),
      ],
    );
  }
}
