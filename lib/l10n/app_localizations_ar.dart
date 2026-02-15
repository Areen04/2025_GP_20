// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get languageLabel => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get createNewAccount => 'أنشئ حسابًا جديدًا';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get errorTitle => 'خطأ';

  @override
  String get ok => 'موافق';

  @override
  String get pleaseFillAllFields => 'يرجى تعبئة جميع الحقول.';

  @override
  String get invalidEmailFormat => 'صيغة البريد الإلكتروني غير صحيحة.';

  @override
  String get noUserFoundWithEmail => 'لا يوجد مستخدم بهذا البريد الإلكتروني.';

  @override
  String get incorrectPassword => 'كلمة المرور غير صحيحة. حاول مرة أخرى.';

  @override
  String get emailOrPasswordIncorrect =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع.';

  @override
  String get userNotFoundCheckEmail =>
      'لم يتم العثور على المستخدم. يرجى التحقق من بريدك الإلكتروني.';

  @override
  String get doctorNotApprovedMessage =>
      'حساب مقدم الرعاية الصحية غير مُعتمد بعد. يرجى انتظار موافقة الإدارة.';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get emailSentTitle => 'تم إرسال البريد';

  @override
  String resetLinkSentTo(Object email) {
    return 'تم إرسال رابط إعادة التعيين إلى $email.';
  }

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get cancel => 'إلغاء';

  @override
  String get send => 'إرسال';

  @override
  String get pleaseEnterEmailFirst => 'يرجى إدخال بريدك الإلكتروني أولاً.';

  @override
  String get noUserFoundWithThatEmail =>
      'لا يوجد مستخدم بهذا البريد الإلكتروني.';

  @override
  String get somethingWentWrongTryAgain => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get createAccountTitle => 'إنشاء حساب';

  @override
  String get parentTab => 'ولي أمر';

  @override
  String get healthcareProviderTab => 'مقدم رعاية صحية';

  @override
  String get fullNameLabel => 'الاسم الكامل (بالإنجليزية)';

  @override
  String get enterFullNameHint => 'أدخل الاسم الكامل (بالإنجليزية)';

  @override
  String get emailExampleHint => 'example@gmail.com';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get reenterPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get passwordReqAtLeast8 => '• على الأقل 8 أحرف';

  @override
  String get passwordReqUppercase => '• حرف كبير واحد';

  @override
  String get passwordReqLowercase => '• حرف صغير واحد';

  @override
  String get passwordReqNumber => '• رقم واحد';

  @override
  String get createAccountButton => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get loginLink => 'تسجيل الدخول';

  @override
  String get fullNameMin2Error => 'يجب أن يكون الاسم الكامل حرفين على الأقل.';

  @override
  String get validEmailError => 'يرجى إدخال بريد إلكتروني صحيح.';

  @override
  String get passwordRequirementsError =>
      'يجب أن تحقق كلمة المرور جميع المتطلبات.';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get errorOccurred => 'حدث خطأ.';

  @override
  String get documentTypeLabel => 'نوع الوثيقة';

  @override
  String get selectDocumentTypeHint => 'اختر نوع الوثيقة';

  @override
  String get nationalId => 'الهوية الوطنية';

  @override
  String get iqama => 'الإقامة';

  @override
  String get passport => 'جواز السفر';

  @override
  String get medicalLicense => 'ترخيص طبي';

  @override
  String get documentNumberLabel => 'رقم الوثيقة';

  @override
  String get enterDocumentNumberHint => 'أدخل رقم الوثيقة';

  @override
  String get documentNumberInvalid => 'رقم الوثيقة غير صالح للنوع المحدد.';

  @override
  String get pendingReviewInfo =>
      'ستكون حالة حسابك \"قيد المراجعة\" بعد الإرسال. لن تتمكن من تسجيل الدخول حتى يتم التحقق من بياناتك والموافقة عليها من الإدارة. تستغرق هذه العملية عادةً من 1 إلى 2 يوم عمل.';

  @override
  String get submitForReview => 'إرسال للمراجعة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get enterYourFullNameHint => 'أدخل اسمك الكامل (بالإنجليزية)';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get accountActions => 'إجراءات الحساب';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String resetPasswordMessage(Object email) {
    return 'سيتم إرسال رابط إعادة التعيين إلى:\n$email\nاضغط إرسال للمتابعة.';
  }

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get nameCannotBeEmpty => 'لا يمكن أن يكون الاسم فارغًا';

  @override
  String errorLoadingProfile(Object error) {
    return 'خطأ في تحميل الملف الشخصي: $error';
  }

  @override
  String errorUpdatingProfile(Object error) {
    return 'خطأ في تحديث الملف الشخصي: $error';
  }

  @override
  String errorDeletingAccount(Object error) {
    return 'خطأ في حذف الحساب: $error';
  }

  @override
  String get confirmDeleteTitle => 'حذف الحساب';

  @override
  String get confirmDeleteMessage => 'هل أنت متأكد أنك تريد حذف حسابك نهائيًا؟';

  @override
  String get confirmLogoutTitle => 'تسجيل الخروج';

  @override
  String get confirmLogoutMessage => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get yes => 'نعم';

  @override
  String passwordResetLinkSentTo(Object email) {
    return 'تم إرسال رابط إعادة التعيين إلى $email';
  }

  @override
  String errorPrefix(Object error) {
    return 'خطأ: $error';
  }

  @override
  String helloParent(Object name) {
    return 'مرحبًا، $name';
  }

  @override
  String get parentGreeting => 'تابع رحلة صحة أطفالك.';

  @override
  String get noChildrenYet => 'لا يوجد أطفال بعد.';

  @override
  String get deleteChildTitle => 'حذف الطفل';

  @override
  String get deleteChildConfirm => 'هل أنت متأكد أنك تريد حذف هذا الطفل؟';

  @override
  String get childDeletedSuccess => 'تم حذف الطفل بنجاح';

  @override
  String errorDeletingChild(Object error) {
    return 'خطأ في حذف الطفل: $error';
  }

  @override
  String get addNewChild => 'إضافة طفل جديد';

  @override
  String get addChildTitle => 'إضافة طفل';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get childFullNameLabel => 'اسم الطفل الكامل (بالإنجليزية)';

  @override
  String get dateOfBirthLabel => 'تاريخ الميلاد';

  @override
  String get dayLabel => 'اليوم';

  @override
  String get monthLabel => 'الشهر';

  @override
  String get yearLabel => 'السنة';

  @override
  String get genderLabel => 'الجنس';

  @override
  String get selectGenderHint => 'اختر الجنس';

  @override
  String get maleLabel => 'ذكر';

  @override
  String get femaleLabel => 'أنثى';

  @override
  String get addChildButton => 'إضافة طفل';

  @override
  String get fillAllRequiredFields => 'يرجى تعبئة جميع الحقول المطلوبة.';

  @override
  String get dobFutureError => 'لا يمكن أن يكون تاريخ الميلاد في المستقبل.';

  @override
  String get editChildTitle => 'تعديل بيانات الطفل';

  @override
  String get uploadPhoto => 'رفع صورة';

  @override
  String get enterChildFullNameHint => 'أدخل اسم الطفل الكامل (بالإنجليزية)';

  @override
  String helloDoctor(Object name) {
    return 'مرحبًا، د. $name';
  }

  @override
  String get doctorLabel => 'طبيب';

  @override
  String get doctorGreeting => 'راجع وأدر ملفات صحة مرضاك.';

  @override
  String get scanQrTitle => 'مسح رمز الاستجابة للطفل';

  @override
  String get scanQrInstruction =>
      'وجّه الكاميرا نحو الرمز داخل الإطار أدناه\nلبدء عملية التعريف.';

  @override
  String get qrInvalid => 'رمز الاستجابة غير صالح أو منتهي';

  @override
  String get childUpdatedSuccess => 'تم تحديث بيانات الطفل بنجاح';

  @override
  String get childAddedSuccess => 'تمت إضافة الطفل بنجاح';

  @override
  String errorSavingChild(Object error) {
    return 'خطأ في حفظ بيانات الطفل: $error';
  }

  @override
  String get notLoggedIn => 'غير مسجل الدخول';

  @override
  String get pendingApprovalTitle => 'بانتظار الموافقة';

  @override
  String get pendingApprovalMessage =>
      'تم إرسال طلب التسجيل إلى الإدارة.\nيرجى الانتظار حتى تتم مراجعته.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get no => 'لا';

  @override
  String get aiSkinTitle => 'تحليل الجلد بالذكاء الاصطناعي';

  @override
  String get aiSkinChooseImageTitle => 'اختر صورة';

  @override
  String get aiSkinClickHere => 'اضغط هنا';

  @override
  String get aiSkinSubtitle =>
      'احصل على تحليل فوري للجلد بالذكاء الاصطناعي\nوجّه الكاميرا نحو منطقة الجلد';

  @override
  String get aiSkinReuploadButton => 'أعد الرفع';

  @override
  String get aiSkinLatestAnalysis => 'آخر تحليل';

  @override
  String get aiSkinRecommendedTips => 'نصائح العناية الموصى بها:';

  @override
  String get aiSkinHistory => 'سجل التحاليل';

  @override
  String get aiSkinNoHistory => 'لا توجد تحليلات سابقة بعد.';

  @override
  String get aiSkinConfirmImageTitle => 'تأكيد الصورة';

  @override
  String get aiSkinConfirmImageMessage =>
      'هل أنت متأكد أن الصورة واضحة وتُظهر منطقة الجلد المصابة؟';

  @override
  String get aiSkinTooDarkTitle => 'الصورة مظلمة جدًا';

  @override
  String get aiSkinTooDarkMessage => 'الصورة مظلمة جدًا. يرجى رفع صورة أوضح.';

  @override
  String get aiSkinNotDetectedTitle => 'لم يتم الكشف';

  @override
  String get aiSkinNotDetectedMessage =>
      'لم يتم اكتشاف منطقة جلد مصابة. يرجى إعادة رفع صورة واضحة تُظهر المنطقة المصابة.';

  @override
  String get aiSkinReuploadTitle => 'أعد الرفع';

  @override
  String get aiSkinReuploadMessage =>
      'منطقة الجلد غير واضحة. يرجى إعادة رفع الصورة والتأكد من وضوح المنطقة المصابة.';

  @override
  String aiSkinModelLoadFailed(Object error) {
    return 'فشل تحميل النموذج: $error';
  }

  @override
  String get ms_18month_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_18month_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_18month_points_to_show_you_something_interesting =>
      'يشير ليريك شيئًا ممتعًا';

  @override
  String get ms_18month_puts_hands_out_for_you_to_wash_them =>
      'يمد يديه لتغسلهما';

  @override
  String get ms_18month_looks_at_a_few_pages_in_a_book_with_you =>
      'ينظر إلى بعض صفحات كتاب معك';

  @override
  String get ms_18month_speech_language => 'الكلام واللغة';

  @override
  String get ms_18month_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_18month_movement_physical_development =>
      'التطور الحركي والبدني';

  @override
  String get ms_18month_scribbles => 'يخربش';

  @override
  String get ms_18month_feeds_herself_with_her_fingers => 'يأكل بأصابعه';

  @override
  String get ms_18month_tries_to_use_a_spoon => 'يحاول استخدام الملعقة';

  @override
  String get ms_18month_overall_progress => 'التقدم العام';

  @override
  String get ms_24month_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_24month_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_24month_speech_language => 'الكلام واللغة';

  @override
  String get ms_24month_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_24month_movement_physical_development =>
      'التطور الحركي والبدني';

  @override
  String get ms_24month_kicks_a_ball => 'يركل الكرة';

  @override
  String get ms_24month_runs => 'يركض';

  @override
  String get ms_24month_eats_with_a_spoon => 'يأكل بالملعقة';

  @override
  String get ms_24month_overall_progress => 'التقدم العام';

  @override
  String get ms_30month_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_30month_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_30month_language_communication => 'الكلام واللغة';

  @override
  String get ms_30month_says_about_50_words => 'يقول حوالي 50 كلمة';

  @override
  String get ms_30month_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_30month_shows_simple_problem_solving_skills =>
      'يُظهر مهارات بسيطة في حل المشكلات';

  @override
  String get ms_30month_follows_two_step_instructions =>
      'يتبع تعليمات من خطوتين';

  @override
  String get ms_30month_knows_at_least_one_color =>
      'يعرف لونًا واحدًا على الأقل';

  @override
  String get ms_30month_movement_physical_development =>
      'التطور الحركي والبدني';

  @override
  String get ms_30month_uses_hands_to_twist_things =>
      'يستخدم يديه لليّ الأشياء';

  @override
  String get ms_30month_takes_some_clothes_off_by_herself =>
      'ينزع بعض ملابسه بنفسه';

  @override
  String get ms_30month_jumps_off_the_ground_with_both_feet =>
      'يقفز عن الأرض بكلتا القدمين';

  @override
  String get ms_30month_turns_book_pages_one_at_a_time =>
      'يقلب صفحات الكتاب واحدة تلو الأخرى';

  @override
  String get ms_30month_overall_progress => 'التقدم العام';

  @override
  String get ms_3year_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_3year_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_3year_speech_language => 'الكلام واللغة';

  @override
  String get ms_3year_says_first_name_when_asked => 'يقول اسمه الأول عند سؤاله';

  @override
  String get ms_3year_talks_well_enough_for_others_to_understand =>
      'يتحدث بوضوح كافٍ ليفهمه الآخرون';

  @override
  String get ms_3year_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_3year_draws_a_circle_when_you_show_her_how =>
      'يرسم دائرة عندما تريه كيف';

  @override
  String get ms_3year_avoids_touching_hot_objects =>
      'يتجنب لمس الأشياء الساخنة';

  @override
  String get ms_3year_movement_physical_development => 'التطور الحركي والبدني';

  @override
  String get ms_3year_strings_items_together_like_beads =>
      'يربط أشياء معًا مثل الخرز';

  @override
  String get ms_3year_puts_on_some_clothes_by_herself =>
      'يرتدي بعض الملابس بنفسه';

  @override
  String get ms_3year_uses_a_fork => 'يستخدم الشوكة';

  @override
  String get ms_3year_overall_progress => 'التقدم العام';

  @override
  String get ms_4year_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_4year_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_4year_likes_to_be_a_helper => 'يحب أن يكون مساعدًا';

  @override
  String get ms_4year_speech_language => 'الكلام واللغة';

  @override
  String get ms_4year_says_sentences_with_four_or_more_words =>
      'يقول جُملاً من أربع كلمات أو أكثر';

  @override
  String get ms_4year_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_4year_names_a_few_colors_of_items => 'يسمّي بعض ألوان الأشياء';

  @override
  String get ms_4year_draws_a_person_with_three_or_more_body_parts =>
      'يرسم شخصًا بثلاثة أجزاء جسم أو أكثر';

  @override
  String get ms_4year_movement_physical_development => 'التطور الحركي والبدني';

  @override
  String get ms_4year_catches_a_large_ball_most_of_the_time =>
      'يلتقط كرة كبيرة في معظم الأحيان';

  @override
  String get ms_4year_serves_herself_food_or_pours_water =>
      'يقدّم لنفسه الطعام أو يسكب الماء';

  @override
  String get ms_4year_unbuttons_some_buttons => 'يفك بعض الأزرار';

  @override
  String get ms_4year_overall_progress => 'التقدم العام';

  @override
  String get ms_5year_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_5year_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_5year_does_simple_chores_at_home => 'يقوم بأعمال منزلية بسيطة';

  @override
  String get ms_5year_sings_dances_or_acts_for_you => 'يغني أو يرقص أو يمثل لك';

  @override
  String get ms_5year_speech_language => 'الكلام واللغة';

  @override
  String get ms_5year_tells_a_story_she_heard_or_made_up =>
      'يروي قصة سمعها أو اخترعها';

  @override
  String get ms_5year_answers_simple_questions_about_a_story =>
      'يجيب عن أسئلة بسيطة حول قصة';

  @override
  String get ms_5year_keeps_a_conversation_going =>
      'يحافظ على استمرار المحادثة';

  @override
  String get ms_5year_recognizes_simple_rhymes => 'يتعرف على القوافي البسيطة';

  @override
  String get ms_5year_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_5year_counts_to_10 => 'يعد حتى 10';

  @override
  String get ms_5year_names_some_numbers_between_1_5 =>
      'يسمّي بعض الأرقام بين 1 و5';

  @override
  String get ms_5year_uses_time_words_like_yesterday_morning =>
      'يستخدم كلمات الزمن مثل أمس / صباحًا';

  @override
  String get ms_5year_pays_attention_for_5_10_minutes =>
      'ينتبه لمدة 5–10 دقائق';

  @override
  String get ms_5year_writes_some_letters_in_her_name => 'يكتب بعض أحرف اسمه';

  @override
  String get ms_5year_names_some_letters => 'يسمّي بعض الحروف';

  @override
  String get ms_5year_movement_physical_development => 'التطور الحركي والبدني';

  @override
  String get ms_5year_buttons_some_buttons => 'يربط بعض الأزرار';

  @override
  String get ms_5year_hops_on_one_foot => 'يقفز على قدم واحدة';

  @override
  String get ms_5year_overall_progress => 'التقدم العام';

  @override
  String get ms_fifteen_month_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_fifteen_month_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_fifteen_month_shows_you_an_object_she_likes =>
      'يُريك شيئًا يحبه';

  @override
  String get ms_fifteen_month_claps_when_excited => 'يصفق عندما يكون متحمسًا';

  @override
  String get ms_fifteen_month_hugs_stuffed_doll_or_other_toy =>
      'يعانق دمية محشوة أو لعبة أخرى';

  @override
  String get ms_fifteen_month_shows_affection => 'يُظهر المودة';

  @override
  String get ms_fifteen_month_language_communication => 'الكلام واللغة';

  @override
  String get ms_fifteen_month_looks_at_familiar_objects_when_named =>
      'ينظر إلى الأشياء المألوفة عند تسميتها';

  @override
  String get ms_fifteen_month_points_to_ask_for_something => 'يشير ليطلب شيئًا';

  @override
  String get ms_fifteen_month_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_fifteen_month_uses_things_the_right_way_phone_cup =>
      'يستخدم الأشياء بالطريقة الصحيحة (الهاتف، الكوب...)';

  @override
  String get ms_fifteen_month_stacks_two_objects => 'يرص شيئين فوق بعضهما';

  @override
  String get ms_fifteen_month_movement_physical_development =>
      'التطور الحركي والبدني';

  @override
  String get ms_fifteen_month_takes_a_few_steps_on_her_own =>
      'يمشي بضع خطوات بمفرده';

  @override
  String get ms_fifteen_month_feeds_herself_using_fingers =>
      'يأكل بمفرده باستخدام أصابعه';

  @override
  String get ms_fifteen_month_overall_progress => 'التقدم العام';

  @override
  String get ms_four_month_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_four_month_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_four_month_speech_language => 'الكلام واللغة';

  @override
  String get ms_four_month_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_four_month_overall_progress => 'التقدم العام';

  @override
  String get ms_nine_month_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_nine_month_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_nine_month_language_communication => 'الكلام واللغة';

  @override
  String get ms_nine_month_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_nine_month_movement_physical_development =>
      'التطور الحركي والبدني';

  @override
  String get ms_nine_month_overall_progress => 'التقدم العام';

  @override
  String get ms_one_year_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_one_year_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_one_year_waves_bye_bye => 'يلوح مودّعًا';

  @override
  String get ms_one_year_plays_pat_a_cake_with_you =>
      'يلعب معك لعبة «بات‑أ‑كيك»';

  @override
  String get ms_one_year_language_communication => 'الكلام واللغة';

  @override
  String get ms_one_year_says_mama_or_dada => 'يقول ماما أو بابا';

  @override
  String get ms_one_year_understands_no => 'يفهم «لا»';

  @override
  String get ms_one_year_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_one_year_puts_things_in_a_container => 'يضع الأشياء داخل وعاء';

  @override
  String get ms_one_year_looks_for_hidden_toys => 'يبحث عن الألعاب المخفية';

  @override
  String get ms_one_year_movement_physical_development =>
      'التطور الحركي والبدني';

  @override
  String get ms_one_year_pulls_up_to_stand => 'يسحب نفسه للوقوف';

  @override
  String get ms_one_year_walks_holding_furniture => 'يمشي مستندًا إلى الأثاث';

  @override
  String get ms_one_year_drinks_from_a_cup => 'يشرب من كوب';

  @override
  String get ms_one_year_uses_thumb_finger_to_pick_things =>
      'يلتقط الأشياء باستخدام الإبهام والسبابة';

  @override
  String get ms_one_year_overall_progress => 'التقدم العام';

  @override
  String get ms_six_month_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_six_month_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_six_month_knows_familiar_people =>
      'يتعرف على الأشخاص المألوفين';

  @override
  String get ms_six_month_likes_to_look_at_herself_in_a_mirror =>
      'يحب النظر إلى نفسه في المرآة';

  @override
  String get ms_six_month_laughs => 'يضحك';

  @override
  String get ms_six_month_speech_language => 'الكلام واللغة';

  @override
  String get ms_six_month_takes_turns_making_sounds_with_you =>
      'يتبادل إصدار الأصوات معك';

  @override
  String get ms_six_month_blows_raspberries => 'يُصدر أصوات الفقاعات بالشفاه';

  @override
  String get ms_six_month_makes_squealing_noises => 'يصدر أصواتًا عالية حادة';

  @override
  String get ms_six_month_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_six_month_puts_things_in_her_mouth_to_explore_them =>
      'يضع الأشياء في فمه لاستكشافها';

  @override
  String get ms_six_month_reaches_to_grab_a_toy_she_wants =>
      'يمد يده ليمسك لعبة يريدها';

  @override
  String get ms_six_month_closes_lips_to_show_she_doesn_t_want_more_food =>
      'يغلق شفتيه ليُظهر أنه لا يريد المزيد من الطعام';

  @override
  String get ms_six_month_movement_physical_development =>
      'التطور الحركي والبدني';

  @override
  String get ms_six_month_rolls_from_tummy_to_back =>
      'يتدحرج من البطن إلى الظهر';

  @override
  String get ms_six_month_pushes_up_with_straight_arms_when_on_tummy =>
      'يدفع نفسه بذراعين مستقيمتين عند الاستلقاء على البطن';

  @override
  String get ms_six_month_leans_on_hands_to_support_herself_when_sitting =>
      'يسند نفسه على يديه عند الجلوس';

  @override
  String get ms_six_month_overall_progress => 'التقدم العام';

  @override
  String get ms_two_month_developmental_milestones => 'مراحل النمو والتطور';

  @override
  String get ms_two_month_speech_language => 'الكلام واللغة';

  @override
  String get ms_two_month_cognitive_development => 'التطور المعرفي';

  @override
  String get ms_two_month_overall_progress => 'التقدم العام';

  @override
  String
      get ms_18month_moves_away_from_you_but_looks_to_make_sure_you_are_close_by =>
          'يبتعد عنك ثم ينظر ليتأكد أنك قريب';

  @override
  String
      get ms_18month_helps_you_dress_by_pushing_arm_through_sleeve_or_lifting_up_ =>
          'يساعدك في ارتدائه الملابس بدفع ذراعه خلال الكم أو برفع قدمه';

  @override
  String get ms_18month_tries_to_say_three_or_more_words_besides_mama_or_dada =>
      'يحاول قول ثلاث كلمات أو أكثر غير «ماما» أو «بابا»';

  @override
  String
      get ms_18month_follows_one_step_directions_without_gestures_like_give_it_to =>
          'يتبع توجيهات من خطوة واحدة دون إشارات، مثل «أعطني إياه»';

  @override
  String get ms_18month_copies_you_doing_chores_like_sweeping_with_a_broom =>
      'يقلّد قيامك بالأعمال المنزلية، مثل الكنس بالمكنسة';

  @override
  String
      get ms_18month_plays_with_toys_in_a_simple_way_like_pushing_a_toy_car =>
          'يلعب بالألعاب بطريقة بسيطة، مثل دفع سيارة لعبة';

  @override
  String get ms_18month_walks_without_holding_on_to_anyone_or_anything =>
      'يمشي دون الاستناد إلى أحد أو شيء';

  @override
  String
      get ms_18month_drinks_from_a_cup_without_a_lid_and_may_spill_sometimes =>
          'يشرب من كوب دون غطاء وقد يسكب أحيانًا';

  @override
  String get ms_18month_climbs_on_and_off_a_couch_or_chair_without_help =>
      'يصعد وينزل من الأريكة أو الكرسي دون مساعدة';

  @override
  String
      get ms_18month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_18month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String get ms_24month_notices_when_others_are_hurt_or_upset_like_pausing_or_lookin =>
      'يلاحظ عندما يكون الآخرون مجروحين أو منزعجين، مثل التوقف أو الظهور بالحزن عند بكاء أحدهم';

  @override
  String
      get ms_24month_looks_at_your_face_to_see_how_to_react_in_a_new_situation =>
          'ينظر إلى وجهك ليرى كيف يتصرف في موقف جديد';

  @override
  String
      get ms_24month_points_to_things_in_a_book_when_you_ask_like_where_is_the_be =>
          'يشير إلى أشياء في كتاب عندما تسأل، مثل «أين الدب؟»';

  @override
  String get ms_24month_says_at_least_two_words_together_like_more_milk =>
      'يقول كلمتين على الأقل معًا، مثل «مزيد من الحليب»';

  @override
  String
      get ms_24month_points_to_at_least_two_body_parts_when_you_ask_him_to_show_y =>
          'يشير إلى جزأين على الأقل من جسمه عندما تطلب منه ذلك';

  @override
  String get ms_24month_uses_more_gestures_than_just_waving_and_pointing_like_blowin =>
      'يستخدم إيماءات أكثر من التلويح والإشارة فقط، مثل إرسال قبلة أو الإيماء بالرأس نعم';

  @override
  String
      get ms_24month_holds_something_in_one_hand_while_using_the_other_hand_like_ =>
          'يمسك شيئًا بيد ويستخدم اليد الأخرى، مثل إمساك وعاء ونزع غطائه';

  @override
  String get ms_24month_tries_to_use_switches_knobs_or_buttons_on_a_toy =>
      'يحاول استخدام المفاتيح أو المقابض أو الأزرار في لعبة';

  @override
  String
      get ms_24month_plays_with_more_than_one_toy_at_the_same_time_like_putting_t =>
          'يلعب بأكثر من لعبة في الوقت نفسه، مثل وضع طعام لعبة على طبق لعبة';

  @override
  String get ms_24month_walks_not_climbs_up_a_few_stairs_with_or_without_help =>
      'يصعد بضع درجات مشيًا (لا يتسلق) مع مساعدة أو بدونها';

  @override
  String
      get ms_24month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_24month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String
      get ms_30month_plays_next_to_other_children_and_sometimes_plays_with_them =>
          'يلعب بجانب الأطفال الآخرين وأحيانًا يلعب معهم';

  @override
  String get ms_30month_shows_you_what_she_can_do_by_saying_look_at_me =>
      'يُريك ما يستطيع فعله بقول «انظر إلي!»';

  @override
  String get ms_30month_follows_simple_routines_when_told_like_helping_to_pick_up_to =>
      'يتبع الروتينات البسيطة عند إبلاغه، مثل المساعدة في ترتيب الألعاب عندما تقول «حان وقت التنظيف»';

  @override
  String get ms_30month_says_two_or_more_words_together_with_one_action_word =>
      'يقول كلمتين أو أكثر معًا، مع كلمة فعل واحدة';

  @override
  String get ms_30month_names_things_in_a_book_when_you_point_and_ask =>
      'يسمّي الأشياء في كتاب عندما تشير وتسأل';

  @override
  String get ms_30month_says_words_like_i_me_or_we =>
      'يقول كلمات مثل «أنا» أو «لي» أو «نحن»';

  @override
  String get ms_30month_uses_things_to_pretend_feeding_a_block_to_a_doll =>
      'يستخدم الأشياء للتظاهر (إطعام دمية بقطعة مثلًا)';

  @override
  String
      get ms_30month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_30month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String get ms_3year_calms_down_within_10_minutes_after_you_leave_her =>
      'يهدأ خلال 10 دقائق بعد مغادرتك';

  @override
  String get ms_3year_notices_other_children_and_joins_them_to_play =>
      'يلتفت للأطفال الآخرين وينضم إليهم للعب';

  @override
  String get ms_3year_talks_with_you_in_at_least_two_back_and_forth_exchanges =>
      'يتحدث معك في تبادلات متبادلة مرتين على الأقل';

  @override
  String get ms_3year_asks_who_what_where_or_why_questions =>
      'يسأل أسئلة «من» أو «ماذا» أو «أين» أو «لماذا»';

  @override
  String get ms_3year_says_what_action_is_happening_in_a_picture_or_book =>
      'يقول ما يحدث من فعل في صورة أو كتاب';

  @override
  String
      get ms_3year_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_3year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String
      get ms_4year_pretends_to_be_something_else_during_play_teacher_superhero_ =>
          'يتظاهر بأنه شيء آخر أثناء اللعب (معلّم، بطل خارق، كلب)';

  @override
  String get ms_4year_asks_to_go_play_with_children_if_none_are_around =>
      'يطلب الذهاب للعب مع الأطفال إذا لم يكن هناك أحد';

  @override
  String
      get ms_4year_comforts_others_who_are_hurt_or_sad_like_hugging_a_crying_fr =>
          'يواسي الآخرين عندما يكونون متألمين أو حزينين، مثل معانقة صديق يبكي';

  @override
  String
      get ms_4year_avoids_danger_like_not_jumping_from_tall_heights_at_the_play =>
          'يتجنب الخطر، مثل عدم القفز من ارتفاعات عالية في الملعب';

  @override
  String
      get ms_4year_changes_behavior_based_on_where_she_is_library_playground_et =>
          'يغيّر سلوكه حسب المكان (المكتبة، الملعب، إلخ)';

  @override
  String get ms_4year_says_some_words_from_a_song_story_or_nursery_rhyme =>
      'يقول بعض كلمات أغنية أو قصة أو أنشودة أطفال';

  @override
  String
      get ms_4year_talks_about_at_least_one_thing_that_happened_during_her_day =>
          'يتحدث عن شيء واحد على الأقل حدث خلال يومه';

  @override
  String get ms_4year_answers_simple_questions_like_what_is_a_coat_for =>
      'يجيب عن أسئلة بسيطة مثل «لماذا نستخدم المعطف؟»';

  @override
  String get ms_4year_tells_what_comes_next_in_a_well_known_story =>
      'يقول ما الذي سيحدث بعد ذلك في قصة معروفة';

  @override
  String
      get ms_4year_holds_crayon_or_pencil_between_fingers_and_thumb_not_a_fist =>
          'يمسك القلم أو الشمع بين الأصابع والإبهام (وليس قبضة)';

  @override
  String
      get ms_4year_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_4year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String
      get ms_5year_follows_rules_or_takes_turns_when_playing_games_with_other_c =>
          'يتبع القواعد أو يتناوب الدور عند لعب الألعاب مع الأطفال الآخرين';

  @override
  String
      get ms_5year_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_5year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String get ms_fifteen_month_copies_other_children_while_playing_like_taking_toys_out_of_ =>
      'يقلّد الأطفال الآخرين أثناء اللعب، مثل إخراج الألعاب من وعاء عندما يفعل طفل آخر ذلك';

  @override
  String
      get ms_fifteen_month_tries_to_say_one_or_two_words_besides_mama_or_dada =>
          'يحاول قول كلمة أو كلمتين غير «ماما» أو «بابا»';

  @override
  String
      get ms_fifteen_month_follows_directions_with_both_a_gesture_and_words =>
          'يتبع التعليمات مع الإشارة والكلمات معًا';

  @override
  String
      get ms_fifteen_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_fifteen_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String get ms_four_month_smiles_on_his_own_to_get_your_attention =>
      'يبتسم من تلقاء نفسه لجذب انتباهك';

  @override
  String
      get ms_four_month_chuckles_not_a_full_laugh_when_you_try_to_make_her_laugh =>
          'يضحك ضحكة خفيفة (ليست ضحكة كاملة) عندما تحاول إضحاكه';

  @override
  String
      get ms_four_month_looks_at_you_moves_or_makes_sounds_to_get_your_attention =>
          'ينظر إليك أو يتحرك أو يصدر أصواتًا لجذب انتباهك';

  @override
  String get ms_four_month_makes_sounds_like_ooo_aahh_cooing =>
      'يصدر أصواتًا مثل «أوو» و«آاه» (مناغاة)';

  @override
  String get ms_four_month_makes_sounds_back_when_you_talk_to_her =>
      'يرد بأصوات عندما تتحدث إليه';

  @override
  String get ms_four_month_turns_head_towards_sound_of_your_voice =>
      'يدير رأسه باتجاه صوتك';

  @override
  String
      get ms_four_month_if_hungry_opens_mouth_when_she_sees_breast_or_bottle =>
          'إذا كان جائعًا، يفتح فمه عند رؤية الثدي أو الزجاجة';

  @override
  String get ms_four_month_looks_at_hands_with_interest =>
      'ينظر إلى يديه باهتمام';

  @override
  String get ms_four_month_movement_physical_development =>
      'التطور الحركي والبدني';

  @override
  String get ms_four_month_holds_head_steady_without_support =>
      'يثبت رأسه دون دعم';

  @override
  String get ms_four_month_holds_a_toy_when_you_put_it_in_her_hand =>
      'يمسك لعبة عندما تضعها في يده';

  @override
  String get ms_four_month_uses_arm_to_swing_at_toys =>
      'يستخدم ذراعه للتلويح بالألعاب';

  @override
  String get ms_four_month_brings_hands_to_mouth => 'يقرّب يديه إلى فمه';

  @override
  String get ms_four_month_pushes_up_onto_elbows_forearms_when_on_tummy =>
      'يدفع نفسه مستندًا على المرفقين/الساعدين عند الاستلقاء على البطن';

  @override
  String
      get ms_four_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_four_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String get ms_nine_month_is_shy_clingy_or_fearful_around_strangers =>
      'يكون خجولًا أو متشبثًا أو خائفًا حول الغرباء';

  @override
  String
      get ms_nine_month_shows_facial_expressions_like_happy_sad_angry_and_surprised =>
          'يُظهر تعابير الوجه مثل السعادة والحزن والغضب والدهشة';

  @override
  String get ms_nine_month_looks_when_you_call_her_name =>
      'ينظر عندما تناديه باسمه';

  @override
  String get ms_nine_month_makes_sounds_like_mamama_or_babababa =>
      'يصدر أصواتًا مثل «ماماما» أو «بابابابا»';

  @override
  String get ms_nine_month_looks_for_objects_when_dropped_out_of_sight =>
      'يبحث عن الأشياء عند إسقاطها خارج مجال الرؤية';

  @override
  String get ms_nine_month_gets_to_a_sitting_position_by_herself =>
      'يصل إلى وضعية الجلوس بنفسه';

  @override
  String get ms_nine_month_sits_without_support => 'يجلس دون دعم';

  @override
  String
      get ms_nine_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_nine_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String
      get ms_one_year_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_one_year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String
      get ms_six_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_six_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String get ms_two_month_social_emotional => 'الاجتماعي والعاطفي';

  @override
  String get ms_two_month_calms_down_when_spoken_to_or_picked_up =>
      'يهدأ عند الحديث إليه أو حمله';

  @override
  String get ms_two_month_looks_at_your_face => 'ينظر إلى وجهك';

  @override
  String get ms_two_month_seems_happy_to_see_you_when_you_walk_up_to_her =>
      'يبدو سعيدًا عند رؤيتك عندما تقترب منه';

  @override
  String get ms_two_month_smiles_when_you_talk_to_or_smile_at_her =>
      'يبتسم عندما تتحدث إليه أو تبتسم له';

  @override
  String get ms_two_month_makes_cooing_sounds => 'يصدر أصوات المناغاة';

  @override
  String get ms_two_month_reacts_to_loud_sounds => 'يستجيب للأصوات العالية';

  @override
  String get ms_two_month_watches_you_as_you_move => 'يراقبك أثناء تحركك';

  @override
  String get ms_two_month_looks_at_a_toy_for_several_seconds =>
      'ينظر إلى لعبة لعدة ثوانٍ';

  @override
  String get ms_two_month_movement_physical_development =>
      'التطور الحركي والبدني';

  @override
  String get ms_two_month_holds_head_up_when_on_tummy =>
      'يرفع رأسه عند الاستلقاء على البطن';

  @override
  String get ms_two_month_moves_both_arms_and_both_legs =>
      'يحرك ذراعيه وساقيه معًا';

  @override
  String get ms_two_month_opens_hands_briefly => 'يفتح يديه لفترة قصيرة';

  @override
  String
      get ms_two_month_only_check_milestones_you_re_confident_your_child_has_achiev =>
          'حدّد فقط المعالم التي أنت متأكد أن طفلك حققها';

  @override
  String ms_two_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones) {
    return '$completedCount من أصل $totalMilestones مهارة مكتملة';
  }

  @override
  String get activityLibraryTitle => 'مكتبة الأنشطة';

  @override
  String get act_2m_1 => 'انظر في عيني طفلك وابتسم له';

  @override
  String get act_2m_2 => 'تحدث مع طفلك أثناء الرضاعة وتغيير الحفاض';

  @override
  String get act_2m_3 => 'قلّد أصوات طفلك وانتظر منه ردًا';

  @override
  String get act_2m_4 => 'ضع مرآة آمنة للطفل لاستكشاف الوجه';

  @override
  String get act_2m_5 => 'وفر وقتًا قصيرًا للبطن تحت الإشراف';

  @override
  String get act_2m_6 => 'اعرض صورًا أو وجوهًا عالية التباين';

  @override
  String get act_4m_1 => 'حرّك لعبة ببطء ليتابعها طفلك بعينيه';

  @override
  String get act_4m_2 => 'اسمح لطفلك بمد يده للألعاب القريبة';

  @override
  String get act_4m_3 => 'اهزّ خشخيشة ودع طفلك يتتبع الصوت';

  @override
  String get act_4m_4 => 'غنِّ أغانٍ مع تحريك الذراعين والساقين بلطف';

  @override
  String get act_4m_5 => 'العب على بساط أرضي مع ألعاب حول الطفل';

  @override
  String get act_4m_6 => 'شجّع الركل بوضع ألعاب قرب القدمين';

  @override
  String get act_6m_1 => 'اسند طفلك للجلوس أثناء اللعب بالألعاب';

  @override
  String get act_6m_2 => 'ضع ألعابًا خارج المتناول قليلًا لتشجيع التدحرج';

  @override
  String get act_6m_3 => 'سمِّ الأشياء التي ينظر إليها طفلك';

  @override
  String get act_6m_4 => 'دع طفلك يُسقط الأشياء ويشاهد سقوطها';

  @override
  String get act_6m_5 => 'استكشف الملمس باستخدام أدوات منزلية آمنة';

  @override
  String get act_6m_6 => 'شغّل موسيقى ودع طفلك يستمع ويتفاعل';

  @override
  String get act_9m_1 => 'أخفِ لعبة تحت قماش ودع طفلك يجدها';

  @override
  String get act_9m_2 => 'شجّع الزحف بوضع الألعاب بعيدًا قليلًا';

  @override
  String get act_9m_3 => 'تمرّنوا على إيماءات بسيطة مثل التلويح';

  @override
  String get act_9m_4 => 'تبادلوا الألعاب ذهابًا وإيابًا بالتناوب';

  @override
  String get act_9m_5 => 'دع طفلك يسحب نفسه للوقوف باستخدام أثاث آمن';

  @override
  String get act_9m_6 => 'افرغوا الألعاب من وعاء وأعيدوا ملأه معًا';

  @override
  String get act_1y_1 => 'اقرأ كتب الصور وسمِّ الأشياء المألوفة';

  @override
  String get act_1y_2 => 'شجّع المشي باستخدام ألعاب الدفع';

  @override
  String get act_1y_3 => 'دع طفلك يطرق أواني المطبخ أو آلات بسيطة';

  @override
  String get act_1y_4 => 'استجب بالكلمات عندما يشير طفلك';

  @override
  String get act_1y_5 => 'العبوا ألعاب التقليد (التصفيق، التلويح)';

  @override
  String get act_1y_6 => 'وسّع كلمات طفلك المفردة';

  @override
  String get act_15m_1 => 'ارصّوا المكعبات واهدموها معًا';

  @override
  String get act_15m_2 => 'العبوا تمثيلًا بسيطًا باستخدام الدمى المحشوة';

  @override
  String get act_15m_3 => 'غنّوا أغانٍ مع حركات (اليدين، القدمين، الرأس)';

  @override
  String get act_15m_4 => 'دع طفلك يساعد في ترتيب الألعاب';

  @override
  String get act_15m_5 => 'قدّم أقلام تلوين للخربشة';

  @override
  String get act_15m_6 => 'تمرّنوا على الشرب من الكوب واستخدام الملعقة';

  @override
  String get act_18m_1 => 'سمِّ أجزاء الجسم أثناء اللعب';

  @override
  String get act_18m_2 => 'دحرجوا الكرة ذهابًا وإيابًا';

  @override
  String get act_18m_3 => 'قدّم خيارين ودع طفلك يختار';

  @override
  String get act_18m_4 => 'شجّع اللعب التخيّلي بالدمى أو طعام اللعب';

  @override
  String get act_18m_5 => 'انفخ فقاعات ودع طفلك يفرقعها';

  @override
  String get act_18m_6 => 'تحدث عن مشاعر بسيطة باستخدام الكلمات';

  @override
  String get act_2y_1 => 'حلّوا أحاجي بسيطة معًا';

  @override
  String get act_2y_2 => 'دع طفلك يساعد في أعمال بسيطة';

  @override
  String get act_2y_3 => 'العبوا بالرمل أو الماء باستخدام الأكواب';

  @override
  String get act_2y_4 => 'اركُلوا الكرات وارموها في الخارج';

  @override
  String get act_2y_5 => 'ارسموا بالأقلام أو بالألوان بالأصابع';

  @override
  String get act_2y_6 => 'ابنوا أبراجًا بالمكعبات';

  @override
  String get act_30m_1 => 'شجّع اللعب مع أطفال آخرين';

  @override
  String get act_30m_2 => 'اطرح أسئلة بسيطة عن الصور أو القصص';

  @override
  String get act_30m_3 => 'صنّفوا الأشياء حسب الحجم أو اللون';

  @override
  String get act_30m_4 => 'استخدموا الطباشير أو ألوانًا قابلة للغسل للرسم';

  @override
  String get act_30m_5 => 'العبوا تمثيلًا باستخدام صناديق أو أدوات منزلية';

  @override
  String get act_30m_6 => 'تمرّنوا على المشاركة أثناء اللعب';

  @override
  String get act_3y_1 => 'العبوا ألعاب العد باستخدام أشياء يومية';

  @override
  String get act_3y_2 => 'طابقوا الأشكال أو الصور';

  @override
  String get act_3y_3 => 'العبوا بالصلصال';

  @override
  String get act_3y_4 => 'مثّلوا قصصًا قصيرة معًا';

  @override
  String get act_3y_5 => 'تحدثوا عن المشاعر والتهدئة';

  @override
  String get act_3y_6 => 'ساعد طفلك على قول اسمه وعمره';

  @override
  String get act_4y_1 => 'العبوا ألعاب لوحية أو مطابقة بقواعد بسيطة';

  @override
  String get act_4y_2 => 'عدّوا الأشياء أثناء الأنشطة اليومية';

  @override
  String get act_4y_3 => 'مثّلوا مواقف جديدة (طبيب، مدرسة)';

  @override
  String get act_4y_4 => 'العبوا ألعابًا جماعية في الهواء الطلق';

  @override
  String get act_4y_5 => 'ساعد في أعمال بسيطة';

  @override
  String get act_4y_6 => 'تمرّنوا على تبادل الأدوار أثناء اللعب';

  @override
  String get act_5y_1 => 'العبوا ألعاب الذاكرة أو التركيز';

  @override
  String get act_5y_2 => 'العبوا ألعاب الكلمات المتقافية';

  @override
  String get act_5y_3 => 'ابنوا بمكعبات معقدة أو ألعاب تركيب';

  @override
  String get act_5y_4 => 'حلّوا مشكلات بسيطة أثناء اللعب';

  @override
  String get act_5y_5 => 'شجّع المهام اليومية المستقلة';

  @override
  String get act_5y_6 => 'حضّروا لروتين المدرسة من خلال اللعب';

  @override
  String get childQrPopupInstruction =>
      'اعرض رمز الاستجابة هذا لمقدم الرعاية الصحية';

  @override
  String get close => 'إغلاق';
}
