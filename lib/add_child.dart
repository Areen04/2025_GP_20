import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'parent_dashboard.dart';

class AddChild extends StatefulWidget {
  const AddChild({super.key});

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  File? _image;
  final picker = ImagePicker();
  final _nameController = TextEditingController();

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedGender;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addChild() async {
    final name = _nameController.text.trim();
    if (name.isEmpty ||
        _selectedDay == null ||
        _selectedMonth == null ||
        _selectedYear == null ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // حساب عمر الطفل
      final birthDate = DateTime(
        int.parse(_selectedYear!),
        int.parse(_selectedMonth!),
        int.parse(_selectedDay!),
      );
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      // الصورة اختيارية
      String? imageUrl;
      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('children_images/${name}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      // حفظ البيانات في فايرستور
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('children').add({
        'name': name,
        'gender': _selectedGender,
        'birthDate':
        "$_selectedYear-${_selectedMonth!.padLeft(2, '0')}-${_selectedDay!.padLeft(2, '0')}",
        'age': age,
        'imageUrl': imageUrl, // الصورة ممكن تكون null
        'parentId': user?.uid ?? 'unknown',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Child added successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ParentDashboard()),
            );
          },
        ),
        title: const Text(
          "Add Child",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ✅ صورة الطفل (اختيارية)
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFF4E9EF),
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.camera_alt_outlined,
                          size: 40, color: Color(0xFF9D5C7D))
                          : null,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF9D5C7D),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Upload Photo",
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 30),

            // اسم الطفل
            _buildLabel("Child's Full Name"),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter child's full name",
                hintStyle: const TextStyle(color: Colors.black38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // تاريخ الميلاد
            _buildLabel("Date of Birth"),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown("Day", _selectedDay,
                      List.generate(31, (i) => "${i + 1}"), (val) {
                        setState(() => _selectedDay = val);
                      }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown("Month", _selectedMonth,
                      List.generate(12, (i) => "${i + 1}"), (val) {
                        setState(() => _selectedMonth = val);
                      }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown("Year", _selectedYear,
                      List.generate(10, (i) => "${DateTime.now().year - i}"),
                          (val) {
                        setState(() => _selectedYear = val);
                      }),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // الجنس
            _buildLabel("Gender"),
            DropdownButtonFormField<String>(
              hint: const Text("Select gender"),
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Female", child: Text("Female")),
              ],
              onChanged: (value) => setState(() => _selectedGender = value),
            ),
            const SizedBox(height: 30),

            // الزر
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addChild,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D5C7D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Add Child",
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

  Widget _buildDropdown(String hint, String? value, List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      hint: Text(hint),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
