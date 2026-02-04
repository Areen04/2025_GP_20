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
  final _nameFocus = FocusNode();
  final _dayFocus = FocusNode();
  final _monthFocus = FocusNode();
  final _yearFocus = FocusNode();
  final _genderFocus = FocusNode();

  bool _dayTouched = false;
  bool _monthTouched = false;
  bool _yearTouched = false;
  bool _genderTouched = false;

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedGender;

  bool _isSaving = false;
  bool _hasInteracted = false;

  bool _isValidDate() {
    if (_selectedYear == null ||
        _selectedMonth == null ||
        _selectedDay == null) return true;

    final selected = DateTime(
      int.parse(_selectedYear!),
      int.parse(_selectedMonth!),
      int.parse(_selectedDay!),
    );

    return !selected.isAfter(DateTime.now());
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  Color _getNameColor() {
    final text = _nameController.text.trim();
    if (!_hasInteracted) return Colors.grey;
    if (_nameFocus.hasFocus) {
      if (text.isEmpty) return const Color(0xFF9D5C7D);
      if (text.length < 2) return Colors.red;
      return const Color(0xFF9D5C7D);
    }
    if (text.isEmpty) return Colors.grey;
    if (text.length >= 2) return Colors.grey;
    return Colors.red;
  }

  Color _dropdownColor({
    required String? value,
    required bool touched,
    required FocusNode focusNode,
  }) {
    if (value != null) return Colors.grey;
    if (focusNode.hasFocus) return const Color(0xFF9D5C7D);
    if (touched) return Colors.grey;
    return Colors.grey;
  }

  // ---------------- Image Picker ----------------
  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
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

  // ---------------- Save Child ----------------
  Future<void> _addChild() async {
    final name = _nameController.text.trim();

    if (name.length < 2 ||
        _selectedDay == null ||
        _selectedMonth == null ||
        _selectedYear == null ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields."),
        ),
      );
      return;
    }

    if (!_isValidDate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Date of birth cannot be in the future."),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final birthDate = DateTime(
        int.parse(_selectedYear!),
        int.parse(_selectedMonth!),
        int.parse(_selectedDay!),
      );

      int age = DateTime.now().year - birthDate.year;

      String? imageUrl;
      if (_image != null) {
        final ref = FirebaseStorage.instance.ref().child(
            'children_images/${name}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ParentDashboard()),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Child")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImagePickerOptions,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xFFF4E9EF),
                child: _image == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : ClipOval(
                  child: Image.file(
                    _image!,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // -------- Name (Required)
            _buildLabel("Child's Full Name"),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              onTap: () => setState(() => _hasInteracted = true),
              onChanged: (_) => setState(() => _hasInteracted = true),
              decoration: InputDecoration(
                border: _border(_getNameColor()),
                focusedBorder: _border(_getNameColor()),
              ),
            ),

            const SizedBox(height: 20),

            // -------- DOB (Required)
            _buildLabel("Date of Birth"),
            Row(
              children: [
                Expanded(
                  child: DropdownMenu<String>(
                    hintText: "Day",
                    onSelected: (v) => setState(() => _selectedDay = v),
                    dropdownMenuEntries: List.generate(
                      31,
                          (i) => DropdownMenuEntry(
                          value: "${i + 1}", label: "${i + 1}"),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownMenu<String>(
                    hintText: "Month",
                    onSelected: (v) => setState(() => _selectedMonth = v),
                    dropdownMenuEntries: List.generate(
                      12,
                          (i) => DropdownMenuEntry(
                          value: "${i + 1}", label: "${i + 1}"),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownMenu<String>(
                    hintText: "Year",
                    onSelected: (v) => setState(() => _selectedYear = v),
                    dropdownMenuEntries: List.generate(
                      10,
                          (i) => DropdownMenuEntry(
                        value: "${DateTime.now().year - i}",
                        label: "${DateTime.now().year - i}",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // -------- Gender (Required)
            _buildLabel("Gender"),
            DropdownMenu<String>(
              hintText: "Select gender",
              onSelected: (v) => setState(() => _selectedGender = v),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: "Male", label: "Male"),
                DropdownMenuEntry(value: "Female", label: "Female"),
              ],
            ),

            const SizedBox(height: 30),

            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _addChild,
              child: const Text("Add Child"),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Label with red star ----------------
  Widget _buildLabel(String text, {bool required = true}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: RichText(
          text: TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            children: required
                ? const [
              TextSpan(
                text: " *",
                style: TextStyle(
                  color: Colors.red, // ⭐ النجمة الحمراء
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]
                : [],
          ),
        ),
      ),
    );
  }
}
