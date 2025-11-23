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
  final _nameFocus = FocusNode();

  bool _isLoading = true;
  bool _isSaving = false;

  String? _originalName;
  bool _hasChanges = false;
  bool _hasInteracted = false;
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    super.dispose();
  }

Future<void> _loadProfile() async {
  final user = _auth.currentUser;
  if (user == null) return;

  try {
    // 1) Try parents collection
    final parentDoc =
        await _firestore.collection('parents').doc(user.uid).get();

    if (parentDoc.exists) {
      _nameController.text = parentDoc['fullName'] ?? '';
      _originalName = parentDoc['fullName'] ?? '';
    } else {
      // 2) If not parent → try users collection (for doctors)
      final doctorDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doctorDoc.exists) {
        _nameController.text = doctorDoc['fullName'] ?? '';
        _originalName = doctorDoc['fullName'] ?? '';
      } else {
        // 3) Fallback to FirebaseAuth displayName
        _nameController.text = user.displayName ?? '';
        _originalName = user.displayName ?? '';
      }
    }
  } catch (e) {
    _showSnackBar("Error loading profile: $e", isError: true);
  }

  setState(() {
    _isLoading = false;
    _isNameValid = _nameController.text.trim().length >= 2;
  });
}

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1.5),
      );

  Color _getColor(
    bool valid,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    final text = controller.text.trim();

    if (!_hasInteracted) return Colors.grey;

    if (focusNode.hasFocus && text.isEmpty) {
      return const Color(0xFF9D5C7D);
    }

    if (text.isEmpty) return Colors.grey;

    if (valid && text == _originalName) {
      return const Color(0xFF9D5C7D);
    }

    if (valid) return const Color(0xFF9D5C7D);

    return Colors.red;
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newName = _nameController.text.trim();

    if (newName.isEmpty) {
      _showSnackBar("Name cannot be empty", isError: true);
      return;
    }

    setState(() => _isSaving = true);

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

      _originalName = newName;
      _hasChanges = false;
    } catch (e) {
      _showSnackBar("Error updating profile: $e", isError: true);
    }

    setState(() => _isSaving = false);
  }

  Future<void> _showResetPasswordDialog() async {
  final email = _auth.currentUser?.email ?? "";

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text(
          "Reset Password",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xFF9D5C7D),
          ),
        ),
        content: Text(
          "A password reset link will be sent to:\n$email\nPress Send to continue.",
          style: const TextStyle(
            fontFamily: 'Inter',
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF9D5C7D),
              side: const BorderSide(color: Color(0xFF9D5C7D)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              try {
                await _auth.sendPasswordResetEmail(email: email);
                if (!mounted) return;
                Navigator.pop(context);
                _showSnackBar("Password reset link sent to $email");
              } catch (e) {
                _showSnackBar("Error: $e", isError: true);
              }
            },
            child: const Text("Send"),
          ),
        ],
      );
    },
  );
}

 Future<void> _confirmAction({
  required String title,
  required String message,
  required Future<void> Function() onConfirm,
}) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xFF9D5C7D),
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF9D5C7D),
              side: const BorderSide(color: Color(0xFF9D5C7D)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await onConfirm();
            },
            child: const Text("Yes"),
          ),
        ],
      );
    },
  );
}

  Future<void> _deleteAccount() async {
    await _confirmAction(
      title: "Delete Account",
      message: "Are you sure you want to delete your account permanently?",
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

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: true,

          title: const Text(
            "Settings",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF9D5C7D),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          actions: [
            GestureDetector(
              onTap: _logout,
              child: const Padding(
                padding: EdgeInsets.only(right: 18),
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

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: const Color(0xFFE0E0E0),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),

              // ---- LABEL ----
              const Text(
                "Full Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),

              // ---- TEXT FIELD (same as EditChild) ----
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                onTap: () {
                  setState(() => _hasInteracted = true);
                },
                onChanged: (_) {
                  setState(() {
                    _hasInteracted = true;
                    _isNameValid =
                        _nameController.text.trim().length >= 2;
                    _hasChanges = _isNameValid &&
                        _nameController.text.trim() != _originalName;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter your full name",
                  hintStyle: const TextStyle(color: Colors.black26),
                  border: _border(Colors.grey),
                  enabledBorder: _border(_getColor(
                    _isNameValid,
                    _nameController,
                    _nameFocus,
                  )),
                  focusedBorder: _border(_getColor(
                    _isNameValid,
                    _nameController,
                    _nameFocus,
                  )),
                ),
              ),

              const SizedBox(height: 40),

              // ---- SAVE BUTTON ----
              _isSaving
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF9D5C7D),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _hasChanges ? _updateProfile : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasChanges
                              ? const Color(0xFF9D5C7D)
                              : Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _hasChanges
                                ? Colors.white
                                : Colors.black38,
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
}
