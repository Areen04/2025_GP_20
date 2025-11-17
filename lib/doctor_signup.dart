import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'parent_signup.dart';
import 'qr_scan_page.dart';
import 'login.dart';

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

      // Validate Document Number
      if (_selectedDocType == "National ID" || _selectedDocType == "Iqama") {
        _isDocValid = RegExp(r'^[0-9]{10}$').hasMatch(_docNumberController.text);
      } else if (_selectedDocType == "Passport") {
        _isDocValid = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,}$')
            .hasMatch(_docNumberController.text);
      } else {
        _isDocValid = false;
      }
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
            child: const Text("OK", style: TextStyle(color: Color(0xFF9D5C7D))),
          )
        ],
      ),
    );
  }

  Future<void> _registerDoctor() async {
    _validateFields();

    if (!_isNameValid) {
      return _showErrorPopup("Full name must be at least 2 characters.");
    }
    if (!_isEmailValid) {
      return _showErrorPopup("Please enter a valid email address.");
    }
    if (!_isPasswordValid) {
      return _showErrorPopup("Password must meet all requirements.");
    }
    if (!_passwordsMatch) {
      return _showErrorPopup("Passwords do not match.");
    }
    if (_selectedDocType == null) {
      return _showErrorPopup("Please select a document type.");
    }
    if (!_isDocValid) {
      return _showErrorPopup("Document number is invalid for selected type.");
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'docType': _selectedDocType,
        'docNumber': _docNumberController.text.trim(),
        'role': 'doctor',
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QRScanPage()),
      );
    } on FirebaseAuthException catch (e) {
      await _showErrorPopup(e.message ?? "An error occurred.");
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
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ParentSignup()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8E6E7),
                            foregroundColor: Colors.black87),
                        child: const Text("Parent"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9D5C7D),
                            foregroundColor: Colors.white),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Healthcare Provider",
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                    Text(
                      "Full Name:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _nameController,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: 'Enter Full Name',   // ← الـ Placeholder
                        border: _border(Colors.grey),
                        enabledBorder:
                        _border(_getColor(_isNameValid, _nameController)),
                        focusedBorder:
                        _border(_getColor(_isNameValid, _nameController)),
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
                        hintText: 'example@gmail.com',   // ← الـ Placeholder
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
                        hintText: 'Enter password', // ← Placeholder
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
                      "Confirm Password:",
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
                        hintText: 'Re-enter password', // ← Placeholder
                        border: _border(Colors.grey),
                        enabledBorder: _border(
                          _getColor(_passwordsMatch, _confirmPasswordController),
                        ),
                        focusedBorder: _border(
                          _getColor(_passwordsMatch, _confirmPasswordController),
                        ),
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


                // Password hints
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
                const SizedBox(height: 20),

                // Document Type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Document Type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: _selectedDocType,
                      hint: const Text("Select document type"),

                      items: const [
                        DropdownMenuItem(
                          value: "National ID",
                          child: Text("National ID"),
                        ),
                        DropdownMenuItem(
                          value: "Iqama",
                          child: Text("Iqama"),
                        ),
                        DropdownMenuItem(
                          value: "Passport",
                          child: Text("Passport"),
                        ),
                        DropdownMenuItem(
                          value: "Medical License",
                          child: Text("Medical License"),
                        ),
                      ],

                      onChanged: (value) {
                        setState(() {
                          _selectedDocType = value;
                          _validateFields();
                        });
                      },

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),



                // Document Number
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Document Number:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _docNumberController,
                      onChanged: (_) => _validateFields(),
                      decoration: InputDecoration(
                        hintText: 'Enter document number', // placeholder
                        border: _border(Colors.grey),
                        enabledBorder:
                        _border(_getColor(_isDocValid, _docNumberController)),
                        focusedBorder:
                        _border(_getColor(_isDocValid, _docNumberController)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _registerDoctor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9D5C7D),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Create Account",
                      style: TextStyle(color: Colors.white)),
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
                            fontWeight: FontWeight.bold),
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
