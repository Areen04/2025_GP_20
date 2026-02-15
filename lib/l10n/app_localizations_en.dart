// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get loginTitle => 'Log In';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Log In';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get loginFailed => 'Log In Failed';

  @override
  String get errorTitle => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get pleaseFillAllFields => 'Please fill in all fields.';

  @override
  String get invalidEmailFormat => 'Invalid email format.';

  @override
  String get noUserFoundWithEmail => 'No user found with this email.';

  @override
  String get incorrectPassword => 'Incorrect password. Please try again.';

  @override
  String get emailOrPasswordIncorrect => 'Email or password is incorrect.';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get userNotFoundCheckEmail =>
      'User not found. Please check your email.';

  @override
  String get doctorNotApprovedMessage =>
      'Your doctor account is not approved yet. Please wait for admin approval.';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get emailSentTitle => 'Email Sent';

  @override
  String resetLinkSentTo(Object email) {
    return 'A reset link has been sent to $email.';
  }

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get cancel => 'Cancel';

  @override
  String get send => 'Send';

  @override
  String get pleaseEnterEmailFirst => 'Please enter your email first.';

  @override
  String get noUserFoundWithThatEmail => 'No user found with that email.';

  @override
  String get somethingWentWrongTryAgain => 'Something went wrong. Try again.';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get parentTab => 'Parent';

  @override
  String get healthcareProviderTab => 'Healthcare Provider';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get enterFullNameHint => 'Enter Full Name';

  @override
  String get emailExampleHint => 'example@gmail.com';

  @override
  String get passwordHint => 'Enter password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get reenterPasswordHint => 'Re-enter password';

  @override
  String get passwordReqAtLeast8 => '• At least 8 characters';

  @override
  String get passwordReqUppercase => '• One uppercase letter';

  @override
  String get passwordReqLowercase => '• One lowercase letter';

  @override
  String get passwordReqNumber => '• One number';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginLink => 'Log In';

  @override
  String get fullNameMin2Error => 'Full name must be at least 2 characters.';

  @override
  String get validEmailError => 'Please enter a valid email address.';

  @override
  String get passwordRequirementsError =>
      'Password must meet all requirements.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get errorOccurred => 'Error occurred.';

  @override
  String get documentTypeLabel => 'Document Type';

  @override
  String get selectDocumentTypeHint => 'Select document type';

  @override
  String get nationalId => 'National ID';

  @override
  String get iqama => 'Iqama';

  @override
  String get passport => 'Passport';

  @override
  String get medicalLicense => 'Medical License';

  @override
  String get documentNumberLabel => 'Document Number';

  @override
  String get enterDocumentNumberHint => 'Enter your document number';

  @override
  String get documentNumberInvalid =>
      'Document number is invalid for selected type.';

  @override
  String get pendingReviewInfo =>
      'Your account status will be \"Pending Review\" upon submission. You will not be able to log in until your credentials have been verified and approved by our administration. This process typically takes 1–2 business days.';

  @override
  String get submitForReview => 'Submit for Review';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get logOut => 'Log Out';

  @override
  String get enterYourFullNameHint => 'Enter your full name';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get accountActions => 'Account Actions';

  @override
  String get changePassword => 'Change Password';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String resetPasswordMessage(Object email) {
    return 'A password reset link will be sent to:\n$email\nPress Send to continue.';
  }

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String errorLoadingProfile(Object error) {
    return 'Error loading profile: $error';
  }

  @override
  String errorUpdatingProfile(Object error) {
    return 'Error updating profile: $error';
  }

  @override
  String errorDeletingAccount(Object error) {
    return 'Error deleting account: $error';
  }

  @override
  String get confirmDeleteTitle => 'Delete Account';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete your account permanently?';

  @override
  String get confirmLogoutTitle => 'Log Out';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to log out?';

  @override
  String get yes => 'Yes';

  @override
  String passwordResetLinkSentTo(Object email) {
    return 'Password reset link sent to $email';
  }

  @override
  String errorPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String helloParent(Object name) {
    return 'Hello, $name';
  }

  @override
  String get parentGreeting => 'Manage your children\'s health journey.';

  @override
  String get noChildrenYet => 'There\'s no children yet.';

  @override
  String get deleteChildTitle => 'Delete Child';

  @override
  String get deleteChildConfirm =>
      'Are you sure you want to delete this child?';

  @override
  String get childDeletedSuccess => 'Child deleted successfully';

  @override
  String errorDeletingChild(Object error) {
    return 'Error deleting child: $error';
  }

  @override
  String get addNewChild => 'Add New Child';

  @override
  String get addChildTitle => 'Add Child';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get takePhoto => 'Take a Photo';

  @override
  String get childFullNameLabel => 'Child\'s Full Name';

  @override
  String get dateOfBirthLabel => 'Date of Birth';

  @override
  String get dayLabel => 'Day';

  @override
  String get monthLabel => 'Month';

  @override
  String get yearLabel => 'Year';

  @override
  String get genderLabel => 'Gender';

  @override
  String get selectGenderHint => 'Select gender';

  @override
  String get maleLabel => 'Male';

  @override
  String get femaleLabel => 'Female';

  @override
  String get addChildButton => 'Add Child';

  @override
  String get fillAllRequiredFields => 'Please fill all required fields.';

  @override
  String get dobFutureError => 'Date of birth cannot be in the future.';

  @override
  String get editChildTitle => 'Edit Child';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get enterChildFullNameHint => 'Enter child\'s full name';

  @override
  String helloDoctor(Object name) {
    return 'Hello, Dr. $name';
  }

  @override
  String get doctorLabel => 'Doctor';

  @override
  String get doctorGreeting =>
      'Review and manage your patients’ health profiles.';

  @override
  String get scanQrTitle => 'Scan Child\'s QR Code';

  @override
  String get scanQrInstruction =>
      'Align the QR code within the frame below\nto begin the identification process.';

  @override
  String get qrInvalid => 'QR code expired or invalid';

  @override
  String get childUpdatedSuccess => 'Child information updated successfully';

  @override
  String get childAddedSuccess => 'Child added successfully';

  @override
  String errorSavingChild(Object error) {
    return 'Error saving child: $error';
  }

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get pendingApprovalTitle => 'Pending Approval';

  @override
  String get pendingApprovalMessage =>
      'Your registration request has been sent to the admin.\nPlease wait until it is reviewed.';

  @override
  String get logout => 'Log Out';

  @override
  String get no => 'No';

  @override
  String get aiSkinTitle => 'AI Skin Analysis';

  @override
  String get aiSkinChooseImageTitle => 'Choose Image';

  @override
  String get aiSkinClickHere => 'Click Here';

  @override
  String get aiSkinSubtitle =>
      'Get an instant AI-powered skin analysis\nFocus the camera on the skin area';

  @override
  String get aiSkinReuploadButton => 'Re-upload';

  @override
  String get aiSkinLatestAnalysis => 'Latest Analysis';

  @override
  String get aiSkinRecommendedTips => 'Recommended care tips:';

  @override
  String get aiSkinHistory => 'Analysis History';

  @override
  String get aiSkinNoHistory => 'No previous analyses yet.';

  @override
  String get aiSkinConfirmImageTitle => 'Confirm Image';

  @override
  String get aiSkinConfirmImageMessage =>
      'Are you sure this image is clear and shows the affected skin area?';

  @override
  String get aiSkinTooDarkTitle => 'Too Dark';

  @override
  String get aiSkinTooDarkMessage =>
      'The image is too dark. Please upload a clearer photo.';

  @override
  String get aiSkinNotDetectedTitle => 'Not Detected';

  @override
  String get aiSkinNotDetectedMessage =>
      'No infected skin area detected. Please re-upload a valid skin photo showing the affected area.';

  @override
  String get aiSkinReuploadTitle => 'Re-upload';

  @override
  String get aiSkinReuploadMessage =>
      'The skin area isn’t clear. Please re-upload the photo and make sure the affected skin is clear.';

  @override
  String aiSkinModelLoadFailed(Object error) {
    return 'Failed to load model: $error';
  }

  @override
  String get ms_18month_developmental_milestones => 'Developmental Milestones';

  @override
  String get ms_18month_social_emotional => 'Social & Emotional';

  @override
  String get ms_18month_points_to_show_you_something_interesting =>
      'Points to show you something interesting';

  @override
  String get ms_18month_puts_hands_out_for_you_to_wash_them =>
      'Puts hands out for you to wash them';

  @override
  String get ms_18month_looks_at_a_few_pages_in_a_book_with_you =>
      'Looks at a few pages in a book with you';

  @override
  String get ms_18month_speech_language => 'Speech & Language';

  @override
  String get ms_18month_cognitive_development => 'Cognitive Development';

  @override
  String get ms_18month_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_18month_scribbles => 'Scribbles';

  @override
  String get ms_18month_feeds_herself_with_her_fingers =>
      'Feeds herself with her fingers';

  @override
  String get ms_18month_tries_to_use_a_spoon => 'Tries to use a spoon';

  @override
  String get ms_18month_overall_progress => 'Overall Progress';

  @override
  String get ms_24month_developmental_milestones => 'Developmental Milestones';

  @override
  String get ms_24month_social_emotional => 'Social & Emotional';

  @override
  String get ms_24month_speech_language => 'Speech & Language';

  @override
  String get ms_24month_cognitive_development => 'Cognitive Development';

  @override
  String get ms_24month_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_24month_kicks_a_ball => 'Kicks a ball';

  @override
  String get ms_24month_runs => 'Runs';

  @override
  String get ms_24month_eats_with_a_spoon => 'Eats with a spoon';

  @override
  String get ms_24month_overall_progress => 'Overall Progress';

  @override
  String get ms_30month_developmental_milestones => 'Developmental Milestones';

  @override
  String get ms_30month_social_emotional => 'Social & Emotional';

  @override
  String get ms_30month_language_communication => 'Language & Communication';

  @override
  String get ms_30month_says_about_50_words => 'Says about 50 words';

  @override
  String get ms_30month_cognitive_development => 'Cognitive Development';

  @override
  String get ms_30month_shows_simple_problem_solving_skills =>
      'Shows simple problem-solving skills';

  @override
  String get ms_30month_follows_two_step_instructions =>
      'Follows two-step instructions';

  @override
  String get ms_30month_knows_at_least_one_color => 'Knows at least one color';

  @override
  String get ms_30month_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_30month_uses_hands_to_twist_things =>
      'Uses hands to twist things';

  @override
  String get ms_30month_takes_some_clothes_off_by_herself =>
      'Takes some clothes off by herself';

  @override
  String get ms_30month_jumps_off_the_ground_with_both_feet =>
      'Jumps off the ground with both feet';

  @override
  String get ms_30month_turns_book_pages_one_at_a_time =>
      'Turns book pages one at a time';

  @override
  String get ms_30month_overall_progress => 'Overall Progress';

  @override
  String get ms_3year_developmental_milestones => 'Developmental Milestones';

  @override
  String get ms_3year_social_emotional => 'Social & Emotional';

  @override
  String get ms_3year_speech_language => 'Speech & Language';

  @override
  String get ms_3year_says_first_name_when_asked =>
      'Says first name when asked';

  @override
  String get ms_3year_talks_well_enough_for_others_to_understand =>
      'Talks well enough for others to understand';

  @override
  String get ms_3year_cognitive_development => 'Cognitive Development';

  @override
  String get ms_3year_draws_a_circle_when_you_show_her_how =>
      'Draws a circle when you show her how';

  @override
  String get ms_3year_avoids_touching_hot_objects =>
      'Avoids touching hot objects';

  @override
  String get ms_3year_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_3year_strings_items_together_like_beads =>
      'Strings items together like beads';

  @override
  String get ms_3year_puts_on_some_clothes_by_herself =>
      'Puts on some clothes by herself';

  @override
  String get ms_3year_uses_a_fork => 'Uses a fork';

  @override
  String get ms_3year_overall_progress => 'Overall Progress';

  @override
  String get ms_4year_developmental_milestones => 'Developmental Milestones';

  @override
  String get ms_4year_social_emotional => 'Social & Emotional';

  @override
  String get ms_4year_likes_to_be_a_helper => 'Likes to be a helper';

  @override
  String get ms_4year_speech_language => 'Speech & Language';

  @override
  String get ms_4year_says_sentences_with_four_or_more_words =>
      'Says sentences with four or more words';

  @override
  String get ms_4year_cognitive_development => 'Cognitive Development';

  @override
  String get ms_4year_names_a_few_colors_of_items =>
      'Names a few colors of items';

  @override
  String get ms_4year_draws_a_person_with_three_or_more_body_parts =>
      'Draws a person with three or more body parts';

  @override
  String get ms_4year_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_4year_catches_a_large_ball_most_of_the_time =>
      'Catches a large ball most of the time';

  @override
  String get ms_4year_serves_herself_food_or_pours_water =>
      'Serves herself food or pours water';

  @override
  String get ms_4year_unbuttons_some_buttons => 'Unbuttons some buttons';

  @override
  String get ms_4year_overall_progress => 'Overall Progress';

  @override
  String get ms_5year_developmental_milestones => 'Developmental Milestones';

  @override
  String get ms_5year_social_emotional => 'Social & Emotional';

  @override
  String get ms_5year_does_simple_chores_at_home =>
      'Does simple chores at home';

  @override
  String get ms_5year_sings_dances_or_acts_for_you =>
      'Sings, dances, or acts for you';

  @override
  String get ms_5year_speech_language => 'Speech & Language';

  @override
  String get ms_5year_tells_a_story_she_heard_or_made_up =>
      'Tells a story she heard or made up';

  @override
  String get ms_5year_answers_simple_questions_about_a_story =>
      'Answers simple questions about a story';

  @override
  String get ms_5year_keeps_a_conversation_going =>
      'Keeps a conversation going';

  @override
  String get ms_5year_recognizes_simple_rhymes => 'Recognizes simple rhymes';

  @override
  String get ms_5year_cognitive_development => 'Cognitive Development';

  @override
  String get ms_5year_counts_to_10 => 'Counts to 10';

  @override
  String get ms_5year_names_some_numbers_between_1_5 =>
      'Names some numbers between 1–5';

  @override
  String get ms_5year_uses_time_words_like_yesterday_morning =>
      'Uses time words like yesterday / morning';

  @override
  String get ms_5year_pays_attention_for_5_10_minutes =>
      'Pays attention for 5–10 minutes';

  @override
  String get ms_5year_writes_some_letters_in_her_name =>
      'Writes some letters in her name';

  @override
  String get ms_5year_names_some_letters => 'Names some letters';

  @override
  String get ms_5year_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_5year_buttons_some_buttons => 'Buttons some buttons';

  @override
  String get ms_5year_hops_on_one_foot => 'Hops on one foot';

  @override
  String get ms_5year_overall_progress => 'Overall Progress';

  @override
  String get ms_fifteen_month_developmental_milestones =>
      'Developmental Milestones';

  @override
  String get ms_fifteen_month_social_emotional => 'Social & Emotional';

  @override
  String get ms_fifteen_month_shows_you_an_object_she_likes =>
      'Shows you an object she likes';

  @override
  String get ms_fifteen_month_claps_when_excited => 'Claps when excited';

  @override
  String get ms_fifteen_month_hugs_stuffed_doll_or_other_toy =>
      'Hugs stuffed doll or other toy';

  @override
  String get ms_fifteen_month_shows_affection => 'Shows affection';

  @override
  String get ms_fifteen_month_language_communication =>
      'Language & Communication';

  @override
  String get ms_fifteen_month_looks_at_familiar_objects_when_named =>
      'Looks at familiar objects when named';

  @override
  String get ms_fifteen_month_points_to_ask_for_something =>
      'Points to ask for something';

  @override
  String get ms_fifteen_month_cognitive_development => 'Cognitive Development';

  @override
  String get ms_fifteen_month_uses_things_the_right_way_phone_cup =>
      'Uses things the right way (phone, cup...)';

  @override
  String get ms_fifteen_month_stacks_two_objects => 'Stacks two objects';

  @override
  String get ms_fifteen_month_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_fifteen_month_takes_a_few_steps_on_her_own =>
      'Takes a few steps on her own';

  @override
  String get ms_fifteen_month_feeds_herself_using_fingers =>
      'Feeds herself using fingers';

  @override
  String get ms_fifteen_month_overall_progress => 'Overall Progress';

  @override
  String get ms_four_month_developmental_milestones =>
      'Developmental Milestones';

  @override
  String get ms_four_month_social_emotional => 'Social & Emotional';

  @override
  String get ms_four_month_speech_language => 'Speech & Language';

  @override
  String get ms_four_month_cognitive_development => 'Cognitive Development';

  @override
  String get ms_four_month_overall_progress => 'Overall Progress';

  @override
  String get ms_nine_month_developmental_milestones =>
      'Developmental Milestones';

  @override
  String get ms_nine_month_social_emotional => 'Social & Emotional';

  @override
  String get ms_nine_month_language_communication => 'Language & Communication';

  @override
  String get ms_nine_month_cognitive_development => 'Cognitive Development';

  @override
  String get ms_nine_month_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_nine_month_overall_progress => 'Overall Progress';

  @override
  String get ms_one_year_developmental_milestones => 'Developmental Milestones';

  @override
  String get ms_one_year_social_emotional => 'Social & Emotional';

  @override
  String get ms_one_year_waves_bye_bye => 'Waves bye-bye';

  @override
  String get ms_one_year_plays_pat_a_cake_with_you =>
      'Plays pat-a-cake with you';

  @override
  String get ms_one_year_language_communication => 'Language & Communication';

  @override
  String get ms_one_year_says_mama_or_dada => 'Says mama or dada';

  @override
  String get ms_one_year_understands_no => 'Understands “no”';

  @override
  String get ms_one_year_cognitive_development => 'Cognitive Development';

  @override
  String get ms_one_year_puts_things_in_a_container =>
      'Puts things in a container';

  @override
  String get ms_one_year_looks_for_hidden_toys => 'Looks for hidden toys';

  @override
  String get ms_one_year_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_one_year_pulls_up_to_stand => 'Pulls up to stand';

  @override
  String get ms_one_year_walks_holding_furniture => 'Walks holding furniture';

  @override
  String get ms_one_year_drinks_from_a_cup => 'Drinks from a cup';

  @override
  String get ms_one_year_uses_thumb_finger_to_pick_things =>
      'Uses thumb + finger to pick things';

  @override
  String get ms_one_year_overall_progress => 'Overall Progress';

  @override
  String get ms_six_month_developmental_milestones =>
      'Developmental Milestones';

  @override
  String get ms_six_month_social_emotional => 'Social & Emotional';

  @override
  String get ms_six_month_knows_familiar_people => 'Knows familiar people';

  @override
  String get ms_six_month_likes_to_look_at_herself_in_a_mirror =>
      'Likes to look at herself in a mirror';

  @override
  String get ms_six_month_laughs => 'Laughs';

  @override
  String get ms_six_month_speech_language => 'Speech & Language';

  @override
  String get ms_six_month_takes_turns_making_sounds_with_you =>
      'Takes turns making sounds with you';

  @override
  String get ms_six_month_blows_raspberries => 'Blows “raspberries”';

  @override
  String get ms_six_month_makes_squealing_noises => 'Makes squealing noises';

  @override
  String get ms_six_month_cognitive_development => 'Cognitive Development';

  @override
  String get ms_six_month_puts_things_in_her_mouth_to_explore_them =>
      'Puts things in her mouth to explore them';

  @override
  String get ms_six_month_reaches_to_grab_a_toy_she_wants =>
      'Reaches to grab a toy she wants';

  @override
  String get ms_six_month_closes_lips_to_show_she_doesn_t_want_more_food =>
      'Closes lips to show she doesn’t want more food';

  @override
  String get ms_six_month_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_six_month_rolls_from_tummy_to_back =>
      'Rolls from tummy to back';

  @override
  String get ms_six_month_pushes_up_with_straight_arms_when_on_tummy =>
      'Pushes up with straight arms when on tummy';

  @override
  String get ms_six_month_leans_on_hands_to_support_herself_when_sitting =>
      'Leans on hands to support herself when sitting';

  @override
  String get ms_six_month_overall_progress => 'Overall Progress';

  @override
  String get ms_two_month_developmental_milestones =>
      'Developmental Milestones';

  @override
  String get ms_two_month_speech_language => 'Speech & Language';

  @override
  String get ms_two_month_cognitive_development => 'Cognitive Development';

  @override
  String get ms_two_month_overall_progress => 'Overall Progress';

  @override
  String
      get ms_18month_moves_away_from_you_but_looks_to_make_sure_you_are_close_by =>
          'Moves away from you, but looks to make sure you are close by';

  @override
  String
      get ms_18month_helps_you_dress_by_pushing_arm_through_sleeve_or_lifting_up_ =>
          'Helps you dress by pushing arm through sleeve or lifting up foot';

  @override
  String get ms_18month_tries_to_say_three_or_more_words_besides_mama_or_dada =>
      'Tries to say three or more words besides \'mama\' or \'dada\'';

  @override
  String
      get ms_18month_follows_one_step_directions_without_gestures_like_give_it_to =>
          'Follows one-step directions without gestures, like \'Give it to me\'';

  @override
  String get ms_18month_copies_you_doing_chores_like_sweeping_with_a_broom =>
      'Copies you doing chores, like sweeping with a broom';

  @override
  String
      get ms_18month_plays_with_toys_in_a_simple_way_like_pushing_a_toy_car =>
          'Plays with toys in a simple way, like pushing a toy car';

  @override
  String get ms_18month_walks_without_holding_on_to_anyone_or_anything =>
      'Walks without holding on to anyone or anything';

  @override
  String
      get ms_18month_drinks_from_a_cup_without_a_lid_and_may_spill_sometimes =>
          'Drinks from a cup without a lid and may spill sometimes';

  @override
  String get ms_18month_climbs_on_and_off_a_couch_or_chair_without_help =>
      'Climbs on and off a couch or chair without help';

  @override
  String
      get ms_18month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_18month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String get ms_24month_notices_when_others_are_hurt_or_upset_like_pausing_or_lookin =>
      'Notices when others are hurt or upset, like pausing or looking sad when someone is crying';

  @override
  String
      get ms_24month_looks_at_your_face_to_see_how_to_react_in_a_new_situation =>
          'Looks at your face to see how to react in a new situation';

  @override
  String
      get ms_24month_points_to_things_in_a_book_when_you_ask_like_where_is_the_be =>
          'Points to things in a book when you ask, like \'Where is the bear?\'';

  @override
  String get ms_24month_says_at_least_two_words_together_like_more_milk =>
      'Says at least two words together, like \'More milk.\'';

  @override
  String
      get ms_24month_points_to_at_least_two_body_parts_when_you_ask_him_to_show_y =>
          'Points to at least two body parts when you ask him to show you';

  @override
  String get ms_24month_uses_more_gestures_than_just_waving_and_pointing_like_blowin =>
      'Uses more gestures than just waving and pointing, like blowing a kiss or nodding yes';

  @override
  String get ms_24month_holds_something_in_one_hand_while_using_the_other_hand_like_ =>
      'Holds something in one hand while using the other hand, like holding a container and taking the lid off';

  @override
  String get ms_24month_tries_to_use_switches_knobs_or_buttons_on_a_toy =>
      'Tries to use switches, knobs, or buttons on a toy';

  @override
  String get ms_24month_plays_with_more_than_one_toy_at_the_same_time_like_putting_t =>
      'Plays with more than one toy at the same time, like putting toy food on a toy plate';

  @override
  String get ms_24month_walks_not_climbs_up_a_few_stairs_with_or_without_help =>
      'Walks (not climbs) up a few stairs with or without help';

  @override
  String
      get ms_24month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_24month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String
      get ms_30month_plays_next_to_other_children_and_sometimes_plays_with_them =>
          'Plays next to other children and sometimes plays with them';

  @override
  String get ms_30month_shows_you_what_she_can_do_by_saying_look_at_me =>
      'Shows you what she can do by saying \'Look at me!\'';

  @override
  String get ms_30month_follows_simple_routines_when_told_like_helping_to_pick_up_to =>
      'Follows simple routines when told, like helping to pick up toys when you say \'It’s clean-up time.\'';

  @override
  String get ms_30month_says_two_or_more_words_together_with_one_action_word =>
      'Says two or more words together, with one action word';

  @override
  String get ms_30month_names_things_in_a_book_when_you_point_and_ask =>
      'Names things in a book when you point and ask';

  @override
  String get ms_30month_says_words_like_i_me_or_we =>
      'Says words like \'I,\' \'me,\' or \'we\'';

  @override
  String get ms_30month_uses_things_to_pretend_feeding_a_block_to_a_doll =>
      'Uses things to pretend (feeding a block to a doll)';

  @override
  String
      get ms_30month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_30month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String get ms_3year_calms_down_within_10_minutes_after_you_leave_her =>
      'Calms down within 10 minutes after you leave her';

  @override
  String get ms_3year_notices_other_children_and_joins_them_to_play =>
      'Notices other children and joins them to play';

  @override
  String get ms_3year_talks_with_you_in_at_least_two_back_and_forth_exchanges =>
      'Talks with you in at least two back-and-forth exchanges';

  @override
  String get ms_3year_asks_who_what_where_or_why_questions =>
      'Asks “who”, “what”, “where”, or “why” questions';

  @override
  String get ms_3year_says_what_action_is_happening_in_a_picture_or_book =>
      'Says what action is happening in a picture or book';

  @override
  String
      get ms_3year_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_3year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String
      get ms_4year_pretends_to_be_something_else_during_play_teacher_superhero_ =>
          'Pretends to be something else during play (teacher, superhero, dog)';

  @override
  String get ms_4year_asks_to_go_play_with_children_if_none_are_around =>
      'Asks to go play with children if none are around';

  @override
  String
      get ms_4year_comforts_others_who_are_hurt_or_sad_like_hugging_a_crying_fr =>
          'Comforts others who are hurt or sad, like hugging a crying friend';

  @override
  String
      get ms_4year_avoids_danger_like_not_jumping_from_tall_heights_at_the_play =>
          'Avoids danger, like not jumping from tall heights at the playground';

  @override
  String
      get ms_4year_changes_behavior_based_on_where_she_is_library_playground_et =>
          'Changes behavior based on where she is (library, playground, etc.)';

  @override
  String get ms_4year_says_some_words_from_a_song_story_or_nursery_rhyme =>
      'Says some words from a song, story, or nursery rhyme';

  @override
  String
      get ms_4year_talks_about_at_least_one_thing_that_happened_during_her_day =>
          'Talks about at least one thing that happened during her day';

  @override
  String get ms_4year_answers_simple_questions_like_what_is_a_coat_for =>
      'Answers simple questions like \'What is a coat for?\'';

  @override
  String get ms_4year_tells_what_comes_next_in_a_well_known_story =>
      'Tells what comes next in a well-known story';

  @override
  String
      get ms_4year_holds_crayon_or_pencil_between_fingers_and_thumb_not_a_fist =>
          'Holds crayon or pencil between fingers and thumb (not a fist)';

  @override
  String
      get ms_4year_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_4year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String
      get ms_5year_follows_rules_or_takes_turns_when_playing_games_with_other_c =>
          'Follows rules or takes turns when playing games with other children';

  @override
  String
      get ms_5year_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_5year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String get ms_fifteen_month_copies_other_children_while_playing_like_taking_toys_out_of_ =>
      'Copies other children while playing, like taking toys out of a container when another child does';

  @override
  String
      get ms_fifteen_month_tries_to_say_one_or_two_words_besides_mama_or_dada =>
          'Tries to say one or two words besides “mama” or “dada”';

  @override
  String
      get ms_fifteen_month_follows_directions_with_both_a_gesture_and_words =>
          'Follows directions with both a gesture and words';

  @override
  String
      get ms_fifteen_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved ';

  @override
  String ms_fifteen_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String get ms_four_month_smiles_on_his_own_to_get_your_attention =>
      'Smiles on his own to get your attention';

  @override
  String
      get ms_four_month_chuckles_not_a_full_laugh_when_you_try_to_make_her_laugh =>
          'Chuckles (not a full laugh) when you try to make her laugh';

  @override
  String
      get ms_four_month_looks_at_you_moves_or_makes_sounds_to_get_your_attention =>
          'Looks at you, moves, or makes sounds to get your attention';

  @override
  String get ms_four_month_makes_sounds_like_ooo_aahh_cooing =>
      'Makes sounds like \'ooo\', \'aahh\' (cooing)';

  @override
  String get ms_four_month_makes_sounds_back_when_you_talk_to_her =>
      'Makes sounds back when you talk to her';

  @override
  String get ms_four_month_turns_head_towards_sound_of_your_voice =>
      'Turns head towards sound of your voice';

  @override
  String
      get ms_four_month_if_hungry_opens_mouth_when_she_sees_breast_or_bottle =>
          'If hungry, opens mouth when she sees breast or bottle';

  @override
  String get ms_four_month_looks_at_hands_with_interest =>
      'Looks at hands with interest';

  @override
  String get ms_four_month_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_four_month_holds_head_steady_without_support =>
      'Holds head steady without support';

  @override
  String get ms_four_month_holds_a_toy_when_you_put_it_in_her_hand =>
      'Holds a toy when you put it in her hand';

  @override
  String get ms_four_month_uses_arm_to_swing_at_toys =>
      'Uses arm to swing at toys';

  @override
  String get ms_four_month_brings_hands_to_mouth => 'Brings hands to mouth';

  @override
  String get ms_four_month_pushes_up_onto_elbows_forearms_when_on_tummy =>
      'Pushes up onto elbows/forearms when on tummy';

  @override
  String
      get ms_four_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_four_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String get ms_nine_month_is_shy_clingy_or_fearful_around_strangers =>
      'Is shy, clingy, or fearful around strangers';

  @override
  String
      get ms_nine_month_shows_facial_expressions_like_happy_sad_angry_and_surprised =>
          'Shows facial expressions like happy, sad, angry, and surprised';

  @override
  String get ms_nine_month_looks_when_you_call_her_name =>
      'Looks when you call her name';

  @override
  String get ms_nine_month_makes_sounds_like_mamama_or_babababa =>
      'Makes sounds like \'mamama\' or \'babababa\'';

  @override
  String get ms_nine_month_looks_for_objects_when_dropped_out_of_sight =>
      'Looks for objects when dropped out of sight';

  @override
  String get ms_nine_month_gets_to_a_sitting_position_by_herself =>
      'Gets to a sitting position by herself';

  @override
  String get ms_nine_month_sits_without_support => 'Sits without support';

  @override
  String
      get ms_nine_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_nine_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String
      get ms_one_year_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_one_year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String
      get ms_six_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_six_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String get ms_two_month_social_emotional => 'Social & Emotional';

  @override
  String get ms_two_month_calms_down_when_spoken_to_or_picked_up =>
      'Calms down when spoken to or picked up';

  @override
  String get ms_two_month_looks_at_your_face => 'Looks at your face';

  @override
  String get ms_two_month_seems_happy_to_see_you_when_you_walk_up_to_her =>
      'Seems happy to see you when you walk up to her';

  @override
  String get ms_two_month_smiles_when_you_talk_to_or_smile_at_her =>
      'Smiles when you talk to or smile at her';

  @override
  String get ms_two_month_makes_cooing_sounds => 'Makes cooing sounds';

  @override
  String get ms_two_month_reacts_to_loud_sounds => 'Reacts to loud sounds';

  @override
  String get ms_two_month_watches_you_as_you_move => 'Watches you as you move';

  @override
  String get ms_two_month_looks_at_a_toy_for_several_seconds =>
      'Looks at a toy for several seconds';

  @override
  String get ms_two_month_movement_physical_development =>
      'Movement & Physical Development';

  @override
  String get ms_two_month_holds_head_up_when_on_tummy =>
      'Holds head up when on tummy';

  @override
  String get ms_two_month_moves_both_arms_and_both_legs =>
      'Moves both arms and both legs';

  @override
  String get ms_two_month_opens_hands_briefly => 'Opens hands briefly';

  @override
  String
      get ms_two_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'Only check milestones you\'re confident your child has achieved';

  @override
  String ms_two_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount of $totalMilestones milestones complete';
  }

  @override
  String get activityLibraryTitle => 'Activity Library';

  @override
  String get act_2m_1 => 'Make eye contact and smile at your baby';

  @override
  String get act_2m_2 => 'Talk to your baby during feeding and diaper changes';

  @override
  String get act_2m_3 => 'Copy your baby’s sounds and wait for a response';

  @override
  String get act_2m_4 => 'Place a baby-safe mirror for face exploration';

  @override
  String get act_2m_5 => 'Give short supervised tummy time';

  @override
  String get act_2m_6 => 'Show high-contrast images or faces';

  @override
  String get act_4m_1 =>
      'Move a toy slowly for your baby to follow with their eyes';

  @override
  String get act_4m_2 => 'Let your baby reach for nearby toys';

  @override
  String get act_4m_3 => 'Shake a rattle and let your baby track the sound';

  @override
  String get act_4m_4 => 'Sing songs while gently moving arms and legs';

  @override
  String get act_4m_5 => 'Play on a floor mat with toys around the baby';

  @override
  String get act_4m_6 => 'Encourage kicking by placing toys near the feet';

  @override
  String get act_6m_1 => 'Support your baby in sitting while playing with toys';

  @override
  String get act_6m_2 => 'Place toys just out of reach to encourage rolling';

  @override
  String get act_6m_3 => 'Name objects your baby looks at';

  @override
  String get act_6m_4 => 'Let your baby drop objects and watch them fall';

  @override
  String get act_6m_5 => 'Explore textures with safe household items';

  @override
  String get act_6m_6 => 'Play music and let your baby listen and react';

  @override
  String get act_9m_1 => 'Hide a toy under a cloth and let your baby find it';

  @override
  String get act_9m_2 => 'Encourage crawling by placing toys farther away';

  @override
  String get act_9m_3 => 'Practice simple gestures like waving';

  @override
  String get act_9m_4 => 'Pass toys back and forth in turn-taking play';

  @override
  String get act_9m_5 => 'Let your baby pull to stand using safe furniture';

  @override
  String get act_9m_6 => 'Dump toys from a container and refill it together';

  @override
  String get act_1y_1 => 'Read picture books and name familiar objects';

  @override
  String get act_1y_2 => 'Encourage walking using push toys';

  @override
  String get act_1y_3 => 'Let your child bang pots or simple instruments';

  @override
  String get act_1y_4 => 'Respond with words when your child points';

  @override
  String get act_1y_5 => 'Play imitation games (clapping, waving)';

  @override
  String get act_1y_6 => 'Expand on your child’s single words';

  @override
  String get act_15m_1 => 'Stack blocks and knock them down together';

  @override
  String get act_15m_2 => 'Play simple pretend with stuffed animals';

  @override
  String get act_15m_3 => 'Sing songs with actions (hands, feet, head)';

  @override
  String get act_15m_4 => 'Let your child help put toys away';

  @override
  String get act_15m_5 => 'Offer crayons for scribbling';

  @override
  String get act_15m_6 => 'Practice drinking from a cup and using a spoon';

  @override
  String get act_18m_1 => 'Name body parts during play';

  @override
  String get act_18m_2 => 'Roll a ball back and forth';

  @override
  String get act_18m_3 => 'Offer two choices and let your child decide';

  @override
  String get act_18m_4 => 'Encourage pretend play with dolls or toy food';

  @override
  String get act_18m_5 => 'Blow bubbles and let your child pop them';

  @override
  String get act_18m_6 => 'Talk about simple emotions using words';

  @override
  String get act_2y_1 => 'Do simple puzzles together';

  @override
  String get act_2y_2 => 'Let your child help with easy chores';

  @override
  String get act_2y_3 => 'Play with sand or water using cups';

  @override
  String get act_2y_4 => 'Kick and throw balls outdoors';

  @override
  String get act_2y_5 => 'Draw with crayons or finger paint';

  @override
  String get act_2y_6 => 'Build towers with blocks';

  @override
  String get act_30m_1 => 'Encourage play with other children';

  @override
  String get act_30m_2 => 'Ask simple questions about pictures or stories';

  @override
  String get act_30m_3 => 'Sort objects by size or color';

  @override
  String get act_30m_4 => 'Use chalk or washable paint for drawing';

  @override
  String get act_30m_5 => 'Pretend play using boxes or household items';

  @override
  String get act_30m_6 => 'Practice sharing during play';

  @override
  String get act_3y_1 => 'Play counting games using everyday objects';

  @override
  String get act_3y_2 => 'Match shapes or pictures';

  @override
  String get act_3y_3 => 'Play with playdough';

  @override
  String get act_3y_4 => 'Act out short stories together';

  @override
  String get act_3y_5 => 'Talk about feelings and calming down';

  @override
  String get act_3y_6 => 'Help your child say their name and age';

  @override
  String get act_4y_1 => 'Play board or matching games with simple rules';

  @override
  String get act_4y_2 => 'Count objects during daily activities';

  @override
  String get act_4y_3 => 'Role-play new situations (doctor, school)';

  @override
  String get act_4y_4 => 'Play outdoor group games';

  @override
  String get act_4y_5 => 'Help with simple chores';

  @override
  String get act_4y_6 => 'Practice turn-taking during play';

  @override
  String get act_5y_1 => 'Play memory or attention games';

  @override
  String get act_5y_2 => 'Do rhyming word games';

  @override
  String get act_5y_3 => 'Build with complex blocks or construction toys';

  @override
  String get act_5y_4 => 'Solve simple problems during play';

  @override
  String get act_5y_5 => 'Encourage independent daily tasks';

  @override
  String get act_5y_6 => 'Prepare for school routines through play';

  @override
  String get childQrPopupInstruction =>
      'Show this QR code to your healthcare provider';

  @override
  String get close => 'Close';
}
