import 'package:flutter/material.dart';

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
          title: const Text(
            "Activity Library",
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
                  title: item['title']!,
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
    {"title": "Make eye contact and smile at your baby", "image": "2m-1.jpg"},
    {"title": "Talk to your baby during feeding and diaper changes", "image": "2m-2.jpg"},
    {"title": "Copy your baby’s sounds and wait for a response", "image": "2m-3.jpg"},
    {"title": "Place a baby-safe mirror for face exploration", "image": "2m-4.jpg"},
    {"title": "Give short supervised tummy time", "image": "2m-5.jpg"},
    {"title": "Show high-contrast images or faces", "image": "2m-6.jpg"},
  ],

  "4M": [
    {"title": "Move a toy slowly for your baby to follow with their eyes", "image": "4m-1.jpg"},
    {"title": "Let your baby reach for nearby toys", "image": "4m-2.jpg"},
    {"title": "Shake a rattle and let your baby track the sound", "image": "4m-3.jpg"},
    {"title": "Sing songs while gently moving arms and legs", "image": "4m-4.jpg"},
    {"title": "Play on a floor mat with toys around the baby", "image": "4m-5.jpg"},
    {"title": "Encourage kicking by placing toys near the feet", "image": "4m-6.jpg"},
  ],

  "6M": [
    {"title": "Support your baby in sitting while playing with toys", "image": "6m-1.jpg"},
    {"title": "Place toys just out of reach to encourage rolling", "image": "6m-2.jpg"},
    {"title": "Name objects your baby looks at", "image": "6m-3.jpg"},
    {"title": "Let your baby drop objects and watch them fall", "image": "6m-4.jpg"},
    {"title": "Explore textures with safe household items", "image": "6m-5.jpg"},
    {"title": "Play music and let your baby listen and react", "image": "6m-6.jpg"},
  ],

  "9M": [
    {"title": "Hide a toy under a cloth and let your baby find it", "image": "9m-1.jpg"},
    {"title": "Encourage crawling by placing toys farther away", "image": "9m-2.jpg"},
    {"title": "Practice simple gestures like waving", "image": "9m-3.jpg"},
    {"title": "Pass toys back and forth in turn-taking play", "image": "9m-4.jpg"},
    {"title": "Let your baby pull to stand using safe furniture", "image": "9m-5.jpg"},
    {"title": "Dump toys from a container and refill it together", "image": "9m-6.jpg"},
  ],

  "1Y": [
    {"title": "Read picture books and name familiar objects", "image": "1y-1.jpg"},
    {"title": "Encourage walking using push toys", "image": "1y-2.jpg"},
    {"title": "Let your child bang pots or simple instruments", "image": "1y-3.jpg"},
    {"title": "Respond with words when your child points", "image": "1y-4.jpg"},
    {"title": "Play imitation games (clapping, waving)", "image": "1y-5.jpg"},
    {"title": "Expand on your child’s single words", "image": "1y-6.jpg"},
  ],

  "15M": [
    {"title": "Stack blocks and knock them down together", "image": "15m-1.jpg"},
    {"title": "Play simple pretend with stuffed animals", "image": "15m-2.jpg"},
    {"title": "Sing songs with actions (hands, feet, head)", "image": "15m-3.jpg"},
    {"title": "Let your child help put toys away", "image": "15m-4.jpg"},
    {"title": "Offer crayons for scribbling", "image": "15m-5.jpg"},
    {"title": "Practice drinking from a cup and using a spoon", "image": "15m-6.jpg"},
  ],

  "18M": [
    {"title": "Name body parts during play", "image": "18m-1.jpg"},
    {"title": "Roll a ball back and forth", "image": "18m-2.jpg"},
    {"title": "Offer two choices and let your child decide", "image": "18m-3.jpg"},
    {"title": "Encourage pretend play with dolls or toy food", "image": "18m-4.jpg"},
    {"title": "Blow bubbles and let your child pop them", "image": "18m-5.jpg"},
    {"title": "Talk about simple emotions using words", "image": "18m-6.jpg"},
  ],

  "2Y": [
    {"title": "Do simple puzzles together", "image": "2y-1.jpg"},
    {"title": "Let your child help with easy chores", "image": "2y-2.jpg"},
    {"title": "Play with sand or water using cups", "image": "2y-3.jpg"},
    {"title": "Kick and throw balls outdoors", "image": "2y-4.jpg"},
    {"title": "Draw with crayons or finger paint", "image": "2y-6.jpg"},
    {"title": "Build towers with blocks", "image": "2y-7.jpg"},
  ],

  "30M": [
    {"title": "Encourage play with other children", "image": "30m-1.jpg"},
    {"title": "Ask simple questions about pictures or stories", "image": "30m-2.jpg"},
    {"title": "Sort objects by size or color", "image": "30m-4.jpg"},
    {"title": "Use chalk or washable paint for drawing", "image": "30m-5.jpg"},
    {"title": "Pretend play using boxes or household items", "image": "30m-6.jpg"},
    {"title": "Practice sharing during play", "image": "30m-7.jpg"},
  ],

  "3Y": [
    {"title": "Play counting games using everyday objects", "image": "3y-1.jpg"},
    {"title": "Match shapes or pictures", "image": "3y-3.jpg"},
    {"title": "Play with playdough", "image": "3y-4.jpg"},
    {"title": "Act out short stories together", "image": "3y-5.jpg"},
    {"title": "Talk about feelings and calming down", "image": "3y-6.jpg"},
    {"title": "Help your child say their name and age", "image": "3y-7.jpg"},
  ],

  "4Y": [
    {"title": "Play board or matching games with simple rules", "image": "4y-1.jpg"},
    {"title": "Count objects during daily activities", "image": "4y-2.jpg"},
    {"title": "Role-play new situations (doctor, school)", "image": "4y-4.jpg"},
    {"title": "Play outdoor group games", "image": "4y-5.jpg"},
    {"title": "Help with simple chores", "image": "4y-6.jpg"},
    {"title": "Practice turn-taking during play", "image": "4y-7.jpg"},
  ],

  "5Y": [
    {"title": "Play memory or attention games", "image": "5y-1.jpg"},
    {"title": "Do rhyming word games", "image": "5y-2.jpg"},
    {"title": "Build with complex blocks or construction toys", "image": "5y-3.jpg"},
    {"title": "Solve simple problems during play", "image": "5y-4.jpg"},
    {"title": "Encourage independent daily tasks", "image": "5y-5.jpg"},
    {"title": "Prepare for school routines through play", "image": "5y-7.jpg"},
  ],
};
