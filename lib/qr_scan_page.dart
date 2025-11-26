import 'package:flutter/material.dart';
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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorName();
  }

  Future<void> _loadDoctorName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          doctorName = doc['fullName'] ?? "Doctor";
          _loading = false;
        });
      } else {
        setState(() {
          doctorName = "Doctor";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        doctorName = "Doctor";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double frameSize = screenWidth * 0.65;

    return Scaffold(
      backgroundColor: Colors.white,

      // ✔️ SAME APPBAR AS PARENT DASHBOARD
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined, color: Color(0xFF9D5C7D)),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfile()),
            );
            _loadDoctorName();
          },
        ),
        actions: const [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Color(0xFF9D5C7D)),
            onPressed: null,
          ),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ✔️ SAME GREETING BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, Dr. ${doctorName ?? 'Doctor'}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
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

                  const SizedBox(height: 40),

                  // ✔️ Title
                  const Text(
                    "Scan Child's QR Code",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "Align the QR code within the frame below\n"
                    "to begin the identification process.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6F6F6F),
                      fontSize: 13,
                      height: 1.4,
                      fontFamily: 'Inter',
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ✔️ QR Frame
                  Container(
                    width: frameSize,
                    height: frameSize,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF9D5C7D),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: MobileScanner(
                      onDetect: (capture) {
                        for (final barcode in capture.barcodes) {
                          final code = barcode.rawValue ?? '';

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('QR Detected: $code'),
                              backgroundColor: const Color(0xFF9D5C7D),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              duration: const Duration(seconds: 2),
                            ),
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
