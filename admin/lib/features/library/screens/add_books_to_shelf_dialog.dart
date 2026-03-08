import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddBooksToShelfDialog extends StatefulWidget {
  final String shelfName;
  const AddBooksToShelfDialog({super.key, required this.shelfName});

  @override
  State<AddBooksToShelfDialog> createState() => _AddBooksToShelfDialogState();
}

class _AddBooksToShelfDialogState extends State<AddBooksToShelfDialog> {
  String _searchQuery = '';
  final List<String> _selectedBooks = [];
  
  final List<Map<String, dynamic>> _dummyBooks = [
    {"id": "B001", "title": "Clean Code", "author": "Robert C. Martin", "isbn": "978-0132350884"},
    {"id": "B002", "title": "Design Patterns", "author": "Erich Gamma", "isbn": "978-0201633610"},
    {"id": "B003", "title": "Introduction to Algorithms", "author": "Thomas H. Cormen", "isbn": "978-0262033848"},
    {"id": "B004", "title": "The Pragmatic Programmer", "author": "Andrew Hunt", "isbn": "978-0135957059"},
    {"id": "B005", "title": "Head First Design Patterns", "author": "Eric Freeman", "isbn": "978-0596007126"},
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    
    final filteredCards = _dummyBooks.where((b) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return b['title'].toLowerCase().contains(q) || b['author'].toLowerCase().contains(q) || b['isbn'].toLowerCase().contains(q);
    }).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Container(
        width: 600,
        height: 700,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                itemCount: filteredCards.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final book = filteredCards[index];
                  final isSelected = _selectedBooks.contains(book['id']);
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedBooks.remove(book['id']);
                        } else {
                          _selectedBooks.add(book['id']);
                        }
                      });
                    },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade300),
                      ),
                      child: isSelected 
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                        : const Icon(Icons.book_rounded, color: Colors.grey, size: 20),
                    ),
                    title: Text(book['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                    subtitle: Text("${book['author']} • ISBN: ${book['isbn']}", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  );
                },
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).scaleXY(begin: 0.95);
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Books to '${widget.shelfName}'", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text("Search and select multiple books to allocate them to this shelf.", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, color: Colors.black87),
            splashRadius: 24,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: "Search books by title, author, or ISBN...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${_selectedBooks.length} Books Selected", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF4F46E5))),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
                child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _selectedBooks.isNotEmpty ? () => Navigator.pop(context) : null,
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                label: const Text("Allocate Books", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
