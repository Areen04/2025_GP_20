import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';

class DoctorMilestonesOverviewPage extends StatefulWidget {
  final String childId;
  final String childName;
  final String parentId;
  final DateTime birthDate;

  const DoctorMilestonesOverviewPage({
    super.key,
    required this.childId,
    required this.childName,
    required this.parentId,
    required this.birthDate,
  });

  @override
  State<DoctorMilestonesOverviewPage> createState() =>
      _DoctorMilestonesOverviewPageState();
}

class _DoctorMilestonesOverviewPageState
    extends State<DoctorMilestonesOverviewPage> {
  bool _loading = true;
  int _ageMonths = 0;
  int _bucketMonths = 0;
  Map<String, bool> _completed = {};

  @override
  void initState() {
    super.initState();
    _loadMilestones();
  }

  Future<void> _loadMilestones() async {
    final ageMonths = _calculateAgeInMonths(widget.birthDate);
    final bucket = _bucketForMonths(ageMonths);
    final docIds = _docIdsForBucket(bucket);

    final completed = <String, bool>{};
    for (final docId in docIds) {
      final doc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(widget.parentId)
          .collection('children')
          .doc(widget.childId)
          .collection('milestones')
          .doc(docId)
          .get();
      if (!doc.exists || doc.data() == null) continue;
      doc.data()!.forEach((key, value) {
        if (value == true) completed[key] = true;
      });
    }

    if (!mounted) return;
    setState(() {
      _ageMonths = ageMonths;
      _bucketMonths = bucket;
      _completed = completed;
      _loading = false;
    });
  }

  int _calculateAgeInMonths(DateTime birthDate) {
    final now = DateTime.now();
    int months = (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) months--;
    return months;
  }

  int _bucketForMonths(int months) {
    if (months <= 2) return 2;
    if (months <= 4) return 4;
    if (months <= 6) return 6;
    if (months <= 9) return 9;
    if (months <= 12) return 12;
    if (months <= 15) return 15;
    if (months <= 18) return 18;
    if (months <= 24) return 24;
    if (months <= 30) return 30;
    if (months <= 36) return 36;
    if (months <= 48) return 48;
    return 60;
  }

  List<String> _docIdsForBucket(int bucket) {
    switch (bucket) {
      case 2:
        return ['2_months'];
      case 4:
        return ['4_months', '15_months'];
      case 6:
        return ['6_months', '15_months'];
      case 9:
        return ['9_months', '15_months'];
      case 12:
        return ['1_year', '15_months'];
      case 15:
        return ['15_months'];
      case 18:
        return ['18_months'];
      case 24:
        return ['24_month'];
      case 30:
        return ['30_months'];
      case 36:
        return ['3_years'];
      case 48:
        return ['4_years'];
      case 60:
        return ['5_years'];
      default:
        return ['2_months'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final expectedDate =
        DateTime(widget.birthDate.year, widget.birthDate.month + _bucketMonths,
            widget.birthDate.day);
    final expectedText = DateFormat('MMM yyyy', locale).format(expectedDate);

    final sections = _sectionsForBucket(l10n, _bucketMonths);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            l10n.milestonesOverviewTitle,
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
              size: 23,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: const Color(0xFFE0E0E0)),
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF9D5C7D)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...sections.map((section) {
                    final delayed = section.items
                        .where((item) => _completed[item] != true)
                        .toList();
                    return _DelayedSectionCard(
                      title: section.title,
                      delayedItems: delayed,
                      expectedText: expectedText,
                    );
                  }),
                ],
              ),
            ),
    );
  }
}

class _SectionDef {
  final String title;
  final List<String> items;
  const _SectionDef({required this.title, required this.items});
}

class _DelayedSectionCard extends StatefulWidget {
  final String title;
  final List<String> delayedItems;
  final String expectedText;

  const _DelayedSectionCard({
    required this.title,
    required this.delayedItems,
    required this.expectedText,
  });

  @override
  State<_DelayedSectionCard> createState() => _DelayedSectionCardState();
}

