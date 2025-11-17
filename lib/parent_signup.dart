import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_signup.dart';
import 'parent_dashboard.dart';
import 'login.dart';

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
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error", style: TextStyle(color: Colors.black87)),
        content: Text(message, style: const TextStyle(color: Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("OK", style: TextStyle(color: Color(0xFF9D5C7D))),
          )
        ],
      ),
    );
  }

  Future<void> _createAccount() async {
    _validateFields();

    if (!_isNameValid) return _showErrorPopup("Full name must be at least 2 characters.");
    if (!_isEmailValid) return _showErrorPopup("Please enter a valid email address.");
    if (!_isPasswordValid) return _showErrorPopup("Password must meet all requirements.");
    if (!_passwordsMatch) return _showErrorPopup("Passwords do not match.");

    setState(() => _isLoading = true);

    try {
      // 🔹 إنشاء حساب جديد في Firebase Authentication
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // 🔹 إنشاء وثيقة جديدة في مجموعة parents بدل users
      await _firestore.collection('parents').doc(userCred.user!.uid).set({
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'parent',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 🔹 إنشاء subcollection فاضي للـ children (جاهز للإضافة لاحقاً)
      await _firestore
          .collection('parents')
          .doc(userCred.user!.uid)
          .collection('children')
          .doc('_init')
          .set({'placeholder': true});

      // 🔹 الانتقال للـ Dashboard بعد التسجيل
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );
    } on FirebaseAuthException catch (e) {
      await _showErrorPopup(e.message ?? "Error occurred.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1.5),
      );

  Color _getColor(bool valid, TextEditingController controller) {
    if (controller.text.isEmpty) return Colors.grey;
    return valid ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create Account",
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
                        ),
                        child: const Text("Parent"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DoctorSignup()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8E6E7),
                          foregroundColor: Colors.black87,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Healthcare Provider",
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
                      "Full Name:",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _nameController,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: 'Enter Full Name',
                        border: _border(Colors.grey),
                        enabledBorder: _border(_getColor(_isNameValid, _nameController)),
                        focusedBorder: _border(_getColor(_isNameValid, _nameController)),
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
                      "Email:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _emailController,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: 'example@gmail.com',
                        border: _border(Colors.grey),
                        enabledBorder:
                        _border(_getColor(_isEmailValid, _emailController)),
                        focusedBorder:
                        _border(_getColor(_isEmailValid, _emailController)),
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
                      "Password:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: 'Enter password',   // ← الـ Placeholder
                        border: _border(Colors.grey),
                        enabledBorder:
                        _border(_getColor(_isPasswordValid, _passwordController)),
                        focusedBorder:
                        _border(_getColor(_isPasswordValid, _passwordController)),
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
                      "Confirm password:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: 'Re-enter password',   // ← Placeholder
                        border: _border(Colors.grey),
                        enabledBorder: _border(
                            _getColor(_passwordsMatch, _confirmPasswordController)),
                        focusedBorder: _border(
                            _getColor(_passwordsMatch, _confirmPasswordController)),
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
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHint("• At least 8 characters", _passwordHasLength),
                      _buildHint("• One uppercase letter", _passwordHasUpper),
                      _buildHint("• One lowercase letter", _passwordHasLower),
                      _buildHint("• One number", _passwordHasNumber),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9D5C7D),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
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