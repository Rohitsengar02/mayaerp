import 'package:flutter/material.dart';
import '../../../core/app_constants.dart';

class CreateBusScreen extends StatefulWidget {
  const CreateBusScreen({super.key});

  @override
  State<CreateBusScreen> createState() => _CreateBusScreenState();
}

class _CreateBusScreenState extends State<CreateBusScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _busNoController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _conductorNameController =
      TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();

  final List<TextEditingController> _stopControllers = [
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: Row(
        children: [
          // Sidebar / Policy Info
          Container(
            width: 350,
            color: Colors.black,
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 40),
                const Icon(
                  Icons.directions_bus_filled_rounded,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Fleet Expansion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Registering a new bus requires valid vehicle documentation, driver certification, and approved route planning.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                _guideStep("1", "Vehicle Details", "Verify VIN and Bus Number"),
                _guideStep(
                  "2",
                  "Staff Assignment",
                  "Assign certified Driver/Conductor",
                ),
                _guideStep("3", "Route Planning", "Define stops and timelines"),
              ],
            ),
          ),

          // Form Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(60),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader("Vehicle Information"),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            "BUS NUMBER",
                            "e.g. DL-01-AB-1234",
                            _busNoController,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _textField(
                            "CAPACITY",
                            "e.g. 50",
                            _capacityController,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    _sectionHeader("Staff Allocation"),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            "DRIVER NAME",
                            "Full Name",
                            _driverNameController,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _textField(
                            "CONDUCTOR NAME",
                            "Full Name",
                            _conductorNameController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    _sectionHeader("Route Details"),
                    const SizedBox(height: 32),
                    _textField(
                      "PRIMARY ROUTE NAME",
                      "e.g. Sector 15 -> Campus",
                      _routeController,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "STOPS / STATIONS",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._stopControllers.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: _textField(
                                "STOP ${entry.key + 1}",
                                "Location name",
                                entry.value,
                              ),
                            ),
                            if (_stopControllers.length > 1)
                              IconButton(
                                onPressed: () => setState(
                                  () => _stopControllers.removeAt(entry.key),
                                ),
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    TextButton.icon(
                      onPressed: () => setState(
                        () => _stopControllers.add(TextEditingController()),
                      ),
                      icon: const Icon(
                        Icons.add_location_alt_rounded,
                        size: 18,
                      ),
                      label: const Text("Add Another Stop"),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryRed,
                      ),
                    ),

                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Confirm & Deploy"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _guideStep(String num, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                num,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              border: InputBorder.none,
            ),
            validator: (v) => v!.isEmpty ? "Required" : null,
          ),
        ),
      ],
    );
  }
}
