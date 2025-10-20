import 'package:flutter/material.dart';
import 'parent_signup.dart';
import 'login.dart';

class DoctorSignup extends StatefulWidget {
  const DoctorSignup({super.key});

  @override
  State<DoctorSignup> createState() => _DoctorSignupState();
}

class _DoctorSignupState extends State<DoctorSignup> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 25),

                // الأزرار العلوية
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            borderRadius: BorderRadius.circular(6),
                          ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text("Healthcare Provider"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // الحقول
                _buildLabeledField("Full Name", "Enter your full name", false),
                _buildLabeledField("Email Address", "Enter your email", false),
                _buildLabeledField("Password", "Create a password", true),
                _buildLabeledField(
                    "Confirm Password", "Confirm your password", true),
                _buildLabeledField(
                    "Document Type", "Enter your document type", false),
                _buildLabeledField(
                    "Document Number", "Enter your document number", false),

                const SizedBox(height: 25),

                // ملاحظة الـ Pending Review
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E9EF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Your account status will be "Pending Review" upon submission. '
                        'You will not be able to log in until your credentials have been verified '
                        'and approved by our administration. This process typically takes 1-2 business days.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                    textAlign: TextAlign.left,
                  ),
                ),

                const SizedBox(height: 25),

                // زر الإرسال
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D5C7D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Submit for Review",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // النص السفلي
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFF9D5C7D),
                          fontWeight: FontWeight.w600,
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

  Widget _buildLabeledField(String label, String hint, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: isPassword
                ? (label.contains("Confirm")
                ? _obscureConfirmPassword
                : _obscurePassword)
                : false,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (label.contains("Confirm")) {
                      _obscureConfirmPassword =
                      !_obscureConfirmPassword;
                    } else {
                      _obscurePassword = !_obscurePassword;
                    }
                  });
                },
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
