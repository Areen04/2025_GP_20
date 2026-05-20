import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';

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

      if (_selectedDocType == 'National ID' || _selectedDocType == 'Iqama') {
        _isDocValid = RegExp(r'^[0-9]{10}$').hasMatch(value);
      } else if (_selectedDocType == 'Passport') {
        _isDocValid =
            RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,}$').hasMatch(value);
      } else if (_selectedDocType == 'Medical License') {
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
    final l10n = AppLocalizations.of(context);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          l10n.errorTitle,
          style: const TextStyle(color: Colors.black87),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.ok,
              style: const TextStyle(color: Color(0xFF9D5C7D)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitUpdate() async {
    final l10n = AppLocalizations.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _validateDoc();

    if (_selectedDocType == null || _docNumberController.text.trim().isEmpty) {
      return _showErrorPopup(l10n.pleaseFillAllFields);
    }

    if (!_isDocValid) {
      return _showErrorPopup(l10n.documentNumberInvalid);
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
      if (!mounted) return;
      await _showErrorPopup(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _documentRequirementText(AppLocalizations l10n) {
    if (_selectedDocType == 'National ID' || _selectedDocType == 'Iqama') {
      return l10n.doctorUpdateDocNumberTenDigits;
    }
    if (_selectedDocType == 'Passport') {
      return l10n.doctorUpdatePassportRequirement;
    }
    if (_selectedDocType == 'Medical License') {
      return l10n.doctorUpdateMedicalLicenseRequirement;
    }
    return l10n.doctorUpdateSelectDocumentTypeFirst;
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
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = screenWidth - 48;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          l10n.doctorUpdateInfoTitle,
          style: const TextStyle(
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
              _fieldLabel(l10n.documentTypeLabel),
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
                  hintText: l10n.selectDocumentTypeHint,
                  onSelected: (value) {
                    setState(() {
                      _selectedDocType = value;
                    });
                    _validateDoc();
                  },
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                      value: 'National ID',
                      label: l10n.nationalId,
                    ),
                    DropdownMenuEntry(
                      value: 'Iqama',
                      label: l10n.iqama,
                    ),
                    DropdownMenuEntry(
                      value: 'Passport',
                      label: l10n.passport,
                    ),
                    DropdownMenuEntry(
                      value: 'Medical License',
                      label: l10n.medicalLicense,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _fieldLabel(l10n.documentNumberLabel),
              const SizedBox(height: 8),
              TextField(
                controller: _docNumberController,
                focusNode: _docNumberFocus,
                keyboardType: TextInputType.text,
                onChanged: (_) => _validateDoc(),
                decoration: InputDecoration(
                  hintText: l10n.enterDocumentNumberHint,
                  hintStyle: const TextStyle(fontFamily: 'Inter'),
                  border: _border(Colors.grey),
                  enabledBorder: _border(_getDocNumberColor()),
                  focusedBorder: _border(_getDocNumberColor()),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _documentRequirementText(l10n),
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
                      : Text(
                          l10n.submitForReview,
                          style: const TextStyle(
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
