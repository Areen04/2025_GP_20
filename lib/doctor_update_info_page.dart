import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorUpdateInfoPage extends StatefulWidget {
  const DoctorUpdateInfoPage({super.key});

  @override
  State<DoctorUpdateInfoPage> createState() => _DoctorUpdateInfoPageState();
}

class _DoctorUpdateInfoPageState extends State<DoctorUpdateInfoPage> {
  final _docNumberController = TextEditingController();
  final _docNumberFocus = FocusNode();
  final _docTypeFocus = FocusNode();

  String? _selectedDocType;
  bool _isLoading = false;
  bool _isDocValid = false;

  @override
  void initState() {
    super.initState();
    _docNumberFocus.addListener(() => setState(() {}));
    _docTypeFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _docNumberController.dispose();
    _docNumberFocus.dispose();
    _docTypeFocus.dispose();
    super.dispose();
  }

  void _validateDoc() {
    setState(() {
      final value = _docNumberController.text.trim();

      if (_selectedDocType == "National ID" || _selectedDocType == "Iqama") {
        _isDocValid = RegExp(r'^[0-9]{10}$').hasMatch(value);
      } else if (_selectedDocType == "Passport") {
        _isDocValid =
            RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,}$').hasMatch(value);
      } else if (_selectedDocType == "Medical License") {
        _isDocValid = RegExp(r'^[A-Za-z0-9]{5,}$').hasMatch(value);
      } else {
        _isDocValid = false;
      }
    });
  }

  Color _getDocNumberColor() {
    if (_docNumberFocus.hasFocus && _docNumberController.text.isEmpty) {
      return const Color(0xFF9D5C7D);
    }
    if (_docNumberController.text.isEmpty) return Colors.grey;
    return _isDocValid ? Colors.green : Colors.red;
  }

  Color _getDocTypeColor() {
    if (_selectedDocType != null) return Colors.green;
    if (_docTypeFocus.hasFocus) return const Color(0xFF9D5C7D);
    if (_docNumberController.text.isNotEmpty) return Colors.red;
    return Colors.grey;
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  Future<void> _showErrorPopup(String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text(
          "Error",
          style: TextStyle(color: Colors.black87),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: Color(0xFF9D5C7D)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitUpdate() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _validateDoc();

    if (_selectedDocType == null || _docNumberController.text.trim().isEmpty) {
      return _showErrorPopup("Please fill all fields.");
    }

    if (!_isDocValid) {
      return _showErrorPopup("Please enter a valid document number.");
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'docType': _selectedDocType,
        'docNumber': _docNumberController.text.trim(),
        'status': 'pending',
        'rejectionReason': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      await _showErrorPopup(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = screenWidth - 48;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Update Your Information",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel("Document Type"),
              const SizedBox(height: 8),

              Focus(
                focusNode: _docTypeFocus,
                child: DropdownMenu<String>(
                  width: fieldWidth,
                  textStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                  menuStyle: const MenuStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFFFFF7FB)),
                    surfaceTintColor: WidgetStatePropertyAll(Colors.white),
                    elevation: WidgetStatePropertyAll(3),
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    maximumSize: WidgetStatePropertyAll(Size.fromHeight(160)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: _border(_getDocTypeColor()),
                    enabledBorder: _border(_getDocTypeColor()),
                    focusedBorder: _border(const Color(0xFF9D5C7D)),
                  ),
                  hintText: "Select document type",
                  onSelected: (value) {
                    setState(() {
                      _selectedDocType = value;
                    });
                    _validateDoc();
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: "National ID",
                      label: "National ID",
                    ),
                    DropdownMenuEntry(
                      value: "Iqama",
                      label: "Iqama",
                    ),
                    DropdownMenuEntry(
                      value: "Passport",
                      label: "Passport",
                    ),
                    DropdownMenuEntry(
                      value: "Medical License",
                      label: "Medical License",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _fieldLabel("Document Number"),
              const SizedBox(height: 8),

              TextField(
                controller: _docNumberController,
                focusNode: _docNumberFocus,
                keyboardType: TextInputType.text,
                onChanged: (_) => _validateDoc(),
                decoration: InputDecoration(
                  hintText: "Enter document number",
                  hintStyle: const TextStyle(fontFamily: 'Inter'),
                  border: _border(Colors.grey),
                  enabledBorder: _border(_getDocNumberColor()),
                  focusedBorder: _border(_getDocNumberColor()),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _selectedDocType == "National ID" || _selectedDocType == "Iqama"
                    ? "Must be exactly 10 digits."
                    : _selectedDocType == "Passport"
                    ? "Must contain letters and numbers, at least 5 characters."
                    : _selectedDocType == "Medical License"
                    ? "Must be at least 5 letters or numbers."
                    : "Select a document type first.",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Inter',
                  color: _docNumberController.text.isEmpty
                      ? Colors.grey
                      : _isDocValid
                      ? Colors.green
                      : Colors.red,
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9D5C7D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Submit for Review",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}