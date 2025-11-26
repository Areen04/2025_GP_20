import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'parent_dashboard.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class EditChild extends StatefulWidget {
  final String childId;
  const EditChild({super.key, required this.childId});

  @override
  State<EditChild> createState() => _EditChildState();
}

class _EditChildState extends State<EditChild> {
  final _nameController = TextEditingController();

  File? _image;
  String? _existingImageUrl;
  String? _originalName;
final _nameFocus = FocusNode();
bool _isNameValid = false;
  bool _isLoading = true;
  bool _hasChanges = false; // ← to enable/disable save button
bool _hasInteracted = false;
bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }
@override
void dispose() {
  _nameFocus.dispose();
  super.dispose();
}
  Future<void> _loadChildData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(uid)
          .collection('children')
          .doc(widget.childId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _originalName = data['name'];
          _existingImageUrl = data['imageUrl'];
          _isLoading = false;
          _isNameValid = _nameController.text.trim().length >= 2;

        });
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
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

  // Before typing → always grey
  if (!_hasInteracted) return Colors.grey;

  // Focused but empty → purple
  if (focusNode.hasFocus && text.isEmpty) {
    return const Color(0xFF9D5C7D);
  }

  // Empty (not focused) → grey
  if (text.isEmpty) return Colors.grey;

  // Valid but unchanged → purple
  if (valid && text == _originalName) {
    return const Color(0xFF9D5C7D);
  }

  
  if (valid) return const Color(0xFF9D5C7D);

  // Invalid → red
  return Colors.red;
}

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Color(0xFF9D5C7D)),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF9D5C7D)),
              title: const Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);

    if (picked != null) {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        picked.path,
        picked.path + "_compressed.jpg",
        quality: 60,
      );

      setState(() {
        _image = File(compressed?.path ?? picked.path);
        _hasChanges = true;
      });
    }
  }

  Future<void> _saveChanges() async {
  try {
    setState(() => _isSaving = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    Map<String, dynamic> updates = {};
    final name = _nameController.text.trim();

    if (name.isNotEmpty && name != _originalName) {
      updates['name'] = name;
    }

    if (updates.isNotEmpty) {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(uid)
          .collection('children')
          .doc(widget.childId)
          .update(updates);
    }

    if (_image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('children_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(_image!);
      final newUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('parents')
          .doc(uid)
          .collection('children')
          .doc(widget.childId)
          .update({'imageUrl': newUrl});
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ParentDashboard()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    if (mounted) {
      setState(() => _isSaving = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: CircularProgressIndicator(color: Color(0xFF9D5C7D))),
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
        "Edit Child",
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
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ParentDashboard(),
            ),
          );
        },
      ),
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
    child: Column(
      children: [
            // --- BODY ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    /// Circle image picker
                    GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF3E6EC),
                                ),
                                child: ClipOval(
                                  child: _image != null
                                      ? Image.file(
                                          _image!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : (_existingImageUrl != null &&
                                              _existingImageUrl!.isNotEmpty
                                          ? Image.network(
                                              _existingImageUrl!,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'lib/icons/child.png',
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )),
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF9D5C7D),
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    const Icon(Icons.add, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Upload Photo",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                 Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      "Child's Full Name",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    const SizedBox(height: 6), // ← SAME AS PARENT SIGNUP

    TextField(
      controller: _nameController,
      focusNode: _nameFocus,
      onTap: () {
        setState(() {
          _hasInteracted = true;
        });
      },
      onChanged: (_) {
        setState(() {
          _hasInteracted = true;
          _isNameValid = _nameController.text.trim().length >= 2;
          _hasChanges = _isNameValid &&
              _nameController.text.trim() != _originalName;
        });
      },
      decoration: InputDecoration(
        hintText: "Enter child's full name",
        hintStyle: const TextStyle(color: Colors.black26),
        border: _border(Colors.grey),
        enabledBorder:
            _border(_getColor(_isNameValid, _nameController, _nameFocus)),
        focusedBorder:
            _border(_getColor(_isNameValid, _nameController, _nameFocus)),
      ),
    ),
  ],
),


                    const SizedBox(height: 40),

             _isSaving
    ? const CircularProgressIndicator(
        color: Color(0xFF9D5C7D),
      )
    : SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _hasChanges ? _saveChanges : null,
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
              color: _hasChanges ? Colors.white : Colors.black38,
            ),
          ),
        ),
      ),
],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
