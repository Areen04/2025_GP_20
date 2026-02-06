import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';
import 'doctor_signup.dart';
import 'parent_dashboard.dart';
import 'login.dart';
import 'widgets/language_switcher.dart';

class ParentSignup extends StatefulWidget {
  const ParentSignup({super.key});

  @override
  State<ParentSignup> createState() => _ParentSignupState();
}

class _ParentSignupState extends State<ParentSignup> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

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

@override
void initState() {
  super.initState();

  _nameFocus.addListener(() => setState(() {}));
  _emailFocus.addListener(() => setState(() {}));
  _passwordFocus.addListener(() => setState(() {}));
  _confirmPasswordFocus.addListener(() => setState(() {}));
}

@override
void dispose() {
  _nameFocus.dispose();
  _emailFocus.dispose();
  _passwordFocus.dispose();
  _confirmPasswordFocus.dispose();
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
    });
  }

  Future<void> _showErrorPopup(String message) async {
  final l10n = AppLocalizations.of(context);
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // same radius
      ),
      title: Text(
        l10n.errorTitle,
        style: const TextStyle(color: Colors.black87), // same title color
      ),
      content: Text(
        message, 
        style: const TextStyle(color: Colors.black54), // same content color
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // same button radius
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.ok,
            style: const TextStyle(color: Color(0xFF9D5C7D)), // same purple color
          ),
        ),
      ],
    ),
  );
}

  Future<void> _createAccount() async {
  final l10n = AppLocalizations.of(context);
  _validateFields();

  // NEW: Check if ANY field is empty
  if (_nameController.text.trim().isEmpty ||
      _emailController.text.trim().isEmpty ||
      _passwordController.text.isEmpty ||
      _confirmPasswordController.text.isEmpty) {
    return _showErrorPopup(l10n.pleaseFillAllFields);
  }

  if (!_isNameValid) return _showErrorPopup(l10n.fullNameMin2Error);
  if (!_isEmailValid) return _showErrorPopup(l10n.validEmailError);
  if (!_isPasswordValid) return _showErrorPopup(l10n.passwordRequirementsError);
  if (!_passwordsMatch) return _showErrorPopup(l10n.passwordsDoNotMatch);

  setState(() => _isLoading = true);

  try {
    UserCredential userCred = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    await _firestore.collection('parents').doc(userCred.user!.uid).set({
      'fullName': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'role': 'parent',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore
        .collection('parents')
        .doc(userCred.user!.uid)
        .collection('children')
        .doc('_init')
        .set({'placeholder': true});

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ParentDashboard()),
    );
  } on FirebaseAuthException catch (e) {
    await _showErrorPopup(e.message ?? l10n.errorOccurred);
  } finally {
    setState(() => _isLoading = false);
  }
}

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1.5),
      );

Color _getColor(bool valid, TextEditingController controller, FocusNode focusNode) {
  if (focusNode.hasFocus && controller.text.isEmpty) {
    return const Color(0xFF9D5C7D); // login-style purple when first selected
  }
  if (controller.text.isEmpty) return Colors.grey; // no input yet
  return valid ? Colors.green : Colors.red; // validation color after typing
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
               Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9D5C7D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          // keep natural height
        ),
        child: Text(l10n.parentTab),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DoctorSignup()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE8E6E7),
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            l10n.healthcareProviderTab,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
                    Text(
                      l10n.fullNameLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: l10n.enterFullNameHint,
                        border: _border(Colors.grey),
                        enabledBorder: _border(_getColor(_isNameValid, _nameController, _nameFocus)),
                        focusedBorder: _border(_getColor(_isNameValid, _nameController, _nameFocus)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.emailLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                    Text(
                      l10n.passwordLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: _obscurePassword,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: l10n.passwordHint,   // ← الـ Placeholder
                        border: _border(Colors.grey),
                        enabledBorder:
                        _border(_getColor(_isPasswordValid, _passwordController, _passwordFocus)),
                        focusedBorder:
                        _border(_getColor(_isPasswordValid, _passwordController, _passwordFocus)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
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
                    Text(
                      l10n.confirmPasswordLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      obscureText: _obscureConfirmPassword,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: l10n.reenterPasswordHint,   // ← Placeholder
                        border: _border(Colors.grey),
                        enabledBorder: _border(
                            _getColor(_passwordsMatch, _confirmPasswordController, _confirmPasswordFocus)),
                        focusedBorder: _border(
                            _getColor(_passwordsMatch, _confirmPasswordController, _confirmPasswordFocus)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),


                // Password Hints
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

           _isLoading
    ? const CircularProgressIndicator()
    : Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _createAccount,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9D5C7D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n.createAccountButton,
              style: const TextStyle(
                fontSize: 18,
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
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
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
