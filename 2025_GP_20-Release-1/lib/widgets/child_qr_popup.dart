import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';
import '../services/visit_token_service.dart';

class ChildQRPopup extends StatefulWidget {
  final String childId;
  final String childName;

  const ChildQRPopup({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<ChildQRPopup> createState() => _ChildQRPopupState();
}

class _ChildQRPopupState extends State<ChildQRPopup> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _generateToken();
  }

  Future<void> _generateToken() async {
    final token = await VisitTokenService.createToken(widget.childId);
    if (!mounted) return;
    setState(() => _token = token);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        widget.childName,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          color: Color(0xFF9D5C7D),
        ),
      ),
      content: SizedBox(
        width: 260,
        height: 270,
        child: _token == null
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF9D5C7D),
                  ),
                ),
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('visitTokens')
                    .doc(_token)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF9D5C7D),
                      ),
                    );
                  }

                  final data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final used = data['used'] == true;

                  // 🔁 Token used → generate new one
                  if (used) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _generateToken();
                    });
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.childQrPopupInstruction,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      QrImageView(
                        data: _token!,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  );
                },
              ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF9D5C7D),
            side: const BorderSide(color: Color(0xFF9D5C7D)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
