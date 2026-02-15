import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class VisitTokenService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<String> createToken(String childId) async {
    final token = const Uuid().v4();

    await _firestore.collection('visitTokens').doc(token).set({
      'childId': childId,
      'used': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return token;
  }

  static Future<String?> consumeToken(String token) async {
    final ref = _firestore.collection('visitTokens').doc(token);
    final snap = await ref.get();

    if (!snap.exists) return null;
    if (snap['used'] == true) return null;

    await ref.update({'used': true});

    return snap['childId'];
  }
}
