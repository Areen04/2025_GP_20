import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './ChildDashboard.dart';
import 'add_child.dart';
import 'edit_profile.dart';
import 'edit_child.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  String? parentName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadParentData();
  }

  Future<void> _loadParentData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          parentName = doc['fullName'] ?? 'Parent';
          _loading = false;
        });
      } else {
        setState(() {
          parentName = 'Parent';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        parentName = 'Parent';
        _loading = false;
      });
    }
  }

  Future<void> _deleteChild(String childId) async {
    final l10n = AppLocalizations.of(context);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(uid)
          .collection('children')
          .doc(childId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.childDeletedSuccess,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF9D5C7D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.errorDeletingChild(e.toString()),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color(0xFF9D5C7D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
 Future<void> _showConfirmDeleteChild({
  required String message,
  required Future<void> Function() onConfirm,
}) async {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        l10n.deleteChildTitle,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          color: Color(0xFF9D5C7D), // purple title
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.black54,
        ),
      ),
      actions: [
        // Cancel button → just text purple, no background
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: Color(0xFF9D5C7D)), // purple text
          ),
        ),
        // Yes button → white background, purple text & border
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF9D5C7D),
            side: const BorderSide(color: Color(0xFF9D5C7D)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await onConfirm();
          },
          child: Text(l10n.yes),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined, color: Color(0xFF9D5C7D)),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfile()),
            );
            _loadParentData();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF9D5C7D)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F5F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.helloParent(parentName ?? l10n.parentTab),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.parentGreeting,
                            style: const TextStyle(
                              color: Color(0xFF6F6F6F),
                              fontSize: 13,
                              height: 1.3,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ✅ StreamBuilder بعد التعديل فقط في الـ path
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('parents')
                          .doc(uid)
                          .collection('children')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              l10n.noChildrenYet,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          );
                        }

                        final children = snapshot.data!.docs;

                        return Column(
                          children: children.map((child) {
                            final data = child.data() as Map<String, dynamic>;
                            final name = data['name'] ?? 'Unknown';
                            final imageUrl = data['imageUrl'];

                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChildDashboard(
                                        childId: child.id,
                                        childName: name,
                                        imageUrl: imageUrl,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                },
                                leading: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: const Color(0xFFF4E9EF),
                                  backgroundImage: imageUrl != null
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage('lib/icons/child.png') as ImageProvider,
                                ),
                                title: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xFF9D5C7D),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditChild(childId: child.id),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Color(0xFF9D5C7D),
                                      ),
                                      onPressed: () {
                                        _showConfirmDeleteChild(
                                          message: l10n.deleteChildConfirm,
                                          onConfirm: () async {
                                            await _deleteChild(child.id);
                                          },
                                        );
                                      },


                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddChild()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9D5C7D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n.addNewChild,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
