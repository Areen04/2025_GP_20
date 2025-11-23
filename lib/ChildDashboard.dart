import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ai_skin_analysis_page.dart';
import 'DevelopmentalMilestonesTwoMonth.dart';
import 'DevelopmentalMilestonesFourMonth.dart';
import 'DevelopmentalMilestonesSixMonth.dart';
import 'DevelopmentalMilestonesNineMonth.dart';
import 'DevelopmentalMilestonesOneYear.dart';
import 'DevelopmentalMilestonesFifteenMonth.dart';
import 'DevelopmentalMilestones18month.dart';
import 'DevelopmentalMilestones24month.dart';
import 'DevelopmentalMilestones30month.dart';
import 'DevelopmentalMilestones3year.dart';
import 'DevelopmentalMilestones4year.dart';
import 'DevelopmentalMilestones5year.dart';

class ChildDashboard extends StatefulWidget {
  final String childId;
  final String childName;
  final String? imageUrl;

  const ChildDashboard({
    super.key,
    required this.childId,
    required this.childName,
    this.imageUrl,
  });

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard> {
  String? childAge;
  String? updatedImageUrl;
  bool _loading = true;
  final List<GlobalKey> _ageKeys = List.generate(12, (_) => GlobalKey());

int getAgeIndex(int totalMonths) {
  if (totalMonths <= 2) return 0;
  if (totalMonths <= 4) return 1;
  if (totalMonths <= 6) return 2;
  if (totalMonths <= 9) return 3;
  if (totalMonths <= 12) return 4;
  if (totalMonths <= 15) return 5;
  if (totalMonths <= 18) return 6;
  if (totalMonths <= 24) return 7;
  if (totalMonths <= 30) return 8;
  if (totalMonths <= 36) return 9;
  if (totalMonths <= 48) return 10;
  return 11;
}

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

Future<void> _loadChildData() async {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final doc = await FirebaseFirestore.instance
        .collection('parents')
        .doc(uid)
        .collection('children')
        .doc(widget.childId)
        .get();

    if (doc.exists) {
      DateTime? birthDate;
      final data = doc.data()!;
      final newImage = data['imageUrl'];

      if (data['birthDate'] is Timestamp) {
        birthDate = (data['birthDate'] as Timestamp).toDate();
      } else if (data['birthDate'] is String) {
        birthDate = DateTime.tryParse(data['birthDate']);
      }

      setState(() {
        updatedImageUrl = newImage ?? widget.imageUrl;

        if (birthDate != null) {
          // 🔥 NEW improved age calculator
          final ageData = _calculateAge(birthDate);

          int totalMonths = ageData["totalMonths"];  
          childAge = ageData["display"];              // pretty text for UI

          // 🔥 Auto-select correct milestone index
          int index = getAgeIndex(totalMonths);
          selectedIndex = index;
          viewIndex = index;

        } else {
          childAge = "Unknown";
        }

        _loading = false;
      });
    } else {
      setState(() {
        childAge = "Unknown";
        _loading = false;
      });
    }
  } catch (e) {
    setState(() {
      childAge = "Unknown";
      _loading = false;
    });
  }

  // 🔥 Center the selected age after layout is built
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _scrollToIndex(selectedIndex);
  });
}

 Map<String, dynamic> _calculateAge(DateTime birthDate) {
  final now = DateTime.now();

  int years = now.year - birthDate.year;
  int months = now.month - birthDate.month;

  if (months < 0) {
    years--;
    months += 12;
  }

  int totalMonths = years * 12 + months;

  // Pretty string
  String displayText;

  if (years == 0) {
    displayText = "$months months";
  } else if (months == 0) {
    displayText = "$years years";
  } else {
    displayText = "$years years, $months months";
  }

  return {
    "totalMonths": totalMonths,
    "display": displayText,
  };
}

  final List<String> ages = [
    '2M',
    '4M',
    '6M',
    '9M',
    '1Y',
    '15M',
    '18M',
    '2Y',
    '30M',
    '3Y',
    '4Y',
    '5Y'
  ];

  int selectedIndex = 7;
  int viewIndex = 7;
  final ScrollController _scrollController = ScrollController();

  void nextAge() {
  if (viewIndex < ages.length - 1) {
    setState(() {
      viewIndex++;
      selectedIndex = viewIndex;   // 🔥 update pink indicator & content
    });
    _scrollToIndex(viewIndex);
  }
}

