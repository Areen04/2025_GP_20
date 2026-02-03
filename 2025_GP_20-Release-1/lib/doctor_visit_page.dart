import 'package:flutter/material.dart';

class DoctorVisitPage extends StatelessWidget {
  final String childId;

  const DoctorVisitPage({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF9D5C7D)),
        title: const Text(
          "Child Visit",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Info box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Visit in progress",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Child ID: $childId",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6F6F6F),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Placeholder content
            const Text(
              "This page will contain:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "• Child health summary\n"
              "• Growth chart\n"
              "• Vaccination confirmation\n"
              "• Medical reports (OCR)\n"
              "• Finish visit button",
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: Color(0xFF6F6F6F),
                fontFamily: 'Inter',
              ),
            ),

            const Spacer(),

            // 🔹 Finish visit (disabled for now)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null, // 🔒 disabled for now
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Finish Visit",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
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
