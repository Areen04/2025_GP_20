import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'parent_dashboard.dart';

class EditChild extends StatefulWidget {
  final String childId;
  const EditChild({super.key, required this.childId});

  @override
  State<EditChild> createState() => _EditChildState();
}

class _EditChildState extends State<EditChild> {
  final _nameController = TextEditingController();
  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedGender;
  File? _image;
  String? _existingImageUrl;
  bool _isLoading = true;

  final picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  Future<void> _loadChildData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('children')
          .doc(widget.childId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          final birthDate = (data['birthDate'] ?? '').toString().split('-');
          if (birthDate.length == 3) {
            _selectedYear = birthDate[0];
            _selectedMonth = birthDate[1];
            _selectedDay = birthDate[2];
          }

          // ✅ نحول القيم اللي تجي من الفايرستور
          final genderData = data['gender']?.toString().toLowerCase();
          if (genderData == "female") {
            _selectedGender = "Female";
          } else if (genderData == "male") {
            _selectedGender = "Male";
          } else {
            _selectedGender = null; // نخليه فاضي عشان ما ينهار
          }

          _existingImageUrl = data['imageUrl'];
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Child not found.")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _saveChanges() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saving changes...")),
      );

      Map<String, dynamic> updates = {};

      // ✅ الاسم
      final name = _nameController.text.trim();
      if (name.isNotEmpty) updates['name'] = name;

      // ✅ تاريخ الميلاد
      if (_selectedDay != null &&
          _selectedMonth != null &&
          _selectedYear != null) {
        updates['birthDate'] =
        "${_selectedYear!}-${_selectedMonth!.padLeft(2, '0')}-${_selectedDay!.padLeft(2, '0')}";
      }

      // ✅ الجنس
      if (_selectedGender != null && _selectedGender!.isNotEmpty) {
        updates['gender'] = _selectedGender;
      }

      // ✅ الصورة
      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('children_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_image!);
        final newUrl = await ref.getDownloadURL();
        updates['imageUrl'] = newUrl;
      }

      // ✅ ما نحدث إلا إذا فيه شي تغيّر فعلاً
      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance
            .collection('children')
            .doc(widget.childId)
            .update(updates);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Changes saved successfully ✅")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No changes made.")),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving changes: $e")),
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ParentDashboard()),
            );
          },
        ),
        title: const Text(
          "Edit Child",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFF4E9EF),
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (_existingImageUrl != null
                          ? NetworkImage(_existingImageUrl!) as ImageProvider
                          : null),
                      child: (_image == null && _existingImageUrl == null)
                          ? const Icon(Icons.person,
                          size: 50, color: Colors.grey)
                          : null,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF9D5C7D),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Upload Photo",
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 30),

            _buildLabel("Child's Full Name"),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter child's full name",
                hintStyle: const TextStyle(color: Colors.black26),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("Date of Birth"),
            Row(
              children: [
                Expanded(
                    child: _buildDropdown(_selectedDay, _dayList,
                            (v) => setState(() => _selectedDay = v))),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildDropdown(_selectedMonth, _monthList,
                            (v) => setState(() => _selectedMonth = v))),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildDropdown(_selectedYear, _yearList,
                            (v) => setState(() => _selectedYear = v))),
              ],
            ),

            const SizedBox(height: 20),
            _buildLabel("Gender"),
            _buildDropdown(
              (["Male", "Female"].contains(_selectedGender))
                  ? _selectedGender
                  : "Female",
              ["Male", "Female"],
                  (v) => setState(() => _selectedGender = v),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D5C7D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String? value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: (value != null && ["Male", "Female"].contains(value)) ? value : null,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  final List<String> _dayList = List.generate(31, (i) => (i + 1).toString());
  final List<String> _monthList = List.generate(12, (i) => (i + 1).toString());
  final List<String> _yearList =
  List.generate(10, (i) => (2015 + i).toString());
}
