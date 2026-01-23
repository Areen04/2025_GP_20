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
final _genderFocus = FocusNode(); // optional
bool _dayTouched = false;
bool _monthTouched = false;
bool _yearTouched = false;
bool _genderTouched = false;

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedGender;
  bool _isLoading = false;
bool _hasInteracted = false;
bool _isNameValid = false;
bool _isSaving = false;

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
OutlineInputBorder _border(Color color) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: color, width: 1.5),
);
Color _getNameColor() {
  final text = _nameController.text.trim();

  // Before interacting → grey
  if (!_hasInteracted) return Colors.grey;

  // Focused
  if (_nameFocus.hasFocus) {
    // Focused + empty → purple
    if (text.isEmpty) return const Color(0xFF9D5C7D);
    // Focused + invalid → red
    if (text.length < 2) return Colors.red;
    // Focused + valid → green
    return const Color(0xFF9D5C7D);
  }

  // NOT focused
  if (text.isEmpty) return Colors.grey; // ← THIS IS THE FIX

  if (text.length >= 2) return Colors.grey;

  return Colors.red;
}
Color _dropdownColor({
  required String? value,
  required bool touched,
  required FocusNode focusNode,
}) {
  // Selected → green
  if (value != null) return Colors.grey;

  // Focused → purple
  if (focusNode.hasFocus) return const Color(0xFF9D5C7D);

  // If touched but no selection → grey
  if (touched) return Colors.grey;

  // Default
  return Colors.grey;
}

  // ---------------  Bottom Sheet to choose image source ---------------
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

  // ------------------------ SAVE CHILD ------------------------
  Future<void> _addChild() async {
    final name = _nameController.text.trim();
     if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Full name must be at least 2 characters.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF9D5C7D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
      );
      return; // ← IMPORTANT to stop adding
    }
   if (name.isEmpty ||
    _selectedDay == null ||
    _selectedMonth == null ||
    _selectedYear == null ||
    _selectedGender == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text("Please fill all required fields.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      backgroundColor: const Color(0xFF9D5C7D),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    ),
  );
  return;
}

// ❌ Prevent future date of birth
if (!_isValidDate()) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        "Date of birth cannot be in the future.",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      backgroundColor: const Color(0xFF9D5C7D),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    ),
  );
  return;
}


setState(() => _isSaving = true);

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
setState(() => _isSaving = false);
    }
  }

  // ------------------------------ UI ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.white,
  appBar: PreferredSize(
    preferredSize: const Size.fromHeight(70), // force same height as EditChild
    child: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      centerTitle: true,
      title: const Text(
        "Add Child",
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFE0E0E0),
        ),
      ),
    ),
  ),
body: GestureDetector(
  behavior: HitTestBehavior.translucent,
  onTap: () {
    FocusScope.of(context).unfocus();     // <-- FORCE unfocus
    setState(() {});                      // <-- refresh colors
  },
  child: SingleChildScrollView(
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
Focus(
  onFocusChange: (hasFocus) {
    if (!hasFocus) {
      setState(() {});
    }
  },
  child: TextField(
    controller: _nameController,
    focusNode: _nameFocus,
    onTap: () {
      setState(() => _hasInteracted = true);
    },
    onChanged: (_) {
      setState(() {
        _hasInteracted = true;
        _isNameValid = _nameController.text.trim().length >= 2;
      });
    },
    decoration: InputDecoration(
      hintText: "Enter child's full name",
      hintStyle: const TextStyle(color: Colors.black38),
      border: _border(Colors.grey),
      enabledBorder: _border(_getNameColor()),
      focusedBorder: _border(_getNameColor()),
    ),
  ),
),

            const SizedBox(height: 20),

           // ------------------ DOB ------------------
_buildLabel("Date of Birth"),
Row(
  children: [
    // Day
 Expanded(
  child: Focus(
    focusNode: _dayFocus,
    onFocusChange: (hasFocus) {
      if (hasFocus) {
        _dayTouched = true;
      }
      setState(() {});
    },
    child: DropdownMenu<String>(
      hintText: "Day",
      textStyle: const TextStyle(color: Colors.black87, fontSize: 14),

      menuStyle: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Color(0xFFFFF7FB)),
        surfaceTintColor: MaterialStatePropertyAll(Colors.white),
        elevation: MaterialStatePropertyAll(3),
        maximumSize: MaterialStatePropertyAll(Size.fromHeight(180)),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 6)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: Colors.grey),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.black38),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        filled: true,
        fillColor: Colors.white,

        border: _border(_dropdownColor(
          value: _selectedDay,
          touched: _dayTouched,
          focusNode: _dayFocus,
        )),
        enabledBorder: _border(_dropdownColor(
          value: _selectedDay,
          touched: _dayTouched,
          focusNode: _dayFocus,
        )),
        focusedBorder: _border(const Color(0xFF9D5C7D)),
      ),

      onSelected: (val) {
        FocusScope.of(context).unfocus();
        setState(() => _selectedDay = val);
      },

      dropdownMenuEntries: List.generate(
        31,
        (i) => DropdownMenuEntry(value: "${i + 1}", label: "${i + 1}"),
      ),
    ),
  ),
),
 const SizedBox(width: 8),

