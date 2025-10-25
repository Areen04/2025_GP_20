import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_signup.dart';
import 'parent_dashboard.dart';

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

  Future<void> _createAccount() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pwd = _passwordController.text;
    final confirmPwd = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || pwd.isEmpty || confirmPwd.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (pwd != confirmPwd) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pwd,
      );

      // حفظ الاسم في Firestore
      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'fullName': name,
        'email': email,
        'role': 'parent',
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Error occurred')));
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Create Account",
                    style:
                    TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9D5C7D),
                            foregroundColor: Colors.white),
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
                            foregroundColor: Colors.black87),
                        child: const Text("Healthcare Provider"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() => _obscureConfirmPassword =
                      !_obscureConfirmPassword),
                    ),
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
                  child: const Text("Create Account",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
