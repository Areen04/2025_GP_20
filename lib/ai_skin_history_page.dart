import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AiSkinHistoryPage extends StatefulWidget {
  final String childId;
  final String? childName;
  final String? parentId;

  const AiSkinHistoryPage({
    super.key,
    required this.childId,
    this.childName,
    this.parentId,
  });

  @override
  State<AiSkinHistoryPage> createState() => _AiSkinHistoryPageState();
}

class _AiSkinHistoryPageState extends State<AiSkinHistoryPage> {
  String? _resolvedParentId;
  bool _findingParent = false;

  @override
  void initState() {
    super.initState();
    _resolvedParentId = widget.parentId;
    if (_resolvedParentId == null) {
      _findParentId();
    }
  }

  Future<void> _findParentId() async {
    setState(() => _findingParent = true);
    try {
      final parentsSnap =
          await FirebaseFirestore.instance.collection('parents').get();
      for (final parent in parentsSnap.docs) {
        final childDoc = await FirebaseFirestore.instance
            .collection('parents')
            .doc(parent.id)
            .collection('children')
            .doc(widget.childId)
            .get();
        if (childDoc.exists) {
          if (!mounted) return;
          setState(() {
            _resolvedParentId = parent.id;
            _findingParent = false;
          });
          return;
        }
      }
    } catch (_) {
      // ignore, fall through
    }
    if (!mounted) return;
    setState(() => _findingParent = false);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.childName == null || widget.childName!.isEmpty
        ? "Past AI Skin Analyses"
        : "${widget.childName} • Past AI Skin Analyses";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Past AI Skin Analyses",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF9D5C7D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _resolvedParentId == null
          ? Center(
              child: _findingParent
                  ? const CircularProgressIndicator(color: Color(0xFF9D5C7D))
                  : const Text("Parent not found for this child."),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('parents')
                  .doc(_resolvedParentId)
                  .collection('children')
                  .doc(widget.childId)
                  .collection('skinHistory')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF9D5C7D)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No AI skin analysis history yet.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final items = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 14),
                        ],
                      );
                    }

                    final data = items[index - 1].data()
                        as Map<String, dynamic>? ??
                        {};

                    final label = (data['label'] ?? "Unknown").toString();
                    final dateStr = (data['date'] ?? "").toString();
                    DateTime? date;
                    if (dateStr.isNotEmpty) {
                      date = DateTime.tryParse(dateStr);
                    }
                    final dateText = date != null
                        ? DateFormat('dd/MM/yyyy').format(date)
                        : "Unknown date";

                    ImageProvider? imageProvider;
                    final img = data['image'];
                    if (img is String && img.isNotEmpty) {
                      try {
                        imageProvider = MemoryImage(base64Decode(img));
                      } catch (_) {
                        imageProvider = null;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _HistoryCard(
                        dateText: dateText,
                        label: label,
                        imageProvider: imageProvider,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String dateText;
  final String label;
  final ImageProvider? imageProvider;

  const _HistoryCard({
    required this.dateText,
    required this.label,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: imageProvider != null
                  ? Image(
                      image: imageProvider!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: const Color(0xFFF0E6EC),
                      child: const Center(
                        child: Icon(Icons.image_not_supported_outlined,
                            color: Color(0xFF9D5C7D), size: 32),
                      ),
                    ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.45),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateText,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
