import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String? doctorName;

  @override
  void initState() {
    super.initState();
    _loadDoctorName();
  }

  Future<void> _loadDoctorName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        doctorName = doc['fullName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double frameSize = screenWidth * 0.65;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.person_outline, color: Color(0xFF9D5C7D)),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfile()),
            );
            // 🔁 بعد الرجوع من صفحة EditProfile، نعيد تحميل الاسم
            _loadDoctorName();
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName != null
                        ? "Hello, Dr. $doctorName 👋"
                        : "Hello, Doctor 👋",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Review and manage your patients’ health profiles.",
                    style: TextStyle(
                      color: Color(0xFF5E5E5E),
                      fontSize: 13,
                      height: 1.3,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              "Scan Child's QR Code",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Align the QR code within the frame below\nto begin the identification process.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6F6F6F),
                fontSize: 13,
                height: 1.4,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: frameSize,
              height: frameSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF9D5C7D),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              child: MobileScanner(
                onDetect: (capture) {
                  for (final barcode in capture.barcodes) {
                    final code = barcode.rawValue ?? '';
                    debugPrint('QR Detected: $code');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('QR Detected: $code')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
