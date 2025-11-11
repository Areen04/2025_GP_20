import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'parent_signup.dart';
import 'parent_dashboard.dart';
import 'qr_scan_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;

  late AnimationController _controller;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _showErrorPopup(String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Failed", style: TextStyle(color: Colors.black87)),
        content: Text(message, style: const TextStyle(color: Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Color(0xFF9D5C7D))),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    final email = _email.text.trim();
    final password = _password.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return _showErrorPopup("Please fill in all fields.");
    }

    setState(() => _isLoading = true);
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      if (!doc.exists) {
        return _showErrorPopup("User not found. Please check your email.");
      }

      final role = doc['role'];

      if (role == 'doctor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QRScanPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ParentDashboard()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = "Invalid email format.";
          break;
        case 'user-not-found':
          message = "No user found with this email.";
          break;
        case 'wrong-password':
          message = "Incorrect password. Please try again.";
          break;
        default:
          message = e.message ?? "An unexpected error occurred.";
      }
      await _showErrorPopup(message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _email.text.trim());
        return AlertDialog(
          title: const Text("Reset Password"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Enter your email",
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF9D5C7D),
                side: const BorderSide(color: Color(0xFF9D5C7D)),
              ),
              onPressed: () async {
                final email = controller.text.trim();
                if (email.isEmpty) {
                  await _showErrorPopup("Please enter your email first.");
                  return;
                }

                try {
                  await _auth.sendPasswordResetEmail(email: email);
                  if (!mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Reset link sent to $email.")),
                  );
                } on FirebaseAuthException catch (e) {
                  String msg = e.code == 'user-not-found'
                      ? "No user found with that email."
                      : "Something went wrong. Try again.";
                  await _showErrorPopup(msg);
                }
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                top: -80 + _waveAnimation.value,
                right: -60,
                child: Transform.rotate(
                  angle: 0.3,
                  child: Container(
                    width: screenWidth * 0.75,
                    height: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF8E9F0),
                          Color(0xFFE7BFD1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(200),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF9D5C7D).withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -80 - _waveAnimation.value,
                left: -60,
                child: Transform.rotate(
                  angle: -0.4,
                  child: Container(
                    width: screenWidth * 0.75,
                    height: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE7BFD1),
                          Color(0xFFD39AB7),
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.circular(200),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF9D5C7D).withOpacity(0.12),
                          blurRadius: 25,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: SingleChildScrollView(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            const Text("Log in",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 30),
                            TextField(
                              controller: _email,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: _password,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(0xFF9D5C7D),
                                  minimumSize:
                                  const Size(double.infinity, 50),
                                ),
                                child: const Text("Log In",
                                    style:
                                    TextStyle(color: Colors.white))),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: _forgotPassword,
                              child: const Text(
                                "Forgot Password?",
                                style:
                                TextStyle(color: Color(0xFF9D5C7D)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                        const ParentSignup()),
                                  ),
                                  child: const Text("Create New Account",
                                      style: TextStyle(
                                          color: Color(0xFF9D5C7D),
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