// Month
Expanded(
  child: Focus(
    focusNode: _monthFocus,
    onFocusChange: (hasFocus) {
      if (hasFocus) _monthTouched = true;
      setState(() {});
    },
    child: DropdownMenu<String>(
      hintText: "Month",
      textStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
        overflow: TextOverflow.visible,
      ),

      menuStyle: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Color(0xFFFFF7FB)),
        surfaceTintColor: MaterialStatePropertyAll(Colors.white),
        elevation: MaterialStatePropertyAll(3),
        maximumSize: MaterialStatePropertyAll(Size.fromHeight(180)),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 6)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: Colors.grey),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.black38),
        contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        filled: true,
        fillColor: Colors.white,

        border: _border(_dropdownColor(
          value: _selectedMonth,
          touched: _monthTouched,
          focusNode: _monthFocus,
        )),
        enabledBorder: _border(_dropdownColor(
          value: _selectedMonth,
          touched: _monthTouched,
          focusNode: _monthFocus,
        )),
        focusedBorder: _border(const Color(0xFF9D5C7D)),
      ),

      onSelected: (val) => setState(() => _selectedMonth = val),

      dropdownMenuEntries: List.generate(
        12,
        (i) => DropdownMenuEntry(value: "${i + 1}", label: "${i + 1}"),
      ),
    ),
  ),
),

    const SizedBox(width: 8),

    // Year
    Expanded(
  child: Focus(
    focusNode: _yearFocus,
    onFocusChange: (hasFocus) {
      if (hasFocus) _yearTouched = true;
      setState(() {});
    },
    child: DropdownMenu<String>(
      hintText: "Year",
      textStyle: const TextStyle(color: Colors.black87, fontSize: 14),

      menuStyle: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Color(0xFFFFF7FB)),
        surfaceTintColor: MaterialStatePropertyAll(Colors.white),
        elevation: MaterialStatePropertyAll(3),
        maximumSize: MaterialStatePropertyAll(Size.fromHeight(180)),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 6)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: Colors.grey),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.black38),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        filled: true,
        fillColor: Colors.white,

        border: _border(_dropdownColor(
          value: _selectedYear,
          touched: _yearTouched,
          focusNode: _yearFocus,
        )),
        enabledBorder: _border(_dropdownColor(
          value: _selectedYear,
          touched: _yearTouched,
          focusNode: _yearFocus,
        )),
        focusedBorder: _border(const Color(0xFF9D5C7D)),
      ),

      onSelected: (val) => setState(() => _selectedYear = val),

      dropdownMenuEntries: List.generate(
        10,
        (i) => DropdownMenuEntry(
          value: "${DateTime.now().year - i}",
          label: "${DateTime.now().year - i}",
        ),
      ),
    ),
  ),
),
 ],
),
const SizedBox(height: 20),

          // ------------------ Gender ------------------
_buildLabel("Gender"),
Focus(
  focusNode: _genderFocus,
  onFocusChange: (hasFocus) {
    if (hasFocus) _genderTouched = true;
    setState(() {});
  },
  child: DropdownMenu<String>(
    width: MediaQuery.of(context).size.width - 48,
    hintText: "Select gender",

    menuStyle: const MenuStyle(
      backgroundColor: MaterialStatePropertyAll(Color(0xFFFFF7FB)),
      surfaceTintColor: MaterialStatePropertyAll(Colors.white),
      elevation: MaterialStatePropertyAll(3),
      padding: MaterialStatePropertyAll(EdgeInsets.zero),
      maximumSize: MaterialStatePropertyAll(Size.fromHeight(120)),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

      border: _border(_dropdownColor(
        value: _selectedGender,
        touched: _genderTouched,
        focusNode: _genderFocus,
      )),
      enabledBorder: _border(_dropdownColor(
        value: _selectedGender,
        touched: _genderTouched,
        focusNode: _genderFocus,
      )),
      focusedBorder: _border(const Color(0xFF9D5C7D)),
    ),

    onSelected: (value) => setState(() => _selectedGender = value),

    dropdownMenuEntries: const [
      DropdownMenuEntry(value: "Male", label: "Male"),
      DropdownMenuEntry(value: "Female", label: "Female"),
    ],
  ),
),
const SizedBox(height: 20),

            // ------------------ Button ------------------
 _isSaving
    ? const CircularProgressIndicator(
        color: Color(0xFF9D5C7D),
      )
    : SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _addChild,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9D5C7D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Add Child",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
         ],
        ),
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
