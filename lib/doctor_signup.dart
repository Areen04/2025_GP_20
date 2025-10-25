import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'parent_signup.dart';
import 'qr_scan_page.dart';

class DoctorSignup extends StatefulWidget {
  const DoctorSignup({super.key});

  @override
  State<DoctorSignup> createState() => _DoctorSignupState();
}

class _DoctorSignupState extends State<DoctorSignup> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _docType = TextEditingController();
  final TextEditingController _docNumber = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Future<void> _registerDoctor() async {
    final name = _fullName.text.trim();
    final email = _email.text.trim();
    final password = _password.text.trim();
    final confirmPassword = _confirmPassword.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // إنشاء الحساب
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // حفظ البيانات في Firestore
      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'fullName': name,
        'email': email,
        'docType': _docType.text.trim(),
        'docNumber': _docNumber.text.trim(),
        'role': 'doctor',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );

      // التوجيه إلى صفحة QRScanPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QRScanPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Signup failed")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 25),

                // اختيار الدور
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
                        ),
                        child: const Text("Parent"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9D5C7D),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Healthcare Provider"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // الحقول
                _buildTextField(_fullName, "Full Name", false),
                _buildTextField(_email, "Email Address", false),
                _buildTextField(_password, "Password", true),
                _buildTextField(_confirmPassword, "Confirm Password", true),
                _buildTextField(_docType, "Document Type", false),
                _buildTextField(_docNumber, "Document Number", false),

                const SizedBox(height: 25),

                // زر التسجيل
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerDoctor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D5C7D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword
            ? (label.contains("Confirm")
            ? _obscureConfirmPassword
            : _obscurePassword)
            : false,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              label.contains("Confirm")
                  ? (_obscureConfirmPassword
                  ? Icons.visibility_off
                  : Icons.visibility)
                  : (_obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility),
            ),
            onPressed: () {
              setState(() {
                if (label.contains("Confirm")) {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                } else {
                  _obscurePassword = !_obscurePassword;
                }
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
