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

  bool _isValidDate() {
    if (_selectedYear == null ||
        _selectedMonth == null ||
        _selectedDay == null) return true;

    final selected = DateTime(
      int.parse(_selectedYear!),
      int.parse(_selectedMonth!),
      int.parse(_selectedDay!),
    );

    final today = DateTime.now();

    return selected.isBefore(today) || selected.isAtSameMomentAs(today);
  }

  // ---------------  Bottom Sheet to choose image source ---------------
  Future<void> _showImagePickerOptions() async {
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
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // ------------------------ SAVE CHILD ------------------------
  Future<void> _addChild() async {
    final name = _nameController.text.trim();
    if (name.isEmpty ||
        _selectedDay == null ||
        _selectedMonth == null ||
        _selectedYear == null ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Please fill all required fields.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF9D5C7D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in.");

      // حساب العمر
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

      // رفع الصورة
      String? imageUrl;
      if (_image != null) {
        final ref = FirebaseStorage.instance.ref().child(
            'children_images/${name}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      // حفظ البيانات في فايرستور
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(user.uid)
          .collection('children')
          .add({
        'name': name,
        'gender': _selectedGender,
        'birthDate':
        "$_selectedYear-${_selectedMonth!.padLeft(2, '0')}-${_selectedDay!.padLeft(2, '0')}",
        'age': age,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Child added successfully!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF9D5C7D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
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

  // ------------------------------ UI ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF9D5C7D),
          ),

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

            // ------------------ Upload Photo Circle ------------------
            GestureDetector(
              onTap: _showImagePickerOptions,
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFF4E9EF),


                      child: _image == null
                          ? const Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Color(0xFF9D5C7D),
                      )
                          : ClipOval(
                        child: Image.file(
                          _image!,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // زر الـ (+)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF9D5C7D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            const Text("Upload Photo", style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 30),


            // ------------------ Name ------------------
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

            // ------------------ DOB ------------------
            _buildLabel("Date of Birth"),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    "Day",
                    _selectedDay,
                    List.generate(31, (i) => "${i + 1}"),
                        (val) {
                      setState(() => _selectedDay = val);

                      if (!_isValidDate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You cannot select a future date."),
                            backgroundColor: Colors.redAccent,
                          ),
                        );

                        setState(() => _selectedDay = null);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    "Month",
                    _selectedMonth,
                    List.generate(12, (i) => "${i + 1}"),
                        (val) {
                      setState(() => _selectedMonth = val);

                      if (!_isValidDate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You cannot select a future date."),
                            backgroundColor: Colors.redAccent,
                          ),
                        );

                        setState(() => _selectedMonth = null);
                      }
                    },

                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    "Year",
                    _selectedYear,
                    List.generate(10, (i) => "${DateTime.now().year - i}"),
                        (val) {
                      setState(() => _selectedYear = val);

                      if (!_isValidDate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You cannot select a future date."),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        setState(() => _selectedYear = null);
                      }
                    },

                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------ Gender ------------------
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

            // ------------------ Button ------------------
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

  // ------------------------ Helpers ------------------------
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
      String hint, String? value, List<String> items, Function(String?) onChanged) {
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
