import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import 'create_bus_screen.dart';

class TransportManagementScreen extends StatefulWidget {
  const TransportManagementScreen({super.key});

  @override
  State<TransportManagementScreen> createState() =>
      _TransportManagementScreenState();
}

class _TransportManagementScreenState extends State<TransportManagementScreen> {
  final List<Map<String, dynamic>> _buses = [
    {
      "busNo": "BUS-001",
      "driver": "Rajesh Kumar",
      "conductor": "Amit Singh",
      "route": "Sector 15 -> Campus",
      "capacity": 40,
      "filled": 35,
      "status": "Active",
      "students": ["Student A", "Student B", "Student C"],
      "stops": ["Stop 1", "Stop 2", "Campus"],
    },
    {
      "busNo": "BUS-004",
      "driver": "Sohan Lal",
      "conductor": "Vikas Roy",
      "route": "Railway Station -> Campus",
      "capacity": 30,
      "filled": 30,
      "status": "Full",
      "students": ["Student D", "Student E"],
      "stops": ["Station Stop", "City Center", "Campus"],
    },
    {
      "busNo": "BUS-007",
      "driver": "Mohan Singh",
      "conductor": "Rahul Das",
      "route": "South Ext -> Campus",
      "capacity": 50,
      "filled": 12,
      "status": "Active",
      "students": ["Student F"],
      "stops": ["Ext Stop", "Market", "Campus"],
    },
  ];

  String _searchQuery = "";
  Map<String, dynamic>? _selectedBus;

