import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCategory;
  String? _selectedShelf;

  final List<String> _categories = [
    "Computer Science",
    "Mathematics",
    "Literature",
    "History",
    "Physics",
  ];

  final List<String> _shelves = [
    "CS-A1", "CS-A2", "MA-B1", "LI-C3", "HI-D1",
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 850;
        bool isTablet = constraints.maxWidth >= 850 && constraints.maxWidth < 1100;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
            title: const Text(
              "Add New Book",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (!isMobile)
                Padding(
                  padding: const EdgeInsets.only(right: 24.0, top: 10, bottom: 10),
                  child: _primaryActionBtn("Save Book", Icons.check_circle_outline, () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  }),
                )
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Form(
              key: _formKey,
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageUploader(),
                        const SizedBox(height: 24),
                        _buildFormFields(),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: _primaryActionBtn("Save Book", Icons.check_circle_outline, () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                            }
                          }, isMobile: true),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildImageUploader(),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 2,
                          child: _buildFormFields(),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageUploader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Book Cover",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Upload a high quality image of the book cover. Recommended size 400x600.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF4F46E5), size: 32),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Click to uplaod",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                      ),
                      const SizedBox(height: 4),
                      Text("PNG, JPG up to 5MB", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Book Information",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 24),
          _textField("Book Title", "Enter the title of the book", Icons.book_rounded),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _textField("Author", "Author's name", Icons.person_rounded)),
              const SizedBox(width: 20),
              Expanded(child: _textField("ISBN Number", "e.g. 978-0132350884", Icons.numbers_rounded)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _dropdown("Category", _categories, _selectedCategory, (v) => setState(() => _selectedCategory = v))),
              const SizedBox(width: 20),
              Expanded(child: _textField("Publisher", "Publisher name", Icons.business_rounded)),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),
          const Text(
            "Inventory Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _textField("Total Copies", "0", Icons.inventory_2_rounded, isNumber: true)),
              const SizedBox(width: 20),
              Expanded(child: _dropdown("Shelf Location", _shelves, _selectedShelf, (v) => setState(() => _selectedShelf = v))),
            ],
          ),
          const SizedBox(height: 20),
          _textField("Price (Optional)", "₹ 0.00", Icons.currency_rupee_rounded, isNumber: true),
          const SizedBox(height: 20),
          _textField("Description / Remarks", "Any additional notes about the book...", Icons.notes_rounded, maxLines: 3),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _textField(String label, String hint, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.grey.shade400, size: 20) : null,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4F46E5)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, List<String> items, String? val, Function(String?) onCh) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: val,
              isExpanded: true,
              hint: Text(
                "Select $label",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14))))
                  .toList(),
              onChanged: onCh,
            ),
          ),
        ),
      ],
    );
  }

  Widget _primaryActionBtn(String label, IconData icon, VoidCallback onTap, {bool isMobile = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: isMobile ? 16 : 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