void previousAge() {
  if (viewIndex > 0) {
    setState(() {
      viewIndex--;
      selectedIndex = viewIndex;   // 🔥 update pink indicator & content
    });
    _scrollToIndex(viewIndex);
  }
}


 void _scrollToIndex(int index) {
  // Run after render to measure item sizes
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      try {
        // Find the RenderBox of the item at this index
        final key = _ageKeys[index];
        final context = key.currentContext;

        if (context == null) return;

        final box = context.findRenderObject() as RenderBox;
        final itemWidth = box.size.width;

        final itemOffset = box.localToGlobal(Offset.zero, ancestor: context.findAncestorRenderObjectOfType<RenderBox>()).dx;

        final screenWidth = MediaQuery.of(context).size.width;

        // Center calculation
        final targetOffset = itemOffset + (itemWidth / 2) - (screenWidth / 2);

        // Clamp to valid scroll bounds
        final safeOffset = targetOffset.clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );

        _scrollController.animateTo(
          safeOffset,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        // Fallback: smooth scroll using index * 45
        _scrollController.animateTo(
          index * 45.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    }
  });
}

  void selectAge(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth * 0.075;
    double cardPadding = screenWidth * 0.035;
    double fontSizeTitle = screenWidth * 0.035;
    double fontSizeSubtitle = screenWidth * 0.030;

    return Scaffold(
      backgroundColor: Colors.white,
     appBar: PreferredSize(
  preferredSize: const Size.fromHeight(70),
  child: AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.white,
    centerTitle: true,

    title: Text(
      widget.childName,
      style: const TextStyle(
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
        size: 23, // ← bigger like the EditProfile header
      ),
      onPressed: () => Navigator.pop(context),
    ),

    actions: const [
      SizedBox(width: 18), // same spacing as EditProfile
    ],

    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        height: 1,
        color: const Color(0xFFE0E0E0),
      ),
    ),
  ),
),
   body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            // 🩷 بطاقة الطفل
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
  color: const Color(0xFFF8F5F6),
  borderRadius: BorderRadius.circular(8),
),
   child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFFF4E9EF),
                        backgroundImage: (updatedImageUrl != null &&
                                updatedImageUrl!.isNotEmpty)
                            ? NetworkImage(updatedImageUrl!)
                            : const AssetImage('lib/icons/child.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.childName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          _loading
                              ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF9D5C7D),
                                  ),
                                )
                              : Text(
                                  childAge ?? "Unknown",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6F6F6F),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.qr_code_2_outlined,
                      color: Color(0xFF9D5C7D),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // 🩷 Health Journey
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
          decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8),
  border: Border.all(color: Colors.grey.shade300),
),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Health Journey",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _arrowButton(
                        Icons.arrow_back_ios_new_rounded,
                        previousAge,
                        isDisabled: viewIndex == 0,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                           SingleChildScrollView(
  controller: _scrollController,
  scrollDirection: Axis.horizontal,
  physics: const NeverScrollableScrollPhysics(), // ❌ disables swiping
child: Row(
  children: ages.asMap().entries.map((entry) {
    final index = entry.key;
    final age = entry.value;
    final isSelected = index == selectedIndex;

    return Container(
      key: _ageKeys[index],   // 🔥 THIS must wrap the item
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: isSelected ? 4 : 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC9A2B8) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          age,
          style: TextStyle(
            color:
                isSelected ? Colors.white : const Color(0xFF5E5E5E),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }).toList(),
),
),
                           const SizedBox(height: 14),
                            Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F2F2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor:
                                      (selectedIndex + 1) / ages.length,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF9D5C7D),
                                          Color(0xFFC9A2B8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _arrowButton(
                        Icons.arrow_forward_ios_rounded,
                        nextAge,
                        isDisabled: viewIndex == ages.length - 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 🟣 كروت المربعات الأربع
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
              children: [
                _DashboardCard(
                  iconPath: 'lib/icons/signpost.svg',
                  title: "Developmental Milestones",
                  subtitle: "Monitor your child's growth and learning",
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  onTap: () {
                    final selectedAge = ages[selectedIndex];

                    if (selectedAge == '2M') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DevelopmentalMilestonesTwoMonth(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '4M') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DevelopmentalMilestonesFourMonth(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '6M') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DevelopmentalMilestonesSixMonth(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '9M') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DevelopmentalMilestonesNineMonth(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '1Y') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DevelopmentalMilestonesOneYear(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '15M') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DevelopmentalMilestonesFifteenMonth(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '18M') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DevelopmentalMilestones18month(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '2Y') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DevelopmentalMilestones24month(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '30M') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DevelopmentalMilestones30month(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '3Y') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DevelopmentalMilestones3year(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '4Y') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DevelopmentalMilestones4year(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else if (selectedAge == '5Y') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DevelopmentalMilestones5year(
                            childId: widget.childId,
                            childName: widget.childName,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Milestones for this age are coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/scan.svg',
                  title: "AI Skin Analysis",
                  subtitle: "Upload photos for health insights",
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AiSkinAnalysisPage(
                          childId: widget.childId,
                          childName: widget.childName,
                        ),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/stethoscope.svg',
                  title: "Medical Conditions",
                  subtitle: "Overview of medical conditions",
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/book.svg',
                  title: "Activity Library",
                  subtitle: "Engaging learning resources and curated content.",
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _arrowButton(
    IconData icon,
    VoidCallback onPressed, {
    bool isDisabled = false,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          shape: BoxShape.circle,
          border: isDisabled
              ? Border.all(color: Colors.grey.shade300, width: 1)
              : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled ? Colors.grey.shade400 : const Color(0xFF9D5C7D),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final double iconSize;
  final double padding;
  final double fontSizeTitle;
  final double fontSizeSubtitle;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.iconSize,
    required this.padding,
    required this.fontSizeTitle,
    required this.fontSizeSubtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding + 6,
        ),
        decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8),
  border: Border.all(color: Colors.grey.shade300),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ],
),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(
                Color(0xFF9D5C7D),
                BlendMode.srcIn,
              ),
              width: iconSize,
              height: iconSize,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF9D5C7D),
                fontSize: fontSizeTitle,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6F6F6F),
                fontSize: fontSizeSubtitle,
                height: 1.3,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