  @override
  void initState() {
    super.initState();
    _selectedBus = _buses[0];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 1100;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F6F6),
          body: Row(
            children: [
              // Main Content
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildHeader(isMobile),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(isMobile ? 20 : 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFleetStats(isMobile),
                            SizedBox(height: isMobile ? 32 : 48),
                            _buildControls(isMobile),
                            const SizedBox(height: 24),
                            _buildBusGrid(isMobile),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Detail Sidebar (Desktop only)
              if (!isMobile && _selectedBus != null) _buildDetailSidebar(false),
            ],
          ),
          // Mobile Detail View (Overlay/Floating)
          floatingActionButton: isMobile && _selectedBus != null
              ? FloatingActionButton.extended(
                  onPressed: () => _showMobileDetails(context),
                  backgroundColor: Colors.black,
                  label: const Text("View Route Details"),
                  icon: const Icon(Icons.info_outline_rounded),
                )
              : null,
        );
      },
    );
  }

  void _showMobileDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(child: _buildDetailSidebar(true)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 16 : 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fleet Management",
                      style: AppTheme.titleStyle.copyWith(
                        fontSize: isMobile ? 20 : 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Manage institutional logistics, bus routes, and student occupancy",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateBusScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.directions_bus_rounded, size: 20),
                  label: const Text(
                    "Deploy Bus",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateBusScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.directions_bus_rounded, size: 18),
                label: const Text(
                  "Deploy New Bus",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFleetStats(bool isMobile) {
    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _statCard(
            "TOTAL BUSES",
            _buses.length.toString(),
            Icons.directions_bus_filled_rounded,
            "Fleet size",
            isMobile: true,
          ),
          _statCard(
            "ON ROUTE",
            "12",
            Icons.route_rounded,
            "Active now",
            isMobile: true,
          ),
          _statCard(
            "STUDENTS",
            "840",
            Icons.people_outline_rounded,
            "Commuters",
            isMobile: true,
          ),
          _statCard(
            "MAINTENANCE",
            "02",
            Icons.build_circle_rounded,
            "Service",
            isMobile: true,
          ),
        ],
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
    }
    return Row(
      children: [
        _statCard(
          "TOTAL BUSES",
          _buses.length.toString(),
          Icons.directions_bus_filled_rounded,
          "Fleet size",
        ),
        const SizedBox(width: 24),
        _statCard("ON ROUTE", "12", Icons.route_rounded, "Currently active"),
        const SizedBox(width: 24),
        _statCard(
          "STUDENTS",
          "840",
          Icons.people_outline_rounded,
          "Daily commuters",
        ),
        const SizedBox(width: 24),
        _statCard(
          "MAINTENANCE",
          "02",
          Icons.build_circle_rounded,
          "Under service",
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _statCard(
    String label,
    String value,
    IconData icon,
    String sub, {
    bool isMobile = false,
  }) {
    Widget content = Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryRed,
              size: isMobile ? 18 : 20,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 20),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );

    return isMobile ? content : Expanded(child: content);
  }

  Widget _buildControls(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: "Search Fleet...",
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
                icon: Icon(Icons.search_rounded, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterBtn("All Buses", true),
                const SizedBox(width: 8),
                _filterBtn("Active", false),
                const SizedBox(width: 8),
                _filterBtn("Service", false),
              ],
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: "Search Bus No, Driver or Route...",
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
                icon: Icon(Icons.search_rounded, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _filterBtn("All Buses", true),
        const SizedBox(width: 12),
        _filterBtn("Active", false),
        const SizedBox(width: 12),
        _filterBtn("Service", false),
      ],
    );
  }

  Widget _filterBtn(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: active ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBusGrid(bool isMobile) {
    final filtered = _buses
        .where(
          (b) =>
              b['busNo'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              b['driver'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              b['route'].toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        mainAxisSpacing: isMobile ? 16 : 24,
        crossAxisSpacing: isMobile ? 16 : 24,
        childAspectRatio: isMobile ? 1.4 : 1.6,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) => _busCard(filtered[index], isMobile),
    );
  }

  Widget _busCard(Map<String, dynamic> data, bool isMobile) {
    bool isSelected = _selectedBus?['busNo'] == data['busNo'];
    double occupancy = data['filled'] / data['capacity'];

    return InkWell(
          onTap: () => setState(() => _selectedBus = data),
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? AppColors.primaryRed : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.directions_bus_rounded, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['busNo'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            data['route'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _statusChip(data['status']),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _personInfo("Driver", data['driver']),
                    _personInfo("Conductor", data['conductor']),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Occupancy",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "${data['filled']}/${data['capacity']} seats",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: occupancy,
                        backgroundColor: Colors.grey.shade100,
                        color: occupancy > 0.9
                            ? Colors.red
                            : AppColors.primaryRed,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (100 * _buses.indexOf(data)).ms)
        .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _statusChip(String status) {
    Color c = status == "Full" ? Colors.orange : Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: c,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _personInfo(String label, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDetailSidebar(bool isMobile) {
    final bus = _selectedBus!;
    return Container(
      width: isMobile ? double.infinity : 400,
      decoration: BoxDecoration(
        color: Colors.white,
        border: isMobile
            ? null
            : const Border(left: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bus Logistics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (!isMobile)
                        IconButton(
                          onPressed: () => setState(() => _selectedBus = null),
                          icon: const Icon(Icons.close_rounded),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Route Visualizer
                  const Text(
                    "ROUTE SCHEDULE",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(
                    bus['stops'].length,
                    (i) => _stopItem(
                      bus['stops'][i],
                      i == bus['stops'].length - 1,
                    ),
                  ),

                  const SizedBox(height: 48),
                  const Text(
                    "STUDENT ROSTER",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(
                    bus['students'].length,
                    (i) => _studentCard(bus['students'][i], i),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showAddStudentsModal(context, bus),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text("Assign More Students"),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideX(
      begin: isMobile ? 0.0 : 1.0,
      end: 0.0,
      duration: 400.ms,
      curve: Curves.easeOutQuint,
    );
  }

  Widget _stopItem(String name, bool isLast) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRed.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: AppColors.primaryRed.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _studentCard(String name, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Dept: Computer Science",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.remove_circle_outline_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddStudentsModal(BuildContext context, Map<String, dynamic> bus) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Assign Students",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F6F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Enter Name or ID...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search_rounded, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, i) {
                  String name = "Candidate Student ${i + 1}";
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      value: false,
                      onChanged: (v) {},
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text(
                        "Roll: MIT-2024-X",
                        style: TextStyle(fontSize: 11),
                      ),
                      secondary: const CircleAvatar(child: Icon(Icons.person)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("Confirm Selection"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
