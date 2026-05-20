import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Timer(const Duration(seconds: 10), _goToLogin);
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: _goToLogin,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedBuilder(
          animation: _waveAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                // 🌊 الشكل العلوي (بيضاوي متدرج ومائل)
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
                            Color(0xFFF8E9F0), // 🎨 فاتح من لونك الأساسي
                            Color(0xFFE7BFD1), // 🎨 درجة وسطى أنيقة
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

                // 🌊 الشكل السفلي (مائل بالعكس)
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
                            Color(0xFFE7BFD1), // 🎨 من نفس العائلة
                            Color(0xFFD39AB7), // 🎨 غامق شوي لإضافة عمق
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

                // ✨ اللوقو المتحرك
                Center(
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Image.asset(
                        'lib/assets/logo.png',
                        width: 300,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
