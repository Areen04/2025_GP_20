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
      'وجّه الكاميرا نحو الرمز داخل الإطار أدناه\\nلبدء عملية التعريف.';

  @override
  String get qrInvalid => 'رمز الاستجابة غير صالح أو منتهي';

  @override
  String get childUpdatedSuccess => 'تم تحديث بيانات الطفل بنجاح';

  @override
  String errorSavingChild(Object error) {
    return 'خطأ في حفظ بيانات الطفل: $error';
  }
}