class _DelayedSectionCardState extends State<_DelayedSectionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey("${widget.title}-$_expanded"),
          initiallyExpanded: _expanded,
          onExpansionChanged: (open) {
            setState(() => _expanded = open);
          },
          collapsedIconColor: const Color(0xFF9D5C7D),
          iconColor: const Color(0xFF9D5C7D),
          trailing: AnimatedRotation(
            turns: _expanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 32,
              color: Color(0xFF9D5C7D),
            ),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          children: widget.delayedItems.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      l10n.doctorMilestonesNoDelayed,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                  ),
                ]
              : widget.delayedItems
                  .map((item) => _DelayedMilestoneRow(
                        title: item,
                        expectedText: widget.expectedText,
                      ))
                  .toList(),
        ),
      ),
    );
  }
}

class _DelayedMilestoneRow extends StatelessWidget {
  final String title;
  final String expectedText;

  const _DelayedMilestoneRow({
    required this.title,
    required this.expectedText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE6E0E3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)
                      .doctorMilestonesExpected(expectedText),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Color(0xFF6F6F6F),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.redAccent),
            ),
            child: Text(
              AppLocalizations.of(context).doctorMilestonesDelayed,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<_SectionDef> _sectionsForBucket(AppLocalizations l10n, int bucket) {
  switch (bucket) {
    case 2:
      return [
        _SectionDef(title: l10n.ms_two_month_social_emotional, items: [
          l10n.ms_two_month_calms_down_when_spoken_to_or_picked_up,
          l10n.ms_two_month_looks_at_your_face,
          l10n.ms_two_month_seems_happy_to_see_you_when_you_walk_up_to_her,
          l10n.ms_two_month_smiles_when_you_talk_to_or_smile_at_her,
        ]),
        _SectionDef(title: l10n.ms_two_month_speech_language, items: [
          l10n.ms_two_month_makes_cooing_sounds,
          l10n.ms_two_month_reacts_to_loud_sounds,
        ]),
        _SectionDef(title: l10n.ms_two_month_cognitive_development, items: [
          l10n.ms_two_month_watches_you_as_you_move,
          l10n.ms_two_month_looks_at_a_toy_for_several_seconds,
        ]),
        _SectionDef(title: l10n.ms_two_month_movement_physical_development, items: [
          l10n.ms_two_month_holds_head_up_when_on_tummy,
          l10n.ms_two_month_moves_both_arms_and_both_legs,
          l10n.ms_two_month_opens_hands_briefly,
        ]),
      ];
    case 4:
      return [
        _SectionDef(title: l10n.ms_four_month_social_emotional, items: [
          l10n.ms_four_month_smiles_on_his_own_to_get_your_attention,
          l10n.ms_four_month_chuckles_not_a_full_laugh_when_you_try_to_make_her_laugh,
          l10n.ms_four_month_looks_at_you_moves_or_makes_sounds_to_get_your_attention,
        ]),
        _SectionDef(title: l10n.ms_four_month_speech_language, items: [
          l10n.ms_four_month_makes_sounds_like_ooo_aahh_cooing,
          l10n.ms_four_month_makes_sounds_back_when_you_talk_to_her,
          l10n.ms_four_month_turns_head_towards_sound_of_your_voice,
        ]),
        _SectionDef(title: l10n.ms_four_month_cognitive_development, items: [
          l10n.ms_four_month_if_hungry_opens_mouth_when_she_sees_breast_or_bottle,
          l10n.ms_four_month_looks_at_hands_with_interest,
        ]),
        _SectionDef(title: l10n.ms_four_month_movement_physical_development, items: [
          l10n.ms_four_month_holds_head_steady_without_support,
          l10n.ms_four_month_holds_a_toy_when_you_put_it_in_her_hand,
          l10n.ms_four_month_uses_arm_to_swing_at_toys,
          l10n.ms_four_month_brings_hands_to_mouth,
          l10n.ms_four_month_pushes_up_onto_elbows_forearms_when_on_tummy,
        ]),
      ];
    case 6:
      return [
        _SectionDef(title: l10n.ms_six_month_social_emotional, items: [
          l10n.ms_six_month_knows_familiar_people,
          l10n.ms_six_month_likes_to_look_at_herself_in_a_mirror,
          l10n.ms_six_month_laughs,
        ]),
        _SectionDef(title: l10n.ms_six_month_speech_language, items: [
          l10n.ms_six_month_takes_turns_making_sounds_with_you,
          l10n.ms_six_month_blows_raspberries,
          l10n.ms_six_month_makes_squealing_noises,
        ]),
        _SectionDef(title: l10n.ms_six_month_cognitive_development, items: [
          l10n.ms_six_month_puts_things_in_her_mouth_to_explore_them,
          l10n.ms_six_month_reaches_to_grab_a_toy_she_wants,
          l10n.ms_six_month_closes_lips_to_show_she_doesn_t_want_more_food,
        ]),
        _SectionDef(title: l10n.ms_six_month_movement_physical_development, items: [
          l10n.ms_six_month_rolls_from_tummy_to_back,
          l10n.ms_six_month_pushes_up_with_straight_arms_when_on_tummy,
          l10n.ms_six_month_leans_on_hands_to_support_herself_when_sitting,
        ]),
      ];
    case 9:
      return [
        _SectionDef(title: l10n.ms_nine_month_social_emotional, items: [
          l10n.ms_nine_month_is_shy_clingy_or_fearful_around_strangers,
          l10n.ms_nine_month_shows_facial_expressions_like_happy_sad_angry_and_surprised,
          l10n.ms_nine_month_looks_when_you_call_her_name,
        ]),
        _SectionDef(title: l10n.ms_nine_month_language_communication, items: [
          l10n.ms_nine_month_makes_sounds_like_mamama_or_babababa,
        ]),
        _SectionDef(title: l10n.ms_nine_month_cognitive_development, items: [
          l10n.ms_nine_month_looks_for_objects_when_dropped_out_of_sight,
        ]),
        _SectionDef(title: l10n.ms_nine_month_movement_physical_development, items: [
          l10n.ms_nine_month_gets_to_a_sitting_position_by_herself,
          l10n.ms_nine_month_sits_without_support,
        ]),
      ];
    case 12:
      return [
        _SectionDef(title: l10n.ms_one_year_social_emotional, items: [
          l10n.ms_one_year_waves_bye_bye,
          l10n.ms_one_year_plays_pat_a_cake_with_you,
        ]),
        _SectionDef(title: l10n.ms_one_year_language_communication, items: [
          l10n.ms_one_year_says_mama_or_dada,
          l10n.ms_one_year_understands_no,
        ]),
        _SectionDef(title: l10n.ms_one_year_cognitive_development, items: [
          l10n.ms_one_year_puts_things_in_a_container,
          l10n.ms_one_year_looks_for_hidden_toys,
        ]),
        _SectionDef(title: l10n.ms_one_year_movement_physical_development, items: [
          l10n.ms_one_year_pulls_up_to_stand,
          l10n.ms_one_year_walks_holding_furniture,
          l10n.ms_one_year_drinks_from_a_cup,
          l10n.ms_one_year_uses_thumb_finger_to_pick_things,
        ]),
      ];
    case 15:
      return [
        _SectionDef(title: l10n.ms_fifteen_month_social_emotional, items: [
          l10n.ms_fifteen_month_copies_other_children_while_playing_like_taking_toys_out_of_,
          l10n.ms_fifteen_month_shows_you_an_object_she_likes,
          l10n.ms_fifteen_month_claps_when_excited,
          l10n.ms_fifteen_month_hugs_stuffed_doll_or_other_toy,
          l10n.ms_fifteen_month_shows_affection,
        ]),
        _SectionDef(title: l10n.ms_fifteen_month_language_communication, items: [
          l10n.ms_fifteen_month_tries_to_say_one_or_two_words_besides_mama_or_dada,
          l10n.ms_fifteen_month_looks_at_familiar_objects_when_named,
          l10n.ms_fifteen_month_follows_directions_with_both_a_gesture_and_words,
          l10n.ms_fifteen_month_points_to_ask_for_something,
        ]),
        _SectionDef(title: l10n.ms_fifteen_month_cognitive_development, items: [
          l10n.ms_fifteen_month_uses_things_the_right_way_phone_cup,
          l10n.ms_fifteen_month_stacks_two_objects,
        ]),
        _SectionDef(title: l10n.ms_fifteen_month_movement_physical_development, items: [
          l10n.ms_fifteen_month_takes_a_few_steps_on_her_own,
          l10n.ms_fifteen_month_feeds_herself_using_fingers,
        ]),
      ];
    case 18:
      return [
        _SectionDef(title: l10n.ms_18month_social_emotional, items: [
          l10n.ms_18month_moves_away_from_you_but_looks_to_make_sure_you_are_close_by,
          l10n.ms_18month_points_to_show_you_something_interesting,
          l10n.ms_18month_puts_hands_out_for_you_to_wash_them,
          l10n.ms_18month_looks_at_a_few_pages_in_a_book_with_you,
          l10n.ms_18month_helps_you_dress_by_pushing_arm_through_sleeve_or_lifting_up_,
        ]),
        _SectionDef(title: l10n.ms_18month_speech_language, items: [
          l10n.ms_18month_tries_to_say_three_or_more_words_besides_mama_or_dada,
          l10n.ms_18month_follows_one_step_directions_without_gestures_like_give_it_to,
        ]),
        _SectionDef(title: l10n.ms_18month_cognitive_development, items: [
          l10n.ms_18month_copies_you_doing_chores_like_sweeping_with_a_broom,
          l10n.ms_18month_plays_with_toys_in_a_simple_way_like_pushing_a_toy_car,
        ]),
        _SectionDef(title: l10n.ms_18month_movement_physical_development, items: [
          l10n.ms_18month_walks_without_holding_on_to_anyone_or_anything,
          l10n.ms_18month_scribbles,
          l10n.ms_18month_drinks_from_a_cup_without_a_lid_and_may_spill_sometimes,
          l10n.ms_18month_feeds_herself_with_her_fingers,
          l10n.ms_18month_tries_to_use_a_spoon,
          l10n.ms_18month_climbs_on_and_off_a_couch_or_chair_without_help,
        ]),
      ];
    case 24:
      return [
        _SectionDef(title: l10n.ms_24month_social_emotional, items: [
          l10n.ms_24month_notices_when_others_are_hurt_or_upset_like_pausing_or_lookin,
          l10n.ms_24month_looks_at_your_face_to_see_how_to_react_in_a_new_situation,
        ]),
        _SectionDef(title: l10n.ms_24month_speech_language, items: [
          l10n.ms_24month_points_to_things_in_a_book_when_you_ask_like_where_is_the_be,
          l10n.ms_24month_says_at_least_two_words_together_like_more_milk,
          l10n.ms_24month_points_to_at_least_two_body_parts_when_you_ask_him_to_show_y,
          l10n.ms_24month_uses_more_gestures_than_just_waving_and_pointing_like_blowin,
        ]),
        _SectionDef(title: l10n.ms_24month_cognitive_development, items: [
          l10n.ms_24month_holds_something_in_one_hand_while_using_the_other_hand_like_,
          l10n.ms_24month_tries_to_use_switches_knobs_or_buttons_on_a_toy,
          l10n.ms_24month_plays_with_more_than_one_toy_at_the_same_time_like_putting_t,
        ]),
        _SectionDef(title: l10n.ms_24month_movement_physical_development, items: [
          l10n.ms_24month_kicks_a_ball,
          l10n.ms_24month_runs,
          l10n.ms_24month_walks_not_climbs_up_a_few_stairs_with_or_without_help,
          l10n.ms_24month_eats_with_a_spoon,
        ]),
      ];
    case 30:
      return [
        _SectionDef(title: l10n.ms_30month_social_emotional, items: [
          l10n.ms_30month_plays_next_to_other_children_and_sometimes_plays_with_them,
          l10n.ms_30month_shows_you_what_she_can_do_by_saying_look_at_me,
          l10n.ms_30month_follows_simple_routines_when_told_like_helping_to_pick_up_to,
        ]),
        _SectionDef(title: l10n.ms_30month_language_communication, items: [
          l10n.ms_30month_says_about_50_words,
          l10n.ms_30month_says_two_or_more_words_together_with_one_action_word,
          l10n.ms_30month_names_things_in_a_book_when_you_point_and_ask,
          l10n.ms_30month_says_words_like_i_me_or_we,
        ]),
        _SectionDef(title: l10n.ms_30month_cognitive_development, items: [
          l10n.ms_30month_uses_things_to_pretend_feeding_a_block_to_a_doll,
          l10n.ms_30month_shows_simple_problem_solving_skills,
          l10n.ms_30month_follows_two_step_instructions,
          l10n.ms_30month_knows_at_least_one_color,
        ]),
        _SectionDef(title: l10n.ms_30month_movement_physical_development, items: [
          l10n.ms_30month_uses_hands_to_twist_things,
          l10n.ms_30month_takes_some_clothes_off_by_herself,
          l10n.ms_30month_jumps_off_the_ground_with_both_feet,
          l10n.ms_30month_turns_book_pages_one_at_a_time,
        ]),
      ];
    case 36:
      return [
        _SectionDef(title: l10n.ms_3year_social_emotional, items: [
          l10n.ms_3year_calms_down_within_10_minutes_after_you_leave_her,
          l10n.ms_3year_notices_other_children_and_joins_them_to_play,
        ]),
        _SectionDef(title: l10n.ms_3year_speech_language, items: [
          l10n.ms_3year_talks_with_you_in_at_least_two_back_and_forth_exchanges,
          l10n.ms_3year_asks_who_what_where_or_why_questions,
          l10n.ms_3year_says_what_action_is_happening_in_a_picture_or_book,
          l10n.ms_3year_says_first_name_when_asked,
          l10n.ms_3year_talks_well_enough_for_others_to_understand,
        ]),
        _SectionDef(title: l10n.ms_3year_cognitive_development, items: [
          l10n.ms_3year_draws_a_circle_when_you_show_her_how,
          l10n.ms_3year_avoids_touching_hot_objects,
        ]),
        _SectionDef(title: l10n.ms_3year_movement_physical_development, items: [
          l10n.ms_3year_strings_items_together_like_beads,
          l10n.ms_3year_puts_on_some_clothes_by_herself,
          l10n.ms_3year_uses_a_fork,
        ]),
      ];
    case 48:
      return [
        _SectionDef(title: l10n.ms_4year_social_emotional, items: [
          l10n.ms_4year_pretends_to_be_something_else_during_play_teacher_superhero_,
          l10n.ms_4year_asks_to_go_play_with_children_if_none_are_around,
          l10n.ms_4year_comforts_others_who_are_hurt_or_sad_like_hugging_a_crying_fr,
          l10n.ms_4year_avoids_danger_like_not_jumping_from_tall_heights_at_the_play,
          l10n.ms_4year_likes_to_be_a_helper,
          l10n.ms_4year_changes_behavior_based_on_where_she_is_library_playground_et,
        ]),
        _SectionDef(title: l10n.ms_4year_speech_language, items: [
          l10n.ms_4year_says_sentences_with_four_or_more_words,
          l10n.ms_4year_says_some_words_from_a_song_story_or_nursery_rhyme,
          l10n.ms_4year_talks_about_at_least_one_thing_that_happened_during_her_day,
          l10n.ms_4year_answers_simple_questions_like_what_is_a_coat_for,
        ]),
        _SectionDef(title: l10n.ms_4year_cognitive_development, items: [
          l10n.ms_4year_names_a_few_colors_of_items,
          l10n.ms_4year_tells_what_comes_next_in_a_well_known_story,
          l10n.ms_4year_draws_a_person_with_three_or_more_body_parts,
        ]),
        _SectionDef(title: l10n.ms_4year_movement_physical_development, items: [
          l10n.ms_4year_catches_a_large_ball_most_of_the_time,
          l10n.ms_4year_serves_herself_food_or_pours_water,
          l10n.ms_4year_unbuttons_some_buttons,
          l10n.ms_4year_holds_crayon_or_pencil_between_fingers_and_thumb_not_a_fist,
        ]),
      ];
    case 60:
      return [
        _SectionDef(title: l10n.ms_5year_social_emotional, items: [
          l10n.ms_5year_follows_rules_or_takes_turns_when_playing_games_with_other_c,
          l10n.ms_5year_does_simple_chores_at_home,
          l10n.ms_5year_sings_dances_or_acts_for_you,
        ]),
        _SectionDef(title: l10n.ms_5year_speech_language, items: [
          l10n.ms_5year_tells_a_story_she_heard_or_made_up,
          l10n.ms_5year_answers_simple_questions_about_a_story,
          l10n.ms_5year_keeps_a_conversation_going,
          l10n.ms_5year_recognizes_simple_rhymes,
        ]),
        _SectionDef(title: l10n.ms_5year_cognitive_development, items: [
          l10n.ms_5year_counts_to_10,
          l10n.ms_5year_names_some_numbers_between_1_5,
          l10n.ms_5year_uses_time_words_like_yesterday_morning,
          l10n.ms_5year_pays_attention_for_5_10_minutes,
          l10n.ms_5year_writes_some_letters_in_her_name,
          l10n.ms_5year_names_some_letters,
        ]),
        _SectionDef(title: l10n.ms_5year_movement_physical_development, items: [
          l10n.ms_5year_buttons_some_buttons,
          l10n.ms_5year_hops_on_one_foot,
        ]),
      ];
    default:
      return [];
  }
}
