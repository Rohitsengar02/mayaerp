import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LabInventoryScreen extends StatefulWidget {
  const LabInventoryScreen({super.key});

  @override
  State<LabInventoryScreen> createState() => _LabInventoryScreenState();
}

class _LabInventoryScreenState extends State<LabInventoryScreen> {
  final List<Map<String, dynamic>> _inventory = [
    {"id": "INV-001", "name": "Compound Microscope", "category": "Equipment", "quantity": 15, "lab": "Chemistry Lab Main", "status": "Good"},
    {"id": "INV-002", "name": "Digital Oscilloscope", "category": "Electronics", "quantity": 8, "lab": "Physics Electronics Lab", "status": "Needs Repair"},
    {"id": "INV-003", "name": "Arduino Uno R3", "category": "Microcontroller", "quantity": 40, "lab": "Robotics & AI Space", "status": "Good"},
    {"id": "INV-004", "name": "Sulfuric Acid (500ml)", "category": "Chemical", "quantity": 3, "lab": "Chemistry Lab Main", "status": "Low Stock"},
    {"id": "INV-005", "name": "Dell OptiPlex Desktop", "category": "Computer", "quantity": 60, "lab": "Computer Science Lab 1", "status": "Good"},
  ];

  void _showAddEditItemDialog([Map<String, dynamic>? item]) {
    final isEditing = item != null;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(isEditing ? "Edit Inventory Item" : "Add Inventory Item", style: const TextStyle(fontWeight: FontWeight.w900)),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField("Item Name", initialValue: item?["name"]),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Quantity", initialValue: item?["quantity"]?.toString())),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: item?["category"] ?? "Equipment",
                          decoration: InputDecoration(
                            labelText: "Category",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          items: ["Equipment", "Electronics", "Microcontroller", "Chemical", "Computer", "Consumable"]
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: item?["lab"] ?? "Chemistry Lab Main",
                    decoration: InputDecoration(
                      labelText: "Assign to Laboratory",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    items: ["Chemistry Lab Main", "Physics Electronics Lab", "Robotics & AI Space", "Computer Science Lab 1"]
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: item?["status"] ?? "Good",
                    decoration: InputDecoration(
                      labelText: "Condition / Status",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    items: ["Good", "Needs Repair", "Low Stock", "Damaged", "Lost"]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(isEditing ? "Save Item" : "Add Item", style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, {String? initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Inventory Management", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    Text("Track, update, and manage lab equipment & consumables.", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddEditItemDialog(),
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: const Text("Add Item", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ).animate().fadeIn().slideY(begin: -0.1),
            const SizedBox(height: 32),

            // Top Filters Bar
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search item name or ID...",
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      hintText: "Filter Lab",
                    ),
                    items: const [],
                    onChanged: (val) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      hintText: "Filter Status",
                    ),
                    items: const [],
                    onChanged: (val) {},
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 24),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.deepPurple.shade50),
                      dataRowMinHeight: 70,
                      dataRowMaxHeight: 70,
                      columns: const [
                        DataColumn(label: Text("ITEM ID", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                        DataColumn(label: Text("NAME", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                        DataColumn(label: Text("CATEGORY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                        DataColumn(label: Text("LABORATORY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                        DataColumn(label: Text("QTY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                        DataColumn(label: Text("STATUS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                        DataColumn(label: Text("ACTIONS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                      ],
                      rows: _inventory.map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item["id"], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600))),
                          DataCell(Text(item["name"], style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(item["category"])),
                          DataCell(Text(item["lab"], style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700))),
                          DataCell(Text(item["quantity"].toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
                          DataCell(_buildStatusBadge(item["status"])),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, color: Colors.blue),
                                  onPressed: () => _showAddEditItemDialog(item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_rounded, color: Colors.red),
                                  onPressed: () {},
                                ),
                              ],
                            )
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = Colors.green.shade50;
    Color fg = Colors.green.shade700;
    if (status == "Low Stock") {
      bg = Colors.orange.shade50; fg = Colors.orange.shade800;
    } else if (status == "Needs Repair" || status == "Damaged") {
      bg = Colors.red.shade50; fg = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
