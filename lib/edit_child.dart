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

  bool _isLoading = true;
  bool _hasChanges = false; // ← لتفعيل/تعطيل زر الحفظ

  @override
  void initState() {
    super.initState();
    _loadChildData();
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
        });
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  // فتح خيارات الكاميرا/الستوديو
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
      // Compress image before using it
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


  // حفظ التعديلات
  Future<void> _saveChanges() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saving changes...")),
      );

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      Map<String, dynamic> updates = {};

      final name = _nameController.text.trim();

      // لو الاسم تغيّر
      if (name.isNotEmpty && name != _originalName) {
        updates['name'] = name;
      }

      // نحفظ التعديلات الأساسية أول (بدون الصورة)
      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance
            .collection('parents')
            .doc(uid)
            .collection('children')
            .doc(widget.childId)
            .update(updates);
      }


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );


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

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFF9D5C7D))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9D5C7D)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ParentDashboard()),
            );
          },
        ),
        title: const Text(
          "Edit Child",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// دائرة تعديل الصورة
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
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Upload Photo",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Child's Full Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            TextField(
              controller: _nameController,
              onChanged: (_) {
                setState(() {
                  _hasChanges = true; // ← صار تغيير
                });
              },
              decoration: InputDecoration(
                hintText: "Enter child's full name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _hasChanges ? _saveChanges : null, // ← تعطيل الزر
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _hasChanges ? const Color(0xFF9D5C7D) : Colors.grey.shade300,
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
    );
  }
}
