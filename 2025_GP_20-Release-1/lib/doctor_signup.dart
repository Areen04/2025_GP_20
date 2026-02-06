import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';
import 'parent_signup.dart';
import 'login.dart';
import 'doctor_pending_page.dart';
import 'widgets/language_switcher.dart';

class DoctorSignup extends StatefulWidget {
  const DoctorSignup({super.key});

  @override
  State<DoctorSignup> createState() => _DoctorSignupState();
}

class _DoctorSignupState extends State<DoctorSignup> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _docNumberController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _docNumberFocus = FocusNode();
  final FocusNode _docTypeFocus = FocusNode();

  String? _selectedDocType;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  bool _isNameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _passwordHasUpper = false;
  bool _passwordHasLower = false;
  bool _passwordHasNumber = false;
  bool _passwordHasLength = false;
  bool _isDocValid = false;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() => setState(() {}));
    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
    _confirmPasswordFocus.addListener(() => setState(() {}));
    _docNumberFocus.addListener(() => setState(() {}));
    _docTypeFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _docNumberController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _docNumberFocus.dispose();
    _docTypeFocus.dispose();
    super.dispose();
  }

  bool get _passwordsMatch =>
      _passwordController.text == _confirmPasswordController.text &&
          _passwordController.text.isNotEmpty;

  void _validateFields() {
    setState(() {
      _isNameValid = _nameController.text.trim().length >= 2;
      _isEmailValid =
          RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text);

      final pwd = _passwordController.text;
      _passwordHasUpper = pwd.contains(RegExp(r'[A-Z]'));
      _passwordHasLower = pwd.contains(RegExp(r'[a-z]'));
      _passwordHasNumber = pwd.contains(RegExp(r'[0-9]'));
      _passwordHasLength = pwd.length >= 8;

      _isPasswordValid = _passwordHasUpper &&
          _passwordHasLower &&
          _passwordHasNumber &&
          _passwordHasLength;

      // Document validation
      if (_selectedDocType == "National ID" || _selectedDocType == "Iqama") {
        _isDocValid =
            RegExp(r'^[0-9]{10}$').hasMatch(_docNumberController.text.trim());
      } else if (_selectedDocType == "Passport") {
        _isDocValid = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,}$')
            .hasMatch(_docNumberController.text.trim());
      } else {
        _isDocValid = false;
      }
    });
  }

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
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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

  Future<void> _registerDoctor() async {
    final l10n = AppLocalizations.of(context);
    _validateFields();

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedDocType == null ||
        _docNumberController.text.trim().isEmpty) {
      return _showErrorPopup(l10n.pleaseFillAllFields);
    }

    if (!_isNameValid) {
      return _showErrorPopup(l10n.fullNameMin2Error);
    }
    if (!_isEmailValid) {
      return _showErrorPopup(l10n.validEmailError);
    }
    if (!_isPasswordValid) {
      return _showErrorPopup(l10n.passwordRequirementsError);
    }
    if (!_passwordsMatch) {
      return _showErrorPopup(l10n.passwordsDoNotMatch);
    }
    if (!_isDocValid) {
      return _showErrorPopup(l10n.documentNumberInvalid);
    }

    setState(() => _isLoading = true);

    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'docType': _selectedDocType,
        'docNumber': _docNumberController.text.trim(),
        'role': 'doctor',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DoctorPendingPage()),
      );
    } on FirebaseAuthException catch (e) {
      await _showErrorPopup(e.message ?? l10n.errorOccurred);
    } catch (e) {
      await _showErrorPopup(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  Color _getColor(bool valid, TextEditingController c, FocusNode f) {
    if (f.hasFocus && c.text.isEmpty) return const Color(0xFF9D5C7D);
    if (c.text.isEmpty) return Colors.grey;
    return valid ? Colors.green : Colors.red;
  }

  Color _getDocTypeColor() {
    if (_selectedDocType != null) return Colors.green;
    if (_docTypeFocus.hasFocus) return const Color(0xFF9D5C7D);
    if (_selectedDocType == null && _docNumberController.text.isNotEmpty) {
      return Colors.red;
    }
    return Colors.grey;
  }

  Widget _pendingReviewBox(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EEF2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7D6DD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF9D5C7D), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.pendingReviewInfo,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: const LanguageSwitcher(),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.createAccountTitle,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),

                // Tabs
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ParentSignup()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8E6E7),
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(l10n.parentTab),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9D5C7D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.healthcareProviderTab,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Full Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel(l10n.fullNameLabel),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: l10n.enterFullNameHint,
                        border: _border(Colors.grey),
                        enabledBorder:
                        _border(_getColor(_isNameValid, _nameController, _nameFocus)),
                        focusedBorder:
                        _border(_getColor(_isNameValid, _nameController, _nameFocus)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel(l10n.emailLabel),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: l10n.emailExampleHint,
                        border: _border(Colors.grey),
                        enabledBorder:
                        _border(_getColor(_isEmailValid, _emailController, _emailFocus)),
                        focusedBorder:
                        _border(_getColor(_isEmailValid, _emailController, _emailFocus)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel(l10n.passwordLabel),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: _obscurePassword,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: l10n.passwordHint,
                        border: _border(Colors.grey),
                        enabledBorder: _border(
                            _getColor(_isPasswordValid, _passwordController, _passwordFocus)),
                        focusedBorder: _border(
                            _getColor(_isPasswordValid, _passwordController, _passwordFocus)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() {
                            _obscurePassword = !_obscurePassword;
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Confirm Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel(l10n.confirmPasswordLabel),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      obscureText: _obscureConfirmPassword,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: l10n.reenterPasswordHint,
                        border: _border(Colors.grey),
                        enabledBorder: _border(
                            _getColor(_passwordsMatch, _confirmPasswordController, _confirmPasswordFocus)),
                        focusedBorder: _border(
                            _getColor(_passwordsMatch, _confirmPasswordController, _confirmPasswordFocus)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Password hints
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHint(l10n.passwordReqAtLeast8, _passwordHasLength),
                      _buildHint(l10n.passwordReqUppercase, _passwordHasUpper),
                      _buildHint(l10n.passwordReqLowercase, _passwordHasLower),
                      _buildHint(l10n.passwordReqNumber, _passwordHasNumber),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Document Type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.documentTypeLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Focus(
                      focusNode: _docTypeFocus,
                      child: DropdownMenu<String>(
                        width: MediaQuery.of(context).size.width - 48,
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: _getDocTypeColor(), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: _getDocTypeColor(), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: _getDocTypeColor(), width: 1.5),
                          ),
                        ),
                        hintText: l10n.selectDocumentTypeHint,
                        onSelected: (value) {
                          setState(() {
                            _selectedDocType = value;
                            _validateFields();
                          });
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "National ID", label: l10n.nationalId),
                          DropdownMenuEntry(value: "Iqama", label: l10n.iqama),
                          DropdownMenuEntry(value: "Passport", label: l10n.passport),
                          DropdownMenuEntry(value: "Medical License", label: l10n.medicalLicense),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Document Number
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel(l10n.documentNumberLabel),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _docNumberController,
                      focusNode: _docNumberFocus,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: l10n.enterDocumentNumberHint,
                        border: _border(Colors.grey),
                        enabledBorder:
                        _border(_getColor(_isDocValid, _docNumberController, _docNumberFocus)),
                        focusedBorder:
                        _border(_getColor(_isDocValid, _docNumberController, _docNumberFocus)),
                      ),
                    ),
                  ],
                ),

                // Pending Review box under doc number
                const SizedBox(height: 14),
                _pendingReviewBox(context),

                const SizedBox(height: 25),

                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _registerDoctor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D5C7D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        l10n.submitForReview,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.alreadyHaveAccount),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        l10n.loginLink,
                        style: const TextStyle(
                          color: Color(0xFF9D5C7D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHint(String text, bool valid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          color: valid ? Colors.green : Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }
}
