import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('parents').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['fullName'] ?? '';
      } else {
        _nameController.text = user.displayName ?? '';
      }
    } catch (e) {
      _showSnackBar("Error loading profile: $e", isError: true);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      _showSnackBar("Name cannot be empty", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await user.updateDisplayName(newName);

      await _firestore.collection('parents').doc(user.uid).set({
        'uid': user.uid,
        'fullName': newName,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullName': newName,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _showSnackBar("Profile updated successfully");
    } catch (e) {
      _showSnackBar("Error updating profile: $e", isError: true);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _showResetPasswordDialog() async {
    final email = _auth.currentUser?.email ?? "";
    final controller = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              try {
                await _auth.sendPasswordResetEmail(
                    email: controller.text.trim());
                if (!mounted) return;
                Navigator.pop(context);
                _showSnackBar(
                    "Reset link sent to ${controller.text.trim()}");
              } catch (e) {
                _showSnackBar("Error: $e", isError: true);
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAction({
    required String title,
    required String message,
    required Future<void> Function() onConfirm,
  }) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF9D5C7D),
              side: const BorderSide(color: Color(0xFF9D5C7D)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await onConfirm();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    await _confirmAction(
      title: "Delete Account",
      message:
      "Are you sure you want to delete your account permanently?",
      onConfirm: () async {
        final user = _auth.currentUser;
        if (user == null) return;

        try {
          await _firestore.collection('parents').doc(user.uid).delete();
          await user.delete();
          await _auth.signOut();

          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
          );
        } catch (e) {
          _showSnackBar("Error deleting account: $e", isError: true);
        }
      },
    );
  }

  Future<void> _logout() async {
    await _confirmAction(
      title: "Log out",
      message: "Are you sure you want to log out?",
      onConfirm: () async {
        await _auth.signOut();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor:
        isError ? Colors.redAccent : const Color(0xFF9D5C7D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF9D5C7D)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: _logout,
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                "Log out",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Full Name"),
              TextField(
                controller: _nameController,
                onChanged: (_) => setState(() {}),
                decoration: _inputDecoration("Enter your full name"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _nameController.text.trim().isEmpty
                      ? null
                      : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _nameController.text.trim().isEmpty
                        ? Colors.grey.shade300
                        : const Color(0xFF9D5C7D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: _nameController.text.trim().isEmpty
                          ? Colors.black38
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Account Actions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _showResetPasswordDialog,
                      child: Row(
                        children: const [
                          Icon(Icons.lock_outline,
                              size: 20, color: Color(0xFF9D5C7D)),
                          SizedBox(width: 8),
                          Text(
                            "Change Password",
                            style: TextStyle(
                              color: Color(0xFF9D5C7D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _deleteAccount,
                      child: const Text(
                        "Delete Account",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black26),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
