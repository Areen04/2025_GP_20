import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile.dart';
import 'services/visit_token_service.dart';
import 'doctor_visit_page.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String? doctorName;
  bool _loading = true;
bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadDoctorName();
  }

  Future<void> _loadDoctorName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _loading = false);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          doctorName = doc['fullName'];
          _loading = false;
        });
      } else {
        setState(() {
          doctorName = null;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        doctorName = null;
        _loading = false;
      });
    }
  }
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF9D5C7D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

Future<void> _handleScannedQR(String token) async {
  final l10n = AppLocalizations.of(context);
  if (_isProcessing) return;
  _isProcessing = true;

  final childId = await VisitTokenService.consumeToken(token);

  if (childId == null) {
    _showSnackBar(l10n.qrInvalid, isError: true);
    _isProcessing = false;
    return;
  }

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DoctorVisitPage(childId: childId),
    ),
  );

  // Allow scanning again after returning.
  _isProcessing = false;

}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                          l10n.helloDoctor(doctorName ?? l10n.doctorLabel),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.doctorGreeting,
                          style: const TextStyle(
                            color: Color(0xFF6F6F6F),
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
                  Text(
                    l10n.scanQrTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    l10n.scanQrInstruction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
    final token = barcode.rawValue;
    if (token != null) {
      _handleScannedQR(token); // ✅ async handled safely
    }
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
