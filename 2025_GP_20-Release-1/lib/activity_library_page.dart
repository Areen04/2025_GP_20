import 'package:flutter/material.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';

const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

String firebase(String path) =>
    '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';

class ActivityLibraryPage extends StatelessWidget {
  final String ageKey;

  const ActivityLibraryPage({
    super.key,
    required this.ageKey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final activities = activityData[ageKey] ?? [];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent, // prevent pink title
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            l10n.activityLibraryTitle,
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
              size: 23,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              for (var item in activities) ...[
                ActivityCard(
                  title: _activityTitle(l10n, item['titleKey']!),
                  imageUrl: firebase('activities/${item['image']}'),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _activityTitle(AppLocalizations l10n, String key) {
  switch (key) {
    case 'act_2m_1':
      return l10n.act_2m_1;
    case 'act_2m_2':
      return l10n.act_2m_2;
    case 'act_2m_3':
      return l10n.act_2m_3;
    case 'act_2m_4':
      return l10n.act_2m_4;
    case 'act_2m_5':
      return l10n.act_2m_5;
    case 'act_2m_6':
      return l10n.act_2m_6;
    case 'act_4m_1':
      return l10n.act_4m_1;
    case 'act_4m_2':
      return l10n.act_4m_2;
    case 'act_4m_3':
      return l10n.act_4m_3;
    case 'act_4m_4':
      return l10n.act_4m_4;
    case 'act_4m_5':
      return l10n.act_4m_5;
    case 'act_4m_6':
      return l10n.act_4m_6;
    case 'act_6m_1':
      return l10n.act_6m_1;
    case 'act_6m_2':
      return l10n.act_6m_2;
    case 'act_6m_3':
      return l10n.act_6m_3;
    case 'act_6m_4':
      return l10n.act_6m_4;
    case 'act_6m_5':
      return l10n.act_6m_5;
    case 'act_6m_6':
      return l10n.act_6m_6;
    case 'act_9m_1':
      return l10n.act_9m_1;
    case 'act_9m_2':
      return l10n.act_9m_2;
    case 'act_9m_3':
      return l10n.act_9m_3;
    case 'act_9m_4':
      return l10n.act_9m_4;
    case 'act_9m_5':
      return l10n.act_9m_5;
    case 'act_9m_6':
      return l10n.act_9m_6;
    case 'act_1y_1':
      return l10n.act_1y_1;
    case 'act_1y_2':
      return l10n.act_1y_2;
    case 'act_1y_3':
      return l10n.act_1y_3;
    case 'act_1y_4':
      return l10n.act_1y_4;
    case 'act_1y_5':
      return l10n.act_1y_5;
    case 'act_1y_6':
      return l10n.act_1y_6;
    case 'act_15m_1':
      return l10n.act_15m_1;
    case 'act_15m_2':
      return l10n.act_15m_2;
    case 'act_15m_3':
      return l10n.act_15m_3;
    case 'act_15m_4':
      return l10n.act_15m_4;
    case 'act_15m_5':
      return l10n.act_15m_5;
    case 'act_15m_6':
      return l10n.act_15m_6;
    case 'act_18m_1':
      return l10n.act_18m_1;
    case 'act_18m_2':
      return l10n.act_18m_2;
    case 'act_18m_3':
      return l10n.act_18m_3;
    case 'act_18m_4':
      return l10n.act_18m_4;
    case 'act_18m_5':
      return l10n.act_18m_5;
    case 'act_18m_6':
      return l10n.act_18m_6;
    case 'act_2y_1':
      return l10n.act_2y_1;
    case 'act_2y_2':
      return l10n.act_2y_2;
    case 'act_2y_3':
      return l10n.act_2y_3;
    case 'act_2y_4':
      return l10n.act_2y_4;
    case 'act_2y_5':
      return l10n.act_2y_5;
    case 'act_2y_6':
      return l10n.act_2y_6;
    case 'act_30m_1':
      return l10n.act_30m_1;
    case 'act_30m_2':
      return l10n.act_30m_2;
    case 'act_30m_3':
      return l10n.act_30m_3;
    case 'act_30m_4':
      return l10n.act_30m_4;
    case 'act_30m_5':
      return l10n.act_30m_5;
    case 'act_30m_6':
      return l10n.act_30m_6;
    case 'act_3y_1':
      return l10n.act_3y_1;
    case 'act_3y_2':
      return l10n.act_3y_2;
    case 'act_3y_3':
      return l10n.act_3y_3;
    case 'act_3y_4':
      return l10n.act_3y_4;
    case 'act_3y_5':
      return l10n.act_3y_5;
    case 'act_3y_6':
      return l10n.act_3y_6;
    case 'act_4y_1':
      return l10n.act_4y_1;
    case 'act_4y_2':
      return l10n.act_4y_2;
    case 'act_4y_3':
      return l10n.act_4y_3;
    case 'act_4y_4':
      return l10n.act_4y_4;
    case 'act_4y_5':
      return l10n.act_4y_5;
    case 'act_4y_6':
      return l10n.act_4y_6;
    case 'act_5y_1':
      return l10n.act_5y_1;
    case 'act_5y_2':
      return l10n.act_5y_2;
    case 'act_5y_3':
      return l10n.act_5y_3;
    case 'act_5y_4':
      return l10n.act_5y_4;
    case 'act_5y_5':
      return l10n.act_5y_5;
    case 'act_5y_6':
      return l10n.act_5y_6;
    default:
      return key;
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ActivityCard({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Text with extra padding like Milestones
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
                height: 1.4, // match milestone card spacing
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================
//  ALL ACTIVITIES DATA
// ==========================
final Map<String, List<Map<String, String>>> activityData = {
  "2M": [
    {"titleKey": "act_2m_1", "image": "2m-1.jpg"},
    {"titleKey": "act_2m_2", "image": "2m-2.jpg"},
    {"titleKey": "act_2m_3", "image": "2m-3.jpg"},
    {"titleKey": "act_2m_4", "image": "2m-4.jpg"},
    {"titleKey": "act_2m_5", "image": "2m-5.jpg"},
    {"titleKey": "act_2m_6", "image": "2m-6.jpg"},
  ],

  "4M": [
    {"titleKey": "act_4m_1", "image": "4m-1.jpg"},
    {"titleKey": "act_4m_2", "image": "4m-2.jpg"},
    {"titleKey": "act_4m_3", "image": "4m-3.jpg"},
    {"titleKey": "act_4m_4", "image": "4m-4.jpg"},
    {"titleKey": "act_4m_5", "image": "4m-5.jpg"},
    {"titleKey": "act_4m_6", "image": "4m-6.jpg"},
  ],

  "6M": [
    {"titleKey": "act_6m_1", "image": "6m-1.jpg"},
    {"titleKey": "act_6m_2", "image": "6m-2.jpg"},
    {"titleKey": "act_6m_3", "image": "6m-3.jpg"},
    {"titleKey": "act_6m_4", "image": "6m-4.jpg"},
    {"titleKey": "act_6m_5", "image": "6m-5.jpg"},
    {"titleKey": "act_6m_6", "image": "6m-6.jpg"},
  ],

  "9M": [
    {"titleKey": "act_9m_1", "image": "9m-1.jpg"},
    {"titleKey": "act_9m_2", "image": "9m-2.jpg"},
    {"titleKey": "act_9m_3", "image": "9m-3.jpg"},
    {"titleKey": "act_9m_4", "image": "9m-4.jpg"},
    {"titleKey": "act_9m_5", "image": "9m-5.jpg"},
    {"titleKey": "act_9m_6", "image": "9m-6.jpg"},
  ],

  "1Y": [
    {"titleKey": "act_1y_1", "image": "1y-1.jpg"},
    {"titleKey": "act_1y_2", "image": "1y-2.jpg"},
    {"titleKey": "act_1y_3", "image": "1y-3.jpg"},
    {"titleKey": "act_1y_4", "image": "1y-4.jpg"},
    {"titleKey": "act_1y_5", "image": "1y-5.jpg"},
    {"titleKey": "act_1y_6", "image": "1y-6.jpg"},
  ],

  "15M": [
    {"titleKey": "act_15m_1", "image": "15m-1.jpg"},
    {"titleKey": "act_15m_2", "image": "15m-2.jpg"},
    {"titleKey": "act_15m_3", "image": "15m-3.jpg"},
    {"titleKey": "act_15m_4", "image": "15m-4.jpg"},
    {"titleKey": "act_15m_5", "image": "15m-5.jpg"},
    {"titleKey": "act_15m_6", "image": "15m-6.jpg"},
  ],

  "18M": [
    {"titleKey": "act_18m_1", "image": "18m-1.jpg"},
    {"titleKey": "act_18m_2", "image": "18m-2.jpg"},
    {"titleKey": "act_18m_3", "image": "18m-3.jpg"},
    {"titleKey": "act_18m_4", "image": "18m-4.jpg"},
    {"titleKey": "act_18m_5", "image": "18m-5.jpg"},
    {"titleKey": "act_18m_6", "image": "18m-6.jpg"},
  ],

  "2Y": [
    {"titleKey": "act_2y_1", "image": "2y-1.jpg"},
    {"titleKey": "act_2y_2", "image": "2y-2.jpg"},
    {"titleKey": "act_2y_3", "image": "2y-3.jpg"},
    {"titleKey": "act_2y_4", "image": "2y-4.jpg"},
    {"titleKey": "act_2y_5", "image": "2y-6.jpg"},
    {"titleKey": "act_2y_6", "image": "2y-7.jpg"},
  ],

  "30M": [
    {"titleKey": "act_30m_1", "image": "30m-1.jpg"},
    {"titleKey": "act_30m_2", "image": "30m-2.jpg"},
    {"titleKey": "act_30m_3", "image": "30m-4.jpg"},
    {"titleKey": "act_30m_4", "image": "30m-5.jpg"},
    {"titleKey": "act_30m_5", "image": "30m-6.jpg"},
    {"titleKey": "act_30m_6", "image": "30m-7.jpg"},
  ],

  "3Y": [
    {"titleKey": "act_3y_1", "image": "3y-1.jpg"},
    {"titleKey": "act_3y_2", "image": "3y-3.jpg"},
    {"titleKey": "act_3y_3", "image": "3y-4.jpg"},
    {"titleKey": "act_3y_4", "image": "3y-5.jpg"},
    {"titleKey": "act_3y_5", "image": "3y-6.jpg"},
    {"titleKey": "act_3y_6", "image": "3y-7.jpg"},
  ],

  "4Y": [
    {"titleKey": "act_4y_1", "image": "4y-1.jpg"},
    {"titleKey": "act_4y_2", "image": "4y-2.jpg"},
    {"titleKey": "act_4y_3", "image": "4y-4.jpg"},
    {"titleKey": "act_4y_4", "image": "4y-5.jpg"},
    {"titleKey": "act_4y_5", "image": "4y-6.jpg"},
    {"titleKey": "act_4y_6", "image": "4y-7.jpg"},
  ],

  "5Y": [
    {"titleKey": "act_5y_1", "image": "5y-1.jpg"},
    {"titleKey": "act_5y_2", "image": "5y-2.jpg"},
    {"titleKey": "act_5y_3", "image": "5y-3.jpg"},
    {"titleKey": "act_5y_4", "image": "5y-4.jpg"},
    {"titleKey": "act_5y_5", "image": "5y-5.jpg"},
    {"titleKey": "act_5y_6", "image": "5y-7.jpg"},
  ],
};
