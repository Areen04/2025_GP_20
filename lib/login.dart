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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Rounded border helper
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1.5),
      );

  Future<void> _showErrorPopup(String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text("Login Failed",
            style: TextStyle(color: Colors.black87)),
        content: Text(message, style: const TextStyle(color: Colors.black54)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("OK",
                style: TextStyle(color: Color(0xFF9D5C7D))),
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

      DocumentSnapshot? doc;

      final parentDoc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(cred.user!.uid)
          .get();

      if (parentDoc.exists) {
        doc = parentDoc;
      } else {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .get();
        if (userDoc.exists) doc = userDoc;
      }

      if (doc == null || !doc.exists) {
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
        case 'invalid-credential':
          message = "Email or password is incorrect.";
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
        bool emailSent = false;
        String? errorMessage;

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              emailSent ? "Email Sent" : "Reset Password",
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Color(0xFF9D5C7D),
              ),
            ),
            content: emailSent
                ? Text(
                    "A reset link has been sent to ${controller.text.trim()}.",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black87,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: "Enter your email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: _border(Colors.grey),
                          enabledBorder: _border(Colors.grey),
                          focusedBorder: _border(const Color(0xFF9D5C7D)),
                        ),
                      ),
                      if (errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(emailSent ? "OK" : "Cancel"),
              ),
              if (!emailSent)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF9D5C7D),
                    side: const BorderSide(color: Color(0xFF9D5C7D)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final email = controller.text.trim();
                    if (email.isEmpty) {
                      setState(() {
                        errorMessage = "Please enter your email first.";
                      });
                      return;
                    }

                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);
                      setState(() {
                        emailSent = true;
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        errorMessage = e.code == 'user-not-found'
                            ? "No user found with that email."
                            : "Something went wrong. Try again.";
                      });
                    }
                  },
                  child: const Text("Send"),
                ),
            ],
          ),
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
              // Decorative waves
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
                            const Text("Log In",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 30),

                            // Email
                            TextField(
                              controller: _email,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: _border(Colors.grey),
                                enabledBorder: _border(Colors.grey),
                                focusedBorder: _border(const Color(0xFF9D5C7D)),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Password
                            TextField(
                              controller: _password,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: _border(Colors.grey),
                                enabledBorder: _border(Colors.grey),
                                focusedBorder: _border(const Color(0xFF9D5C7D)),
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
                                : SizedBox(
                                    height: 56,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF9D5C7D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Log In",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                            const SizedBox(height: 10),

                            TextButton(
                              onPressed: _forgotPassword,
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Color(0xFF9D5C7D)),
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
                                        builder: (_) => const ParentSignup()),
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
