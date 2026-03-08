import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'add_book_screen.dart';

class BookManagementScreen extends StatefulWidget {
  const BookManagementScreen({super.key});

  @override
  State<BookManagementScreen> createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  String _searchQuery = "";

  final List<Map<String, dynamic>> _books = [
    {
      "cover": "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=100",
      "title": "Clean Code",
      "author": "Robert C. Martin",
      "category": "Computer Science",
      "isbn": "978-0132350884",
      "total": 12,
      "available": 5,
      "shelf": "CS-A1",
      "status": "Available",
    },
    {
      "cover": "https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=100",
      "title": "The Pragmatic Programmer",
      "author": "Andrew Hunt",
      "category": "Computer Science",
      "isbn": "978-0135957059",
      "total": 8,
      "available": 0,
      "shelf": "CS-A2",
      "status": "Out of Stock",
    },
    {
      "cover": "https://images.unsplash.com/photo-1629906429381-874b35ef586d?w=100",
      "title": "Introduction to Algorithms",
      "author": "Thomas H. Cormen",
      "category": "Mathematics",
      "isbn": "978-0262033848",
      "total": 5,
      "available": 2,
      "shelf": "MA-B1",
      "status": "Available",
    },
    {
      "cover": "https://images.unsplash.com/photo-1524311583145-d5594bd6ffbb?w=100",
      "title": "To Kill a Mockingbird",
      "author": "Harper Lee",
      "category": "Literature",
      "isbn": "978-0061120084",
      "total": 20,
      "available": 18,
      "shelf": "LI-C3",
      "status": "Available",
    },
    {
      "cover": "https://images.unsplash.com/photo-1589998059171-989d887dda6e?w=100",
      "title": "Sapiens",
      "author": "Yuval Noah Harari",
      "category": "History",
      "isbn": "978-0062316097",
      "total": 15,
      "available": 7,
      "shelf": "HI-D1",
      "status": "Available",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 850;
        bool isTablet = constraints.maxWidth >= 850 && constraints.maxWidth < 1100;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile),
                const SizedBox(height: 32),
                _buildFiltersAndActions(isMobile, isTablet),
                const SizedBox(height: 24),
                _buildBooksTable(isMobile, isTablet),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Books Management",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Manage library book catalog, view details, edit, and track stock.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile)
          Row(
            children: [
              _headerBtn("Export Books", Icons.download_rounded, Colors.white, Colors.black87, () {}),
              const SizedBox(width: 12),
              _headerBtn("Import (CSV)", Icons.upload_file_rounded, Colors.white, Colors.black87, () {}),
              const SizedBox(width: 12),
              _headerBtn("Add New Book", Icons.add_rounded, const Color(0xFF4F46E5), Colors.white, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddBookScreen()),
                );
              }),
            ],
          ),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _headerBtn(String label, IconData icon, Color bg, Color fg, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bg == Colors.white ? Colors.grey.shade300 : Colors.transparent),
        boxShadow: bg != Colors.white
            ? [BoxShadow(color: bg.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, color: fg, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersAndActions(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        children: [
          _searchBar(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _filterDropdown("Category")),
              const SizedBox(width: 12),
              Expanded(child: _filterDropdown("Availability")),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _headerBtn("Add New Book", Icons.add_rounded, const Color(0xFF4F46E5), Colors.white, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBookScreen()),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _headerBtn("Export", Icons.download_rounded, Colors.white, Colors.black87, () {})),
              const SizedBox(width: 12),
              Expanded(child: _headerBtn("Import", Icons.upload_file_rounded, Colors.white, Colors.black87, () {})),
            ],
          ),
        ],
      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
    }
    return Row(
      children: [
        Expanded(flex: 3, child: _searchBar()),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: _filterDropdown("Category")),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: _filterDropdown("Availability")),
      ],
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: "Search by title, author, isbn...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _filterDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600)),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
          items: const [],
          onChanged: (v) {},
        ),
      ),
    );
  }

  Widget _buildBooksTable(bool isMobile, bool isTablet) {
    final filtered = _books.where((b) {
      final q = _searchQuery.toLowerCase();
      return b['title'].toLowerCase().contains(q) ||
          b['author'].toLowerCase().contains(q) ||
          b['isbn'].toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text("BOOK", style: _headerStyle())),
                Expanded(flex: 2, child: Text("CATEGORY", style: _headerStyle())),
                Expanded(flex: 2, child: Text("COPIES (TOTAL/AVAIL)", style: _headerStyle())),
                Expanded(flex: 2, child: Text("SHELF", style: _headerStyle())),
                Expanded(flex: 2, child: Text("STATUS", style: _headerStyle())),
                SizedBox(width: 120, child: Text("ACTIONS", style: _headerStyle(), textAlign: TextAlign.center)),
              ],
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final book = filtered[index];
            return Container(
              margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: isMobile
                  ? _buildMobileBookCard(book)
                  : _buildDesktopBookRow(book),
            ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05, curve: Curves.easeOutQuad);
          },
        ),
      ],
    );
  }

  TextStyle _headerStyle() => TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500, fontSize: 12, letterSpacing: 0.5);

  Widget _buildDesktopBookRow(Map<String, dynamic> book) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book['cover'],
                  width: 48,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 48,
                    height: 64,
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.book_rounded, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      book['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book['author'],
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "ISBN: ${book['isbn']}",
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.transparent),
              ),
              child: Text(
                book['category'],
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${book['available']}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: book['available'] > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                  Text(" available", style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                "of ${book['total']} total",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.library_books_rounded, size: 16, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(width: 12),
              Text(book['shelf'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: _buildStatusBadge(book['status']))),
        SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.visibility_rounded, color: Colors.blue, size: 18), tooltip: "View Details", splashRadius: 20, constraints: const BoxConstraints(), padding: const EdgeInsets.all(8)),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded, color: Colors.orange, size: 18), tooltip: "Edit Book", splashRadius: 20, constraints: const BoxConstraints(), padding: const EdgeInsets.all(8)),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(color: const Color(0xFF4F46E5).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.storage_rounded, color: Color(0xFF4F46E5), size: 18), tooltip: "Allocate Shelf", splashRadius: 20, constraints: const BoxConstraints(), padding: const EdgeInsets.all(8)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBookCard(Map<String, dynamic> book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book['cover'],
                width: 60,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 80,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.book_rounded, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          book['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                        ),
                      ),
                      _buildStatusBadge(book['status']),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book['author'],
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ISBN: ${book['isbn']} • Shelf: ${book['shelf']}",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    book['category'],
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${book['available']} / ${book['total']} Available",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: book['available'] > 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.visibility_rounded, color: Colors.blue, size: 16), splashRadius: 20, constraints: const BoxConstraints(), padding: const EdgeInsets.all(6)),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded, color: Colors.orange, size: 16), splashRadius: 20, constraints: const BoxConstraints(), padding: const EdgeInsets.all(6)),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(color: const Color(0xFF4F46E5).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.storage_rounded, color: Color(0xFF4F46E5), size: 16), tooltip: "Allocate Shelf", splashRadius: 20, constraints: const BoxConstraints(), padding: const EdgeInsets.all(6)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final isAvailable = status == 'Available';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isAvailable ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isAvailable ? const Color(0xFF10B981) : const Color(0xFFEF4444),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
