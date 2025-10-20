import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'parent_dashboard.dart';

class EditChild extends StatefulWidget {
  const EditChild({super.key});

  @override
  State<EditChild> createState() => _EditChildState();
}

class _EditChildState extends State<EditChild> {
  File? _image;
  final picker = ImagePicker();

  final _nameController = TextEditingController(text: "Mira Ahmed");
  String? _selectedDay = "12";
  String? _selectedMonth = "8";
  String? _selectedYear = "2023";
  String? _selectedGender = "Female";

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Changes saved successfully")),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
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
                      backgroundImage:
                      _image != null ? FileImage(_image!) : null,
                      child: _image == null
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
                      child: const Icon(Icons.add,
                          color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Upload Photo",
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 30),

            // Child Name
            _buildLabel("Child's Full Name"),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter child's full name",
                hintStyle: const TextStyle(color: Colors.black26),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Date of Birth
            _buildLabel("Date of Birth"),
            Row(
              children: [
                Expanded(
                    child: _buildDropdown(
                        _selectedDay, _dayList, (v) => setState(() => _selectedDay = v))),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildDropdown(
                        _selectedMonth, _monthList, (v) => setState(() => _selectedMonth = v))),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildDropdown(
                        _selectedYear, _yearList, (v) => setState(() => _selectedYear = v))),
              ],
            ),

            const SizedBox(height: 20),

            // Gender
            _buildLabel("Gender"),
            _buildDropdown(
                _selectedGender, ["Male", "Female"], (v) => setState(() => _selectedGender = v)),

            const SizedBox(height: 40),

            // Save button
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

  Widget _buildDropdown(String? value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
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

  final List<String> _dayList = List.generate(31, (i) => (i + 1).toString());
  final List<String> _monthList = List.generate(12, (i) => (i + 1).toString());
  final List<String> _yearList = List.generate(10, (i) => (2015 + i).toString());
}
