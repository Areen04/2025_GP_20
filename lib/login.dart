import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';
import 'parent_signup.dart';
import 'parent_dashboard.dart';
import 'qr_scan_page.dart';
import 'widgets/language_switcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
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
          l10n.loginFailed,
          style: const TextStyle(color: Colors.black87),
        ),
        content: Text(message, style: const TextStyle(color: Colors.black54)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  // ✅ helper: check if doctor is approved from Firestore doc
  bool _isDoctorApproved(Map<String, dynamic> data) {
    final status = (data['status'] ?? '').toString().toLowerCase().trim();
    final isApproved = data['isApproved'] == true;

    // accept either:
    // - status == "approved"
    // - isApproved == true
    return status == 'approved' || isApproved;
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context);
    final email = _email.text.trim();
    final password = _password.text.trim();

    if (email.isEmpty || password.isEmpty) {
      await _showErrorPopup(l10n.pleaseFillAllFields);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot<Map<String, dynamic>>? doc;

      // 1) Try parents collection
      final parentDoc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(cred.user!.uid)
          .get();

      if (parentDoc.exists) {
        doc = parentDoc;
      } else {
        // 2) Fallback users collection
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .get();

        if (userDoc.exists) doc = userDoc;
      }

      if (doc == null || !doc.exists || doc.data() == null) {
        await _auth.signOut();
        await _showErrorPopup(l10n.userNotFoundCheckEmail);
        return;
      }

      final data = doc.data()!;
      final role = (data['role'] ?? '').toString().toLowerCase().trim();

      // ✅ Doctor: only allow if approved
      if (role == 'doctor') {
        final approved = _isDoctorApproved(data);

        if (!approved) {
          await _auth.signOut(); // مهم: لا نخليه يعتبر نفسه logged in
          await _showErrorPopup(
            l10n.doctorNotApprovedMessage,
          );
          return;
        }

        // approved ✅
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QRScanPage()),
        );
        return;
      }

      // Parent / other roles
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ParentDashboard()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = l10n.invalidEmailFormat;
          break;
        case 'user-not-found':
          message = l10n.noUserFoundWithEmail;
          break;
        case 'wrong-password':
          message = l10n.incorrectPassword;
          break;
        case 'invalid-credential':
          message = l10n.emailOrPasswordIncorrect;
          break;
        default:
          message = e.message ?? l10n.unexpectedError;
      }
      await _showErrorPopup(message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _forgotPassword() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _email.text.trim());
        bool emailSent = false;
        String? errorMessage;

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              emailSent ? l10n.emailSentTitle : l10n.resetPasswordTitle,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Color(0xFF9D5C7D),
              ),
            ),
            content: emailSent
                ? Text(
              l10n.resetLinkSentTo(controller.text.trim()),
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
                    labelText: l10n.enterYourEmail,
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
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(emailSent ? l10n.ok : l10n.cancel),
              ),
              if (!emailSent)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF9D5C7D),
                    side: const BorderSide(color: Color(0xFF9D5C7D)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final email = controller.text.trim();
                    if (email.isEmpty) {
                      setState(() => errorMessage = l10n.pleaseEnterEmailFirst);
                      return;
                    }

                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                      setState(() => emailSent = true);
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        errorMessage = e.code == 'user-not-found'
                            ? l10n.noUserFoundWithThatEmail
                            : l10n.somethingWentWrongTryAgain;
                      });
                    }
                  },
                  child: Text(l10n.send),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                        colors: [Color(0xFFF8E9F0), Color(0xFFE7BFD1)],
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
                        colors: [Color(0xFFE7BFD1), Color(0xFFD39AB7)],
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
                            Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: const LanguageSwitcher(),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.loginTitle,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 30),

                            TextField(
                              controller: _email,
                              decoration: InputDecoration(
                                labelText: l10n.emailLabel,
                                border: _border(Colors.grey),
                                enabledBorder: _border(Colors.grey),
                                focusedBorder: _border(const Color(0xFF9D5C7D)),
                              ),
                            ),
                            const SizedBox(height: 15),

                            TextField(
                              controller: _password,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: l10n.passwordLabel,
                                border: _border(Colors.grey),
                                enabledBorder: _border(Colors.grey),
                                focusedBorder: _border(const Color(0xFF9D5C7D)),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _obscure = !_obscure),
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
                                child: Text(
                                  l10n.loginButton,
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                l10n.forgotPassword,
                                style: const TextStyle(color: Color(0xFF9D5C7D)),
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l10n.dontHaveAccount),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ParentSignup()),
                                  ),
                                  child: Text(
                                    l10n.createNewAccount,
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
