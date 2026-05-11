import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/services/lab_service.dart';

class LabsManagementScreen extends StatefulWidget {
  const LabsManagementScreen({super.key});

  @override
  State<LabsManagementScreen> createState() => _LabsManagementScreenState();
}

class _LabsManagementScreenState extends State<LabsManagementScreen> {
  List<Map<String, dynamic>> _labs = [];
  List<Map<String, dynamic>> _facultyList = [];
  bool _isLoading = true;
  String? _fetchError;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _fetchError = null;
    });
    try {
      final results = await Future.wait([
        LabService.fetchLabs(),
        LabService.fetchAllFaculty(),
      ]);
      if (mounted) {
        setState(() {
          _labs = results[0];
          _facultyList = results[1];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fetchError = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  // ─────────────────────────────────────────────────────
  // ADD / EDIT DIALOG
  // ─────────────────────────────────────────────────────
  void _showAddEditDialog([Map<String, dynamic>? lab]) {
    final isEditing = lab != null;
    final nameCtrl = TextEditingController(text: isEditing ? (lab['labName'] ?? '') : '');
    final roomCtrl = TextEditingController(text: isEditing ? (lab['roomNumber'] ?? '') : '');
    final capCtrl  = TextEditingController(text: isEditing ? (lab['capacity']?.toString() ?? '') : '');
    final descCtrl = TextEditingController(text: isEditing ? (lab['description'] ?? '') : '');
    final formKey  = GlobalKey<FormState>();

    String selectedType = isEditing ? (lab['labType'] ?? 'Computer') : 'Computer';
    String? selectedFacultyId;

    // Pre-select faculty when editing
    if (isEditing) {
      final incharge = lab['labIncharge'];
      selectedFacultyId = (incharge is Map) ? incharge['_id']?.toString() : incharge?.toString();
    }

    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          actionsPadding: const EdgeInsets.all(20),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.science_rounded, color: Colors.deepPurple, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                isEditing ? 'Edit Lab' : 'Add New Lab',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              ),
            ],
          ),
          content: SizedBox(
            width: 460,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),

                    // Lab Name
                    _field(
                      controller: nameCtrl,
                      label: 'Lab Name',
                      icon: Icons.label_rounded,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Lab name is required' : null,
                    ),
                    const SizedBox(height: 14),

                    // Room + Capacity row
                    Row(children: [
                      Expanded(
                        child: _field(
                          controller: roomCtrl,
                          label: 'Room No.',
                          icon: Icons.meeting_room_rounded,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          controller: capCtrl,
                          label: 'Capacity',
                          icon: Icons.event_seat_rounded,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            if (int.tryParse(v.trim()) == null) return 'Must be a number';
                            return null;
                          },
                        ),
                      ),
                    ]),
                    const SizedBox(height: 14),

                    // Lab Type
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: _dropDecor('Lab Type', Icons.category_rounded),
                      validator: (v) => v == null ? 'Required' : null,
                      items: ['Computer', 'Chemistry', 'Physics', 'Engineering', 'Media', 'Robotics', 'Other']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (val) => setDialogState(() => selectedType = val ?? 'Computer'),
                    ),
                    const SizedBox(height: 14),

                    // Faculty Dropdown — dynamic from DB
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Dropdown (or warning) ─────────────────────────
                        if (_facultyList.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(children: [
                              Icon(Icons.group_off_rounded, color: Colors.amber.shade800, size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'No staff/faculty found. Add one below.',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ]),
                          )
                        else
                          DropdownButtonFormField<String>(
                            value: selectedFacultyId,
                            decoration: _dropDecor('Lab Incharge (Faculty)', Icons.person_rounded),
                            validator: (v) => v == null ? 'Please select faculty' : null,
                            isExpanded: true,
                            items: _facultyList.map((f) {
                              final name = '${f['firstName'] ?? ''} ${f['lastName'] ?? ''}'.trim();
                              final dept = f['department']?.toString() ?? '';
                              final photo = f['profilePhoto']?.toString() ?? '';
                              return DropdownMenuItem<String>(
                                value: f['_id']?.toString(),
                                child: Row(children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.deepPurple.shade100,
                                    backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
                                    child: photo.isEmpty
                                        ? Text(
                                            name.isEmpty ? '?' : name[0].toUpperCase(),
                                            style: const TextStyle(color: Colors.deepPurple, fontSize: 11, fontWeight: FontWeight.bold),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), overflow: TextOverflow.ellipsis),
                                        if (dept.isNotEmpty)
                                          Text(dept, style: TextStyle(fontSize: 11, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ]),
                              );
                            }).toList(),
                            onChanged: (val) => setDialogState(() => selectedFacultyId = val),
                          ),

                        // ── '+ Add New Staff' button — always visible ─────
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            // Show mini add-staff dialog on top
                            final newStaff = await _showAddStaffDialog(ctx);
                            if (newStaff != null) {
                              // Add to local faculty list and auto-select
                              setDialogState(() {
                                _facultyList.add(newStaff);
                                selectedFacultyId = newStaff['_id']?.toString();
                              });
                              _snack('Staff "${newStaff['firstName']} ${newStaff['lastName']}" added!', Colors.green.shade700);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.deepPurple.shade200),
                            ),
                            child: Row(children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 16),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('+ Add New Staff Member', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.deepPurple, fontSize: 14)),
                                  Text('Create & auto-select a staff user', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Description
                    _field(
                      controller: descCtrl,
                      label: 'Description (Optional)',
                      icon: Icons.notes_rounded,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      if (_facultyList.isNotEmpty && selectedFacultyId == null) return;

                      setDialogState(() => isSaving = true);
                      try {
                        if (isEditing) {
                          await LabService.updateLab(
                            labId: lab['_id']?.toString() ?? '',
                            fields: {
                              'labName': nameCtrl.text.trim(),
                              'roomNumber': roomCtrl.text.trim(),
                              'capacity': int.parse(capCtrl.text.trim()),
                              'labType': selectedType,
                              if (selectedFacultyId != null) 'labIncharge': selectedFacultyId,
                              'description': descCtrl.text.trim(),
                            },
                          );
                        } else {
                          await LabService.createLab(
                            labName: nameCtrl.text.trim(),
                            roomNumber: roomCtrl.text.trim(),
                            capacity: int.parse(capCtrl.text.trim()),
                            labType: selectedType,
                            labInchargeId: selectedFacultyId ?? '',
                            description: descCtrl.text.trim(),
                          );
                        }

                        if (ctx.mounted) Navigator.pop(ctx);
                        _loadAll();
                        if (mounted) _snack(isEditing ? 'Lab updated!' : 'Lab created!', Colors.green.shade700);
                      } catch (e) {
                        setDialogState(() => isSaving = false);
                        if (mounted) _snack(e.toString().replaceAll('Exception: ', ''), Colors.red.shade700);
                      }
                    },
              child: isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      isEditing ? 'Save Changes' : 'Create Lab',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────
  // QUICK ADD STAFF DIALOG (launched from inside Add Lab)
  // ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> _showAddStaffDialog(BuildContext parentCtx) async {
    final fNameCtrl = TextEditingController();
    final lNameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final pwdCtrl   = TextEditingController();
    final deptCtrl  = TextEditingController();
    final formKey   = GlobalKey<FormState>();
    String selectedRole = 'Staff';
    bool isSaving = false;
    bool showPwd  = false;

    return showDialog<Map<String, dynamic>?>(
      context: parentCtx,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          actionsPadding: const EdgeInsets.all(20),
          title: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.person_add_rounded, color: Colors.green.shade700, size: 22),
            ),
            const SizedBox(width: 12),
            const Text('Add Staff Member', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          ]),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: _field(
                          controller: fNameCtrl,
                          label: 'First Name',
                          icon: Icons.person_rounded,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          controller: lNameCtrl,
                          label: 'Last Name',
                          icon: Icons.person_outline_rounded,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _field(
                      controller: emailCtrl,
                      label: 'Email Address',
                      icon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: pwdCtrl,
                      obscureText: !showPwd,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Password required';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_rounded, color: Colors.deepPurple, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(showPwd ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 18, color: Colors.grey),
                          onPressed: () => setSt(() => showPwd = !showPwd),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: _field(
                          controller: deptCtrl,
                          label: 'Department',
                          icon: Icons.school_rounded,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: InputDecoration(
                            labelText: 'Role',
                            prefixIcon: const Icon(Icons.badge_rounded, color: Colors.deepPurple, size: 20),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          items: ['Staff', 'Faculty', 'HOD', 'Principal']
                              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                              .toList(),
                          onChanged: (v) => setSt(() => selectedRole = v ?? 'Staff'),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.info_outline_rounded, size: 16, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Staff will log into the system using these credentials. Share securely.',
                            style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(ctx, null),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setSt(() => isSaving = true);
                      try {
                        final newStaff = await LabService.createStaffUser(
                          firstName:  fNameCtrl.text.trim(),
                          lastName:   lNameCtrl.text.trim(),
                          email:      emailCtrl.text.trim(),
                          password:   pwdCtrl.text.trim(),
                          department: deptCtrl.text.trim(),
                          role:       selectedRole,
                        );
                        if (ctx.mounted) Navigator.pop(ctx, newStaff);
                      } catch (e) {
                        setSt(() => isSaving = false);
                        if (mounted) _snack(e.toString().replaceAll('Exception: ', ''), Colors.red.shade700);
                      }
                    },
              child: isSaving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Create Staff', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────
  // DELETE
  // ─────────────────────────────────────────────────────
  Future<void> _deleteLab(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Lab', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text('Are you sure you want to delete "$name"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await LabService.deleteLab(id);
      _loadAll();
      _snack('"$name" deleted.', Colors.red.shade700);
    } catch (e) {
      _snack(e.toString().replaceAll('Exception: ', ''), Colors.red.shade700);
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: _loadAll,
        color: Colors.deepPurple,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER WITH ADD BUTTON (always visible) ──────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Laboratory Directory',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isLoading ? 'Loading...' : '${_labs.length} labs · ${_facultyList.length} faculty',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  // ADD LAB BUTTON — always present
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    label: const Text('Add Lab', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: Colors.deepPurple.withOpacity(0.3),
                    ),
                  ),
                ],
              ).animate().fadeIn().slideY(begin: -0.1),
              const SizedBox(height: 28),

              // ── ERROR BANNER (non-blocking) ───────────────────────────
              if (_fetchError != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(children: [
                    Icon(Icons.wifi_off_rounded, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Could not load labs from server.', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(_fetchError!, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _loadAll,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Retry'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
                    ),
                  ]),
                ),

              // ── LOADING ───────────────────────────────────────────────
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.deepPurple),
                        SizedBox(height: 16),
                        Text('Loading labs...', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                )

              // ── EMPTY STATE ───────────────────────────────────────────
              else if (_labs.isEmpty && _fetchError == null)
                _buildEmptyState()

              // ── DATA TABLE ────────────────────────────────────────────
              else if (_labs.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.deepPurple.shade50),
                        dataRowMinHeight: 72,
                        dataRowMaxHeight: 72,
                        horizontalMargin: 24,
                        columnSpacing: 28,
                        columns: const [
                          DataColumn(label: Text('LAB NAME', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                          DataColumn(label: Text('ROOM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                          DataColumn(label: Text('TYPE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                          DataColumn(label: Text('CAPACITY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                          DataColumn(label: Text('INCHARGE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                          DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                        ],
                        rows: _labs.map((lab) {
                          final incharge = lab['labIncharge'];
                          final inchargeName = (incharge is Map)
                              ? '${incharge['firstName'] ?? ''} ${incharge['lastName'] ?? ''}'.trim()
                              : 'Unassigned';
                          final inchargePhoto = (incharge is Map) ? (incharge['profilePhoto']?.toString() ?? '') : '';

                          return DataRow(
                            cells: [
                              DataCell(Row(children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.science_rounded, color: Colors.deepPurple, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Text(lab['labName'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                              ])),
                              DataCell(Text(lab['roomNumber'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(_typeBadge(lab['labType'] ?? '')),
                              DataCell(Text('${lab['capacity'] ?? 0} seats', style: TextStyle(color: Colors.grey.shade600))),
                              DataCell(Row(children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.deepPurple.shade100,
                                  backgroundImage: inchargePhoto.isNotEmpty ? NetworkImage(inchargePhoto) : null,
                                  child: inchargePhoto.isEmpty
                                      ? Text(
                                          inchargeName.isEmpty ? '?' : inchargeName[0].toUpperCase(),
                                          style: const TextStyle(color: Colors.deepPurple, fontSize: 12, fontWeight: FontWeight.bold),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(inchargeName.isEmpty ? 'Unassigned' : inchargeName,
                                    style: const TextStyle(fontWeight: FontWeight.w600)),
                              ])),
                              DataCell(Row(children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 20),
                                  onPressed: () => _showAddEditDialog(lab),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 20),
                                  onPressed: () => _deleteLab(lab['_id']?.toString() ?? '', lab['labName'] ?? ''),
                                  tooltip: 'Delete',
                                ),
                              ])),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
      child: Text(type, style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: Colors.deepPurple.shade50, shape: BoxShape.circle),
              child: const Icon(Icons.science_rounded, size: 60, color: Colors.deepPurple),
            ),
            const SizedBox(height: 24),
            const Text('No Labs Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            Text('Click "Add Lab" above to set up your first laboratory.',
                style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95));
  }

  // ── FORM HELPERS ─────────────────────────────────────────────────────────

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  InputDecoration _dropDecor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple, size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }
}
