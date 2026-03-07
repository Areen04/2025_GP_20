import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Log In Failed'**
  String get loginFailed;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get pleaseFillAllFields;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get invalidEmailFormat;

  /// No description provided for @noUserFoundWithEmail.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email.'**
  String get noUserFoundWithEmail;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get incorrectPassword;

  /// No description provided for @emailOrPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get emailOrPasswordIncorrect;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// No description provided for @userNotFoundCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'User not found. Please check your email.'**
  String get userNotFoundCheckEmail;

  /// No description provided for @doctorNotApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your doctor account is not approved yet. Please wait for admin approval.'**
  String get doctorNotApprovedMessage;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @emailSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Sent'**
  String get emailSentTitle;

  /// No description provided for @resetLinkSentTo.
  ///
  /// In en, this message translates to:
  /// **'A reset link has been sent to {email}.'**
  String resetLinkSentTo(Object email);

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @pleaseEnterEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email first.'**
  String get pleaseEnterEmailFirst;

  /// No description provided for @noUserFoundWithThatEmail.
  ///
  /// In en, this message translates to:
  /// **'No user found with that email.'**
  String get noUserFoundWithThatEmail;

  /// No description provided for @somethingWentWrongTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get somethingWentWrongTryAgain;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @parentTab.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parentTab;

  /// No description provided for @healthcareProviderTab.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Provider'**
  String get healthcareProviderTab;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @enterFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Full Name'**
  String get enterFullNameHint;

  /// No description provided for @emailExampleHint.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get emailExampleHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @reenterPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get reenterPasswordHint;

  /// No description provided for @passwordReqAtLeast8.
  ///
  /// In en, this message translates to:
  /// **'• At least 8 characters'**
  String get passwordReqAtLeast8;

  /// No description provided for @passwordReqUppercase.
  ///
  /// In en, this message translates to:
  /// **'• One uppercase letter'**
  String get passwordReqUppercase;

  /// No description provided for @passwordReqLowercase.
  ///
  /// In en, this message translates to:
  /// **'• One lowercase letter'**
  String get passwordReqLowercase;

  /// No description provided for @passwordReqNumber.
  ///
  /// In en, this message translates to:
  /// **'• One number'**
  String get passwordReqNumber;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginLink;

  /// No description provided for @fullNameMin2Error.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 2 characters.'**
  String get fullNameMin2Error;

  /// No description provided for @validEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get validEmailError;

  /// No description provided for @passwordRequirementsError.
  ///
  /// In en, this message translates to:
  /// **'Password must meet all requirements.'**
  String get passwordRequirementsError;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error occurred.'**
  String get errorOccurred;

  /// No description provided for @documentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get documentTypeLabel;

  /// No description provided for @selectDocumentTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select document type'**
  String get selectDocumentTypeHint;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @iqama.
  ///
  /// In en, this message translates to:
  /// **'Iqama'**
  String get iqama;

  /// No description provided for @passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get passport;

  /// No description provided for @medicalLicense.
  ///
  /// In en, this message translates to:
  /// **'Medical License'**
  String get medicalLicense;

  /// No description provided for @documentNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Document Number'**
  String get documentNumberLabel;

  /// No description provided for @enterDocumentNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your document number'**
  String get enterDocumentNumberHint;

  /// No description provided for @documentNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Document number is invalid for selected type.'**
  String get documentNumberInvalid;

  /// No description provided for @pendingReviewInfo.
  ///
  /// In en, this message translates to:
  /// **'Your account status will be \"Pending Review\" upon submission. You will not be able to log in until your credentials have been verified and approved by our administration. This process typically takes 1–2 business days.'**
  String get pendingReviewInfo;

  /// No description provided for @submitForReview.
  ///
  /// In en, this message translates to:
  /// **'Submit for Review'**
  String get submitForReview;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @enterYourFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullNameHint;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'Account Actions'**
  String get accountActions;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @resetPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'A password reset link will be sent to:\n{email}\nPress Send to continue.'**
  String resetPasswordMessage(Object email);

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameCannotBeEmpty;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {error}'**
  String errorLoadingProfile(Object error);

  /// No description provided for @errorUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile: {error}'**
  String errorUpdatingProfile(Object error);

  /// No description provided for @errorDeletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account: {error}'**
  String errorDeletingAccount(Object error);

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account permanently?'**
  String get confirmDeleteMessage;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get confirmLogoutTitle;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogoutMessage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @passwordResetLinkSentTo.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to {email}'**
  String passwordResetLinkSentTo(Object email);

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(Object error);

  /// No description provided for @helloParent.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloParent(Object name);

  /// No description provided for @parentGreeting.
  ///
  /// In en, this message translates to:
  /// **'Manage your children\'s health journey.'**
  String get parentGreeting;

  /// No description provided for @noChildrenYet.
  ///
  /// In en, this message translates to:
  /// **'There\'s no children yet.'**
  String get noChildrenYet;

  /// No description provided for @deleteChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Child'**
  String get deleteChildTitle;

  /// No description provided for @deleteChildConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this child?'**
  String get deleteChildConfirm;

  /// No description provided for @childDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Child deleted successfully'**
  String get childDeletedSuccess;

  /// No description provided for @errorDeletingChild.
  ///
  /// In en, this message translates to:
  /// **'Error deleting child: {error}'**
  String errorDeletingChild(Object error);

  /// No description provided for @addNewChild.
  ///
  /// In en, this message translates to:
  /// **'Add New Child'**
  String get addNewChild;

  /// No description provided for @addChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChildTitle;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @childFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Child\'s Full Name'**
  String get childFullNameLabel;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthLabel;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayLabel;

  /// No description provided for @monthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthLabel;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @selectGenderHint.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get selectGenderHint;

  /// No description provided for @maleLabel.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get maleLabel;

  /// No description provided for @femaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleLabel;

  /// No description provided for @addChildButton.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChildButton;

  /// No description provided for @fillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields.'**
  String get fillAllRequiredFields;

  /// No description provided for @dobFutureError.
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be in the future.'**
  String get dobFutureError;

  /// No description provided for @editChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Child'**
  String get editChildTitle;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @enterChildFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter child\'s full name'**
  String get enterChildFullNameHint;

  /// No description provided for @helloDoctor.
  ///
  /// In en, this message translates to:
  /// **'Hello, Dr. {name}'**
  String helloDoctor(Object name);

  /// No description provided for @doctorLabel.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorLabel;

  /// No description provided for @doctorGreeting.
  ///
  /// In en, this message translates to:
  /// **'Manage visit time more efficiently by reviewing your patients’ health information.'**
  String get doctorGreeting;

  /// No description provided for @scanQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Child\'s QR Code'**
  String get scanQrTitle;

  /// No description provided for @scanQrInstruction.
  ///
  /// In en, this message translates to:
  /// **'Align the QR code within the frame below\nto view their health profile during the visit.'**
  String get scanQrInstruction;

  /// No description provided for @qrInvalid.
  ///
  /// In en, this message translates to:
  /// **'QR code expired or invalid'**
  String get qrInvalid;

  /// No description provided for @childUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Child information updated successfully'**
  String get childUpdatedSuccess;

  /// No description provided for @childAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Child added successfully'**
  String get childAddedSuccess;

  /// No description provided for @errorSavingChild.
  ///
  /// In en, this message translates to:
  /// **'Error saving child: {error}'**
  String errorSavingChild(Object error);

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In en, this message translates to:
  /// **'Your registration request has been sent to the admin.\nPlease wait until it is reviewed.'**
  String get pendingApprovalMessage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @aiSkinTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Skin Analysis'**
  String get aiSkinTitle;

  /// No description provided for @aiSkinChooseImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get aiSkinChooseImageTitle;

  /// No description provided for @aiSkinClickHere.
  ///
  /// In en, this message translates to:
  /// **'Click Here'**
  String get aiSkinClickHere;

  /// No description provided for @aiSkinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get an instant AI-powered skin analysis\nFocus the camera on the skin area'**
  String get aiSkinSubtitle;

  /// No description provided for @aiSkinReuploadButton.
  ///
  /// In en, this message translates to:
  /// **'Re-upload'**
  String get aiSkinReuploadButton;

  /// No description provided for @aiSkinLatestAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Latest Analysis'**
  String get aiSkinLatestAnalysis;

  /// No description provided for @aiSkinRecommendedTips.
  ///
  /// In en, this message translates to:
  /// **'Recommended care tips:'**
  String get aiSkinRecommendedTips;

  /// No description provided for @aiSkinHistory.
  ///
  /// In en, this message translates to:
  /// **'Analysis History'**
  String get aiSkinHistory;

  /// No description provided for @aiSkinNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No previous analyses yet.'**
  String get aiSkinNoHistory;

  /// No description provided for @aiSkinConfirmImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Image'**
  String get aiSkinConfirmImageTitle;

  /// No description provided for @aiSkinConfirmImageMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure this image is clear and shows the affected skin area?'**
  String get aiSkinConfirmImageMessage;

  /// No description provided for @aiSkinTooDarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Too Dark'**
  String get aiSkinTooDarkTitle;

  /// No description provided for @aiSkinTooDarkMessage.
  ///
  /// In en, this message translates to:
  /// **'The image is too dark. Please upload a clearer photo.'**
  String get aiSkinTooDarkMessage;

  /// No description provided for @aiSkinNotDetectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Detected'**
  String get aiSkinNotDetectedTitle;

  /// No description provided for @aiSkinNotDetectedMessage.
  ///
  /// In en, this message translates to:
  /// **'No infected skin area detected. Please re-upload a valid skin photo showing the affected area.'**
  String get aiSkinNotDetectedMessage;

  /// No description provided for @aiSkinReuploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Re-upload'**
  String get aiSkinReuploadTitle;

  /// No description provided for @aiSkinReuploadMessage.
  ///
  /// In en, this message translates to:
  /// **'The skin area isn’t clear. Please re-upload the photo and make sure the affected skin is clear.'**
  String get aiSkinReuploadMessage;

  /// No description provided for @aiSkinModelLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load model: {error}'**
  String aiSkinModelLoadFailed(Object error);

  /// No description provided for @ms_18month_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_18month_developmental_milestones;

  /// No description provided for @ms_18month_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_18month_social_emotional;

  /// No description provided for @ms_18month_points_to_show_you_something_interesting.
  ///
  /// In en, this message translates to:
  /// **'Points to show you something interesting'**
  String get ms_18month_points_to_show_you_something_interesting;

  /// No description provided for @ms_18month_puts_hands_out_for_you_to_wash_them.
  ///
  /// In en, this message translates to:
  /// **'Puts hands out for you to wash them'**
  String get ms_18month_puts_hands_out_for_you_to_wash_them;

  /// No description provided for @ms_18month_looks_at_a_few_pages_in_a_book_with_you.
  ///
  /// In en, this message translates to:
  /// **'Looks at a few pages in a book with you'**
  String get ms_18month_looks_at_a_few_pages_in_a_book_with_you;

  /// No description provided for @ms_18month_speech_language.
  ///
  /// In en, this message translates to:
  /// **'Speech & Language'**
  String get ms_18month_speech_language;

  /// No description provided for @ms_18month_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_18month_cognitive_development;

  /// No description provided for @ms_18month_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_18month_movement_physical_development;

  /// No description provided for @ms_18month_scribbles.
  ///
  /// In en, this message translates to:
  /// **'Scribbles'**
  String get ms_18month_scribbles;

  /// No description provided for @ms_18month_feeds_herself_with_her_fingers.
  ///
  /// In en, this message translates to:
  /// **'Feeds herself with her fingers'**
  String get ms_18month_feeds_herself_with_her_fingers;

  /// No description provided for @ms_18month_tries_to_use_a_spoon.
  ///
  /// In en, this message translates to:
  /// **'Tries to use a spoon'**
  String get ms_18month_tries_to_use_a_spoon;

  /// No description provided for @ms_18month_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_18month_overall_progress;

  /// No description provided for @ms_24month_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_24month_developmental_milestones;

  /// No description provided for @ms_24month_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_24month_social_emotional;

  /// No description provided for @ms_24month_speech_language.
  ///
  /// In en, this message translates to:
  /// **'Speech & Language'**
  String get ms_24month_speech_language;

  /// No description provided for @ms_24month_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_24month_cognitive_development;

  /// No description provided for @ms_24month_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_24month_movement_physical_development;

  /// No description provided for @ms_24month_kicks_a_ball.
  ///
  /// In en, this message translates to:
  /// **'Kicks a ball'**
  String get ms_24month_kicks_a_ball;

  /// No description provided for @ms_24month_runs.
  ///
  /// In en, this message translates to:
  /// **'Runs'**
  String get ms_24month_runs;

  /// No description provided for @ms_24month_eats_with_a_spoon.
  ///
  /// In en, this message translates to:
  /// **'Eats with a spoon'**
  String get ms_24month_eats_with_a_spoon;

  /// No description provided for @ms_24month_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_24month_overall_progress;

  /// No description provided for @ms_30month_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_30month_developmental_milestones;

  /// No description provided for @ms_30month_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_30month_social_emotional;

  /// No description provided for @ms_30month_language_communication.
  ///
  /// In en, this message translates to:
  /// **'Language & Communication'**
  String get ms_30month_language_communication;

  /// No description provided for @ms_30month_says_about_50_words.
  ///
  /// In en, this message translates to:
  /// **'Says about 50 words'**
  String get ms_30month_says_about_50_words;

  /// No description provided for @ms_30month_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_30month_cognitive_development;

  /// No description provided for @ms_30month_shows_simple_problem_solving_skills.
  ///
  /// In en, this message translates to:
  /// **'Shows simple problem-solving skills'**
  String get ms_30month_shows_simple_problem_solving_skills;

  /// No description provided for @ms_30month_follows_two_step_instructions.
  ///
  /// In en, this message translates to:
  /// **'Follows two-step instructions'**
  String get ms_30month_follows_two_step_instructions;

  /// No description provided for @ms_30month_knows_at_least_one_color.
  ///
  /// In en, this message translates to:
  /// **'Knows at least one color'**
  String get ms_30month_knows_at_least_one_color;

  /// No description provided for @ms_30month_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_30month_movement_physical_development;

  /// No description provided for @ms_30month_uses_hands_to_twist_things.
  ///
  /// In en, this message translates to:
  /// **'Uses hands to twist things'**
  String get ms_30month_uses_hands_to_twist_things;

  /// No description provided for @ms_30month_takes_some_clothes_off_by_herself.
  ///
  /// In en, this message translates to:
  /// **'Takes some clothes off by herself'**
  String get ms_30month_takes_some_clothes_off_by_herself;

  /// No description provided for @ms_30month_jumps_off_the_ground_with_both_feet.
  ///
  /// In en, this message translates to:
  /// **'Jumps off the ground with both feet'**
  String get ms_30month_jumps_off_the_ground_with_both_feet;

  /// No description provided for @ms_30month_turns_book_pages_one_at_a_time.
  ///
  /// In en, this message translates to:
  /// **'Turns book pages one at a time'**
  String get ms_30month_turns_book_pages_one_at_a_time;

  /// No description provided for @ms_30month_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_30month_overall_progress;

  /// No description provided for @ms_3year_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_3year_developmental_milestones;

  /// No description provided for @ms_3year_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_3year_social_emotional;

  /// No description provided for @ms_3year_speech_language.
  ///
  /// In en, this message translates to:
  /// **'Speech & Language'**
  String get ms_3year_speech_language;

  /// No description provided for @ms_3year_says_first_name_when_asked.
  ///
  /// In en, this message translates to:
  /// **'Says first name when asked'**
  String get ms_3year_says_first_name_when_asked;

  /// No description provided for @ms_3year_talks_well_enough_for_others_to_understand.
  ///
  /// In en, this message translates to:
  /// **'Talks well enough for others to understand'**
  String get ms_3year_talks_well_enough_for_others_to_understand;

  /// No description provided for @ms_3year_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_3year_cognitive_development;

  /// No description provided for @ms_3year_draws_a_circle_when_you_show_her_how.
  ///
  /// In en, this message translates to:
  /// **'Draws a circle when you show her how'**
  String get ms_3year_draws_a_circle_when_you_show_her_how;

  /// No description provided for @ms_3year_avoids_touching_hot_objects.
  ///
  /// In en, this message translates to:
  /// **'Avoids touching hot objects'**
  String get ms_3year_avoids_touching_hot_objects;

  /// No description provided for @ms_3year_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_3year_movement_physical_development;

  /// No description provided for @ms_3year_strings_items_together_like_beads.
  ///
  /// In en, this message translates to:
  /// **'Strings items together like beads'**
  String get ms_3year_strings_items_together_like_beads;

  /// No description provided for @ms_3year_puts_on_some_clothes_by_herself.
  ///
  /// In en, this message translates to:
  /// **'Puts on some clothes by herself'**
  String get ms_3year_puts_on_some_clothes_by_herself;

  /// No description provided for @ms_3year_uses_a_fork.
  ///
  /// In en, this message translates to:
  /// **'Uses a fork'**
  String get ms_3year_uses_a_fork;

  /// No description provided for @ms_3year_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_3year_overall_progress;

  /// No description provided for @ms_4year_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_4year_developmental_milestones;

  /// No description provided for @ms_4year_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_4year_social_emotional;

  /// No description provided for @ms_4year_likes_to_be_a_helper.
  ///
  /// In en, this message translates to:
  /// **'Likes to be a helper'**
  String get ms_4year_likes_to_be_a_helper;

  /// No description provided for @ms_4year_speech_language.
  ///
  /// In en, this message translates to:
  /// **'Speech & Language'**
  String get ms_4year_speech_language;

  /// No description provided for @ms_4year_says_sentences_with_four_or_more_words.
  ///
  /// In en, this message translates to:
  /// **'Says sentences with four or more words'**
  String get ms_4year_says_sentences_with_four_or_more_words;

  /// No description provided for @ms_4year_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_4year_cognitive_development;

  /// No description provided for @ms_4year_names_a_few_colors_of_items.
  ///
  /// In en, this message translates to:
  /// **'Names a few colors of items'**
  String get ms_4year_names_a_few_colors_of_items;

  /// No description provided for @ms_4year_draws_a_person_with_three_or_more_body_parts.
  ///
  /// In en, this message translates to:
  /// **'Draws a person with three or more body parts'**
  String get ms_4year_draws_a_person_with_three_or_more_body_parts;

  /// No description provided for @ms_4year_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_4year_movement_physical_development;

  /// No description provided for @ms_4year_catches_a_large_ball_most_of_the_time.
  ///
  /// In en, this message translates to:
  /// **'Catches a large ball most of the time'**
  String get ms_4year_catches_a_large_ball_most_of_the_time;

  /// No description provided for @ms_4year_serves_herself_food_or_pours_water.
  ///
  /// In en, this message translates to:
  /// **'Serves herself food or pours water'**
  String get ms_4year_serves_herself_food_or_pours_water;

  /// No description provided for @ms_4year_unbuttons_some_buttons.
  ///
  /// In en, this message translates to:
  /// **'Unbuttons some buttons'**
  String get ms_4year_unbuttons_some_buttons;

  /// No description provided for @ms_4year_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_4year_overall_progress;

  /// No description provided for @ms_5year_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_5year_developmental_milestones;

  /// No description provided for @ms_5year_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_5year_social_emotional;

  /// No description provided for @ms_5year_does_simple_chores_at_home.
  ///
  /// In en, this message translates to:
  /// **'Does simple chores at home'**
  String get ms_5year_does_simple_chores_at_home;

  /// No description provided for @ms_5year_sings_dances_or_acts_for_you.
  ///
  /// In en, this message translates to:
  /// **'Sings, dances, or acts for you'**
  String get ms_5year_sings_dances_or_acts_for_you;

  /// No description provided for @ms_5year_speech_language.
  ///
  /// In en, this message translates to:
  /// **'Speech & Language'**
  String get ms_5year_speech_language;

  /// No description provided for @ms_5year_tells_a_story_she_heard_or_made_up.
  ///
  /// In en, this message translates to:
  /// **'Tells a story she heard or made up'**
  String get ms_5year_tells_a_story_she_heard_or_made_up;

  /// No description provided for @ms_5year_answers_simple_questions_about_a_story.
  ///
  /// In en, this message translates to:
  /// **'Answers simple questions about a story'**
  String get ms_5year_answers_simple_questions_about_a_story;

  /// No description provided for @ms_5year_keeps_a_conversation_going.
  ///
  /// In en, this message translates to:
  /// **'Keeps a conversation going'**
  String get ms_5year_keeps_a_conversation_going;

  /// No description provided for @ms_5year_recognizes_simple_rhymes.
  ///
  /// In en, this message translates to:
  /// **'Recognizes simple rhymes'**
  String get ms_5year_recognizes_simple_rhymes;

  /// No description provided for @ms_5year_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_5year_cognitive_development;

  /// No description provided for @ms_5year_counts_to_10.
  ///
  /// In en, this message translates to:
  /// **'Counts to 10'**
  String get ms_5year_counts_to_10;

  /// No description provided for @ms_5year_names_some_numbers_between_1_5.
  ///
  /// In en, this message translates to:
  /// **'Names some numbers between 1–5'**
  String get ms_5year_names_some_numbers_between_1_5;

  /// No description provided for @ms_5year_uses_time_words_like_yesterday_morning.
  ///
  /// In en, this message translates to:
  /// **'Uses time words like yesterday / morning'**
  String get ms_5year_uses_time_words_like_yesterday_morning;

  /// No description provided for @ms_5year_pays_attention_for_5_10_minutes.
  ///
  /// In en, this message translates to:
  /// **'Pays attention for 5–10 minutes'**
  String get ms_5year_pays_attention_for_5_10_minutes;

  /// No description provided for @ms_5year_writes_some_letters_in_her_name.
  ///
  /// In en, this message translates to:
  /// **'Writes some letters in her name'**
  String get ms_5year_writes_some_letters_in_her_name;

  /// No description provided for @ms_5year_names_some_letters.
  ///
  /// In en, this message translates to:
  /// **'Names some letters'**
  String get ms_5year_names_some_letters;

  /// No description provided for @ms_5year_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_5year_movement_physical_development;

  /// No description provided for @ms_5year_buttons_some_buttons.
  ///
  /// In en, this message translates to:
  /// **'Buttons some buttons'**
  String get ms_5year_buttons_some_buttons;

  /// No description provided for @ms_5year_hops_on_one_foot.
  ///
  /// In en, this message translates to:
  /// **'Hops on one foot'**
  String get ms_5year_hops_on_one_foot;

  /// No description provided for @ms_5year_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_5year_overall_progress;

  /// No description provided for @ms_fifteen_month_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_fifteen_month_developmental_milestones;

  /// No description provided for @ms_fifteen_month_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_fifteen_month_social_emotional;

  /// No description provided for @ms_fifteen_month_shows_you_an_object_she_likes.
  ///
  /// In en, this message translates to:
  /// **'Shows you an object she likes'**
  String get ms_fifteen_month_shows_you_an_object_she_likes;

  /// No description provided for @ms_fifteen_month_claps_when_excited.
  ///
  /// In en, this message translates to:
  /// **'Claps when excited'**
  String get ms_fifteen_month_claps_when_excited;

  /// No description provided for @ms_fifteen_month_hugs_stuffed_doll_or_other_toy.
  ///
  /// In en, this message translates to:
  /// **'Hugs stuffed doll or other toy'**
  String get ms_fifteen_month_hugs_stuffed_doll_or_other_toy;

  /// No description provided for @ms_fifteen_month_shows_affection.
  ///
  /// In en, this message translates to:
  /// **'Shows affection'**
  String get ms_fifteen_month_shows_affection;

  /// No description provided for @ms_fifteen_month_language_communication.
  ///
  /// In en, this message translates to:
  /// **'Language & Communication'**
  String get ms_fifteen_month_language_communication;

  /// No description provided for @ms_fifteen_month_looks_at_familiar_objects_when_named.
  ///
  /// In en, this message translates to:
  /// **'Looks at familiar objects when named'**
  String get ms_fifteen_month_looks_at_familiar_objects_when_named;

  /// No description provided for @ms_fifteen_month_points_to_ask_for_something.
  ///
  /// In en, this message translates to:
  /// **'Points to ask for something'**
  String get ms_fifteen_month_points_to_ask_for_something;

  /// No description provided for @ms_fifteen_month_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_fifteen_month_cognitive_development;

  /// No description provided for @ms_fifteen_month_uses_things_the_right_way_phone_cup.
  ///
  /// In en, this message translates to:
  /// **'Uses things the right way (phone, cup...)'**
  String get ms_fifteen_month_uses_things_the_right_way_phone_cup;

  /// No description provided for @ms_fifteen_month_stacks_two_objects.
  ///
  /// In en, this message translates to:
  /// **'Stacks two objects'**
  String get ms_fifteen_month_stacks_two_objects;

  /// No description provided for @ms_fifteen_month_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_fifteen_month_movement_physical_development;

  /// No description provided for @ms_fifteen_month_takes_a_few_steps_on_her_own.
  ///
  /// In en, this message translates to:
  /// **'Takes a few steps on her own'**
  String get ms_fifteen_month_takes_a_few_steps_on_her_own;

  /// No description provided for @ms_fifteen_month_feeds_herself_using_fingers.
  ///
  /// In en, this message translates to:
  /// **'Feeds herself using fingers'**
  String get ms_fifteen_month_feeds_herself_using_fingers;

  /// No description provided for @ms_fifteen_month_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_fifteen_month_overall_progress;

  /// No description provided for @ms_four_month_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_four_month_developmental_milestones;

  /// No description provided for @ms_four_month_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_four_month_social_emotional;

  /// No description provided for @ms_four_month_speech_language.
  ///
  /// In en, this message translates to:
  /// **'Speech & Language'**
  String get ms_four_month_speech_language;

  /// No description provided for @ms_four_month_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_four_month_cognitive_development;

  /// No description provided for @ms_four_month_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_four_month_overall_progress;

  /// No description provided for @ms_nine_month_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_nine_month_developmental_milestones;

  /// No description provided for @ms_nine_month_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_nine_month_social_emotional;

  /// No description provided for @ms_nine_month_language_communication.
  ///
  /// In en, this message translates to:
  /// **'Language & Communication'**
  String get ms_nine_month_language_communication;

  /// No description provided for @ms_nine_month_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_nine_month_cognitive_development;

  /// No description provided for @ms_nine_month_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_nine_month_movement_physical_development;

  /// No description provided for @ms_nine_month_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_nine_month_overall_progress;

  /// No description provided for @ms_one_year_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_one_year_developmental_milestones;

  /// No description provided for @ms_one_year_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_one_year_social_emotional;

  /// No description provided for @ms_one_year_waves_bye_bye.
  ///
  /// In en, this message translates to:
  /// **'Waves bye-bye'**
  String get ms_one_year_waves_bye_bye;

  /// No description provided for @ms_one_year_plays_pat_a_cake_with_you.
  ///
  /// In en, this message translates to:
  /// **'Plays pat-a-cake with you'**
  String get ms_one_year_plays_pat_a_cake_with_you;

  /// No description provided for @ms_one_year_language_communication.
  ///
  /// In en, this message translates to:
  /// **'Language & Communication'**
  String get ms_one_year_language_communication;

  /// No description provided for @ms_one_year_says_mama_or_dada.
  ///
  /// In en, this message translates to:
  /// **'Says mama or dada'**
  String get ms_one_year_says_mama_or_dada;

  /// No description provided for @ms_one_year_understands_no.
  ///
  /// In en, this message translates to:
  /// **'Understands “no”'**
  String get ms_one_year_understands_no;

  /// No description provided for @ms_one_year_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_one_year_cognitive_development;

  /// No description provided for @ms_one_year_puts_things_in_a_container.
  ///
  /// In en, this message translates to:
  /// **'Puts things in a container'**
  String get ms_one_year_puts_things_in_a_container;

  /// No description provided for @ms_one_year_looks_for_hidden_toys.
  ///
  /// In en, this message translates to:
  /// **'Looks for hidden toys'**
  String get ms_one_year_looks_for_hidden_toys;

  /// No description provided for @ms_one_year_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_one_year_movement_physical_development;

  /// No description provided for @ms_one_year_pulls_up_to_stand.
  ///
  /// In en, this message translates to:
  /// **'Pulls up to stand'**
  String get ms_one_year_pulls_up_to_stand;

  /// No description provided for @ms_one_year_walks_holding_furniture.
  ///
  /// In en, this message translates to:
  /// **'Walks holding furniture'**
  String get ms_one_year_walks_holding_furniture;

  /// No description provided for @ms_one_year_drinks_from_a_cup.
  ///
  /// In en, this message translates to:
  /// **'Drinks from a cup'**
  String get ms_one_year_drinks_from_a_cup;

  /// No description provided for @ms_one_year_uses_thumb_finger_to_pick_things.
  ///
  /// In en, this message translates to:
  /// **'Uses thumb + finger to pick things'**
  String get ms_one_year_uses_thumb_finger_to_pick_things;

  /// No description provided for @ms_one_year_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_one_year_overall_progress;

  /// No description provided for @ms_six_month_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_six_month_developmental_milestones;

  /// No description provided for @ms_six_month_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_six_month_social_emotional;

  /// No description provided for @ms_six_month_knows_familiar_people.
  ///
  /// In en, this message translates to:
  /// **'Knows familiar people'**
  String get ms_six_month_knows_familiar_people;

  /// No description provided for @ms_six_month_likes_to_look_at_herself_in_a_mirror.
  ///
  /// In en, this message translates to:
  /// **'Likes to look at herself in a mirror'**
  String get ms_six_month_likes_to_look_at_herself_in_a_mirror;

  /// No description provided for @ms_six_month_laughs.
  ///
  /// In en, this message translates to:
  /// **'Laughs'**
  String get ms_six_month_laughs;

  /// No description provided for @ms_six_month_speech_language.
  ///
  /// In en, this message translates to:
  /// **'Speech & Language'**
  String get ms_six_month_speech_language;

  /// No description provided for @ms_six_month_takes_turns_making_sounds_with_you.
  ///
  /// In en, this message translates to:
  /// **'Takes turns making sounds with you'**
  String get ms_six_month_takes_turns_making_sounds_with_you;

  /// No description provided for @ms_six_month_blows_raspberries.
  ///
  /// In en, this message translates to:
  /// **'Blows “raspberries”'**
  String get ms_six_month_blows_raspberries;

  /// No description provided for @ms_six_month_makes_squealing_noises.
  ///
  /// In en, this message translates to:
  /// **'Makes squealing noises'**
  String get ms_six_month_makes_squealing_noises;

  /// No description provided for @ms_six_month_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_six_month_cognitive_development;

  /// No description provided for @ms_six_month_puts_things_in_her_mouth_to_explore_them.
  ///
  /// In en, this message translates to:
  /// **'Puts things in her mouth to explore them'**
  String get ms_six_month_puts_things_in_her_mouth_to_explore_them;

  /// No description provided for @ms_six_month_reaches_to_grab_a_toy_she_wants.
  ///
  /// In en, this message translates to:
  /// **'Reaches to grab a toy she wants'**
  String get ms_six_month_reaches_to_grab_a_toy_she_wants;

  /// No description provided for @ms_six_month_closes_lips_to_show_she_doesn_t_want_more_food.
  ///
  /// In en, this message translates to:
  /// **'Closes lips to show she doesn’t want more food'**
  String get ms_six_month_closes_lips_to_show_she_doesn_t_want_more_food;

  /// No description provided for @ms_six_month_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_six_month_movement_physical_development;

  /// No description provided for @ms_six_month_rolls_from_tummy_to_back.
  ///
  /// In en, this message translates to:
  /// **'Rolls from tummy to back'**
  String get ms_six_month_rolls_from_tummy_to_back;

  /// No description provided for @ms_six_month_pushes_up_with_straight_arms_when_on_tummy.
  ///
  /// In en, this message translates to:
  /// **'Pushes up with straight arms when on tummy'**
  String get ms_six_month_pushes_up_with_straight_arms_when_on_tummy;

  /// No description provided for @ms_six_month_leans_on_hands_to_support_herself_when_sitting.
  ///
  /// In en, this message translates to:
  /// **'Leans on hands to support herself when sitting'**
  String get ms_six_month_leans_on_hands_to_support_herself_when_sitting;

  /// No description provided for @ms_six_month_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_six_month_overall_progress;

  /// No description provided for @ms_two_month_developmental_milestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get ms_two_month_developmental_milestones;

  /// No description provided for @ms_two_month_speech_language.
  ///
  /// In en, this message translates to:
  /// **'Speech & Language'**
  String get ms_two_month_speech_language;

  /// No description provided for @ms_two_month_cognitive_development.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Development'**
  String get ms_two_month_cognitive_development;

  /// No description provided for @ms_two_month_overall_progress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get ms_two_month_overall_progress;

  /// No description provided for @ms_18month_moves_away_from_you_but_looks_to_make_sure_you_are_close_by.
  ///
  /// In en, this message translates to:
  /// **'Moves away from you, but looks to make sure you are close by'**
  String
      get ms_18month_moves_away_from_you_but_looks_to_make_sure_you_are_close_by;

  /// No description provided for @ms_18month_helps_you_dress_by_pushing_arm_through_sleeve_or_lifting_up_.
  ///
  /// In en, this message translates to:
  /// **'Helps you dress by pushing arm through sleeve or lifting up foot'**
  String
      get ms_18month_helps_you_dress_by_pushing_arm_through_sleeve_or_lifting_up_;

  /// No description provided for @ms_18month_tries_to_say_three_or_more_words_besides_mama_or_dada.
  ///
  /// In en, this message translates to:
  /// **'Tries to say three or more words besides \'mama\' or \'dada\''**
  String get ms_18month_tries_to_say_three_or_more_words_besides_mama_or_dada;

  /// No description provided for @ms_18month_follows_one_step_directions_without_gestures_like_give_it_to.
  ///
  /// In en, this message translates to:
  /// **'Follows one-step directions without gestures, like \'Give it to me\''**
  String
      get ms_18month_follows_one_step_directions_without_gestures_like_give_it_to;

  /// No description provided for @ms_18month_copies_you_doing_chores_like_sweeping_with_a_broom.
  ///
  /// In en, this message translates to:
  /// **'Copies you doing chores, like sweeping with a broom'**
  String get ms_18month_copies_you_doing_chores_like_sweeping_with_a_broom;

  /// No description provided for @ms_18month_plays_with_toys_in_a_simple_way_like_pushing_a_toy_car.
  ///
  /// In en, this message translates to:
  /// **'Plays with toys in a simple way, like pushing a toy car'**
  String get ms_18month_plays_with_toys_in_a_simple_way_like_pushing_a_toy_car;

  /// No description provided for @ms_18month_walks_without_holding_on_to_anyone_or_anything.
  ///
  /// In en, this message translates to:
  /// **'Walks without holding on to anyone or anything'**
  String get ms_18month_walks_without_holding_on_to_anyone_or_anything;

  /// No description provided for @ms_18month_drinks_from_a_cup_without_a_lid_and_may_spill_sometimes.
  ///
  /// In en, this message translates to:
  /// **'Drinks from a cup without a lid and may spill sometimes'**
  String get ms_18month_drinks_from_a_cup_without_a_lid_and_may_spill_sometimes;

  /// No description provided for @ms_18month_climbs_on_and_off_a_couch_or_chair_without_help.
  ///
  /// In en, this message translates to:
  /// **'Climbs on and off a couch or chair without help'**
  String get ms_18month_climbs_on_and_off_a_couch_or_chair_without_help;

  /// No description provided for @ms_18month_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_18month_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_18month_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_18month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_24month_notices_when_others_are_hurt_or_upset_like_pausing_or_lookin.
  ///
  /// In en, this message translates to:
  /// **'Notices when others are hurt or upset, like pausing or looking sad when someone is crying'**
  String
      get ms_24month_notices_when_others_are_hurt_or_upset_like_pausing_or_lookin;

  /// No description provided for @ms_24month_looks_at_your_face_to_see_how_to_react_in_a_new_situation.
  ///
  /// In en, this message translates to:
  /// **'Looks at your face to see how to react in a new situation'**
  String
      get ms_24month_looks_at_your_face_to_see_how_to_react_in_a_new_situation;

  /// No description provided for @ms_24month_points_to_things_in_a_book_when_you_ask_like_where_is_the_be.
  ///
  /// In en, this message translates to:
  /// **'Points to things in a book when you ask, like \'Where is the bear?\''**
  String
      get ms_24month_points_to_things_in_a_book_when_you_ask_like_where_is_the_be;

  /// No description provided for @ms_24month_says_at_least_two_words_together_like_more_milk.
  ///
  /// In en, this message translates to:
  /// **'Says at least two words together, like \'More milk.\''**
  String get ms_24month_says_at_least_two_words_together_like_more_milk;

  /// No description provided for @ms_24month_points_to_at_least_two_body_parts_when_you_ask_him_to_show_y.
  ///
  /// In en, this message translates to:
  /// **'Points to at least two body parts when you ask him to show you'**
  String
      get ms_24month_points_to_at_least_two_body_parts_when_you_ask_him_to_show_y;

  /// No description provided for @ms_24month_uses_more_gestures_than_just_waving_and_pointing_like_blowin.
  ///
  /// In en, this message translates to:
  /// **'Uses more gestures than just waving and pointing, like blowing a kiss or nodding yes'**
  String
      get ms_24month_uses_more_gestures_than_just_waving_and_pointing_like_blowin;

  /// No description provided for @ms_24month_holds_something_in_one_hand_while_using_the_other_hand_like_.
  ///
  /// In en, this message translates to:
  /// **'Holds something in one hand while using the other hand, like holding a container and taking the lid off'**
  String
      get ms_24month_holds_something_in_one_hand_while_using_the_other_hand_like_;

  /// No description provided for @ms_24month_tries_to_use_switches_knobs_or_buttons_on_a_toy.
  ///
  /// In en, this message translates to:
  /// **'Tries to use switches, knobs, or buttons on a toy'**
  String get ms_24month_tries_to_use_switches_knobs_or_buttons_on_a_toy;

  /// No description provided for @ms_24month_plays_with_more_than_one_toy_at_the_same_time_like_putting_t.
  ///
  /// In en, this message translates to:
  /// **'Plays with more than one toy at the same time, like putting toy food on a toy plate'**
  String
      get ms_24month_plays_with_more_than_one_toy_at_the_same_time_like_putting_t;

  /// No description provided for @ms_24month_walks_not_climbs_up_a_few_stairs_with_or_without_help.
  ///
  /// In en, this message translates to:
  /// **'Walks (not climbs) up a few stairs with or without help'**
  String get ms_24month_walks_not_climbs_up_a_few_stairs_with_or_without_help;

  /// No description provided for @ms_24month_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_24month_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_24month_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_24month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_30month_plays_next_to_other_children_and_sometimes_plays_with_them.
  ///
  /// In en, this message translates to:
  /// **'Plays next to other children and sometimes plays with them'**
  String
      get ms_30month_plays_next_to_other_children_and_sometimes_plays_with_them;

  /// No description provided for @ms_30month_shows_you_what_she_can_do_by_saying_look_at_me.
  ///
  /// In en, this message translates to:
  /// **'Shows you what she can do by saying \'Look at me!\''**
  String get ms_30month_shows_you_what_she_can_do_by_saying_look_at_me;

  /// No description provided for @ms_30month_follows_simple_routines_when_told_like_helping_to_pick_up_to.
  ///
  /// In en, this message translates to:
  /// **'Follows simple routines when told, like helping to pick up toys when you say \'It’s clean-up time.\''**
  String
      get ms_30month_follows_simple_routines_when_told_like_helping_to_pick_up_to;

  /// No description provided for @ms_30month_says_two_or_more_words_together_with_one_action_word.
  ///
  /// In en, this message translates to:
  /// **'Says two or more words together, with one action word'**
  String get ms_30month_says_two_or_more_words_together_with_one_action_word;

  /// No description provided for @ms_30month_names_things_in_a_book_when_you_point_and_ask.
  ///
  /// In en, this message translates to:
  /// **'Names things in a book when you point and ask'**
  String get ms_30month_names_things_in_a_book_when_you_point_and_ask;

  /// No description provided for @ms_30month_says_words_like_i_me_or_we.
  ///
  /// In en, this message translates to:
  /// **'Says words like \'I,\' \'me,\' or \'we\''**
  String get ms_30month_says_words_like_i_me_or_we;

  /// No description provided for @ms_30month_uses_things_to_pretend_feeding_a_block_to_a_doll.
  ///
  /// In en, this message translates to:
  /// **'Uses things to pretend (feeding a block to a doll)'**
  String get ms_30month_uses_things_to_pretend_feeding_a_block_to_a_doll;

  /// No description provided for @ms_30month_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_30month_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_30month_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_30month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_3year_calms_down_within_10_minutes_after_you_leave_her.
  ///
  /// In en, this message translates to:
  /// **'Calms down within 10 minutes after you leave her'**
  String get ms_3year_calms_down_within_10_minutes_after_you_leave_her;

  /// No description provided for @ms_3year_notices_other_children_and_joins_them_to_play.
  ///
  /// In en, this message translates to:
  /// **'Notices other children and joins them to play'**
  String get ms_3year_notices_other_children_and_joins_them_to_play;

  /// No description provided for @ms_3year_talks_with_you_in_at_least_two_back_and_forth_exchanges.
  ///
  /// In en, this message translates to:
  /// **'Talks with you in at least two back-and-forth exchanges'**
  String get ms_3year_talks_with_you_in_at_least_two_back_and_forth_exchanges;

  /// No description provided for @ms_3year_asks_who_what_where_or_why_questions.
  ///
  /// In en, this message translates to:
  /// **'Asks “who”, “what”, “where”, or “why” questions'**
  String get ms_3year_asks_who_what_where_or_why_questions;

  /// No description provided for @ms_3year_says_what_action_is_happening_in_a_picture_or_book.
  ///
  /// In en, this message translates to:
  /// **'Says what action is happening in a picture or book'**
  String get ms_3year_says_what_action_is_happening_in_a_picture_or_book;

  /// No description provided for @ms_3year_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_3year_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_3year_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_3year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_4year_pretends_to_be_something_else_during_play_teacher_superhero_.
  ///
  /// In en, this message translates to:
  /// **'Pretends to be something else during play (teacher, superhero, dog)'**
  String
      get ms_4year_pretends_to_be_something_else_during_play_teacher_superhero_;

  /// No description provided for @ms_4year_asks_to_go_play_with_children_if_none_are_around.
  ///
  /// In en, this message translates to:
  /// **'Asks to go play with children if none are around'**
  String get ms_4year_asks_to_go_play_with_children_if_none_are_around;

  /// No description provided for @ms_4year_comforts_others_who_are_hurt_or_sad_like_hugging_a_crying_fr.
  ///
  /// In en, this message translates to:
  /// **'Comforts others who are hurt or sad, like hugging a crying friend'**
  String
      get ms_4year_comforts_others_who_are_hurt_or_sad_like_hugging_a_crying_fr;

  /// No description provided for @ms_4year_avoids_danger_like_not_jumping_from_tall_heights_at_the_play.
  ///
  /// In en, this message translates to:
  /// **'Avoids danger, like not jumping from tall heights at the playground'**
  String
      get ms_4year_avoids_danger_like_not_jumping_from_tall_heights_at_the_play;

  /// No description provided for @ms_4year_changes_behavior_based_on_where_she_is_library_playground_et.
  ///
  /// In en, this message translates to:
  /// **'Changes behavior based on where she is (library, playground, etc.)'**
  String
      get ms_4year_changes_behavior_based_on_where_she_is_library_playground_et;

  /// No description provided for @ms_4year_says_some_words_from_a_song_story_or_nursery_rhyme.
  ///
  /// In en, this message translates to:
  /// **'Says some words from a song, story, or nursery rhyme'**
  String get ms_4year_says_some_words_from_a_song_story_or_nursery_rhyme;

  /// No description provided for @ms_4year_talks_about_at_least_one_thing_that_happened_during_her_day.
  ///
  /// In en, this message translates to:
  /// **'Talks about at least one thing that happened during her day'**
  String
      get ms_4year_talks_about_at_least_one_thing_that_happened_during_her_day;

  /// No description provided for @ms_4year_answers_simple_questions_like_what_is_a_coat_for.
  ///
  /// In en, this message translates to:
  /// **'Answers simple questions like \'What is a coat for?\''**
  String get ms_4year_answers_simple_questions_like_what_is_a_coat_for;

  /// No description provided for @ms_4year_tells_what_comes_next_in_a_well_known_story.
  ///
  /// In en, this message translates to:
  /// **'Tells what comes next in a well-known story'**
  String get ms_4year_tells_what_comes_next_in_a_well_known_story;

  /// No description provided for @ms_4year_holds_crayon_or_pencil_between_fingers_and_thumb_not_a_fist.
  ///
  /// In en, this message translates to:
  /// **'Holds crayon or pencil between fingers and thumb (not a fist)'**
  String
      get ms_4year_holds_crayon_or_pencil_between_fingers_and_thumb_not_a_fist;

  /// No description provided for @ms_4year_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_4year_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_4year_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_4year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_5year_follows_rules_or_takes_turns_when_playing_games_with_other_c.
  ///
  /// In en, this message translates to:
  /// **'Follows rules or takes turns when playing games with other children'**
  String
      get ms_5year_follows_rules_or_takes_turns_when_playing_games_with_other_c;

  /// No description provided for @ms_5year_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_5year_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_5year_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_5year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_fifteen_month_copies_other_children_while_playing_like_taking_toys_out_of_.
  ///
  /// In en, this message translates to:
  /// **'Copies other children while playing, like taking toys out of a container when another child does'**
  String
      get ms_fifteen_month_copies_other_children_while_playing_like_taking_toys_out_of_;

  /// No description provided for @ms_fifteen_month_tries_to_say_one_or_two_words_besides_mama_or_dada.
  ///
  /// In en, this message translates to:
  /// **'Tries to say one or two words besides “mama” or “dada”'**
  String
      get ms_fifteen_month_tries_to_say_one_or_two_words_besides_mama_or_dada;

  /// No description provided for @ms_fifteen_month_follows_directions_with_both_a_gesture_and_words.
  ///
  /// In en, this message translates to:
  /// **'Follows directions with both a gesture and words'**
  String get ms_fifteen_month_follows_directions_with_both_a_gesture_and_words;

  /// No description provided for @ms_fifteen_month_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved '**
  String
      get ms_fifteen_month_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_fifteen_month_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_fifteen_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_four_month_smiles_on_his_own_to_get_your_attention.
  ///
  /// In en, this message translates to:
  /// **'Smiles on his own to get your attention'**
  String get ms_four_month_smiles_on_his_own_to_get_your_attention;

  /// No description provided for @ms_four_month_chuckles_not_a_full_laugh_when_you_try_to_make_her_laugh.
  ///
  /// In en, this message translates to:
  /// **'Chuckles (not a full laugh) when you try to make her laugh'**
  String
      get ms_four_month_chuckles_not_a_full_laugh_when_you_try_to_make_her_laugh;

  /// No description provided for @ms_four_month_looks_at_you_moves_or_makes_sounds_to_get_your_attention.
  ///
  /// In en, this message translates to:
  /// **'Looks at you, moves, or makes sounds to get your attention'**
  String
      get ms_four_month_looks_at_you_moves_or_makes_sounds_to_get_your_attention;

  /// No description provided for @ms_four_month_makes_sounds_like_ooo_aahh_cooing.
  ///
  /// In en, this message translates to:
  /// **'Makes sounds like \'ooo\', \'aahh\' (cooing)'**
  String get ms_four_month_makes_sounds_like_ooo_aahh_cooing;

  /// No description provided for @ms_four_month_makes_sounds_back_when_you_talk_to_her.
  ///
  /// In en, this message translates to:
  /// **'Makes sounds back when you talk to her'**
  String get ms_four_month_makes_sounds_back_when_you_talk_to_her;

  /// No description provided for @ms_four_month_turns_head_towards_sound_of_your_voice.
  ///
  /// In en, this message translates to:
  /// **'Turns head towards sound of your voice'**
  String get ms_four_month_turns_head_towards_sound_of_your_voice;

  /// No description provided for @ms_four_month_if_hungry_opens_mouth_when_she_sees_breast_or_bottle.
  ///
  /// In en, this message translates to:
  /// **'If hungry, opens mouth when she sees breast or bottle'**
  String get ms_four_month_if_hungry_opens_mouth_when_she_sees_breast_or_bottle;

  /// No description provided for @ms_four_month_looks_at_hands_with_interest.
  ///
  /// In en, this message translates to:
  /// **'Looks at hands with interest'**
  String get ms_four_month_looks_at_hands_with_interest;

  /// No description provided for @ms_four_month_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_four_month_movement_physical_development;

  /// No description provided for @ms_four_month_holds_head_steady_without_support.
  ///
  /// In en, this message translates to:
  /// **'Holds head steady without support'**
  String get ms_four_month_holds_head_steady_without_support;

  /// No description provided for @ms_four_month_holds_a_toy_when_you_put_it_in_her_hand.
  ///
  /// In en, this message translates to:
  /// **'Holds a toy when you put it in her hand'**
  String get ms_four_month_holds_a_toy_when_you_put_it_in_her_hand;

  /// No description provided for @ms_four_month_uses_arm_to_swing_at_toys.
  ///
  /// In en, this message translates to:
  /// **'Uses arm to swing at toys'**
  String get ms_four_month_uses_arm_to_swing_at_toys;

  /// No description provided for @ms_four_month_brings_hands_to_mouth.
  ///
  /// In en, this message translates to:
  /// **'Brings hands to mouth'**
  String get ms_four_month_brings_hands_to_mouth;

  /// No description provided for @ms_four_month_pushes_up_onto_elbows_forearms_when_on_tummy.
  ///
  /// In en, this message translates to:
  /// **'Pushes up onto elbows/forearms when on tummy'**
  String get ms_four_month_pushes_up_onto_elbows_forearms_when_on_tummy;

  /// No description provided for @ms_four_month_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_four_month_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_four_month_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_four_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_nine_month_is_shy_clingy_or_fearful_around_strangers.
  ///
  /// In en, this message translates to:
  /// **'Is shy, clingy, or fearful around strangers'**
  String get ms_nine_month_is_shy_clingy_or_fearful_around_strangers;

  /// No description provided for @ms_nine_month_shows_facial_expressions_like_happy_sad_angry_and_surprised.
  ///
  /// In en, this message translates to:
  /// **'Shows facial expressions like happy, sad, angry, and surprised'**
  String
      get ms_nine_month_shows_facial_expressions_like_happy_sad_angry_and_surprised;

  /// No description provided for @ms_nine_month_looks_when_you_call_her_name.
  ///
  /// In en, this message translates to:
  /// **'Looks when you call her name'**
  String get ms_nine_month_looks_when_you_call_her_name;

  /// No description provided for @ms_nine_month_makes_sounds_like_mamama_or_babababa.
  ///
  /// In en, this message translates to:
  /// **'Makes sounds like \'mamama\' or \'babababa\''**
  String get ms_nine_month_makes_sounds_like_mamama_or_babababa;

  /// No description provided for @ms_nine_month_looks_for_objects_when_dropped_out_of_sight.
  ///
  /// In en, this message translates to:
  /// **'Looks for objects when dropped out of sight'**
  String get ms_nine_month_looks_for_objects_when_dropped_out_of_sight;

  /// No description provided for @ms_nine_month_gets_to_a_sitting_position_by_herself.
  ///
  /// In en, this message translates to:
  /// **'Gets to a sitting position by herself'**
  String get ms_nine_month_gets_to_a_sitting_position_by_herself;

  /// No description provided for @ms_nine_month_sits_without_support.
  ///
  /// In en, this message translates to:
  /// **'Sits without support'**
  String get ms_nine_month_sits_without_support;

  /// No description provided for @ms_nine_month_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_nine_month_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_nine_month_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_nine_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_one_year_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_one_year_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_one_year_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_one_year_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_six_month_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_six_month_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_six_month_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_six_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @ms_two_month_social_emotional.
  ///
  /// In en, this message translates to:
  /// **'Social & Emotional'**
  String get ms_two_month_social_emotional;

  /// No description provided for @ms_two_month_calms_down_when_spoken_to_or_picked_up.
  ///
  /// In en, this message translates to:
  /// **'Calms down when spoken to or picked up'**
  String get ms_two_month_calms_down_when_spoken_to_or_picked_up;

  /// No description provided for @ms_two_month_looks_at_your_face.
  ///
  /// In en, this message translates to:
  /// **'Looks at your face'**
  String get ms_two_month_looks_at_your_face;

  /// No description provided for @ms_two_month_seems_happy_to_see_you_when_you_walk_up_to_her.
  ///
  /// In en, this message translates to:
  /// **'Seems happy to see you when you walk up to her'**
  String get ms_two_month_seems_happy_to_see_you_when_you_walk_up_to_her;

  /// No description provided for @ms_two_month_smiles_when_you_talk_to_or_smile_at_her.
  ///
  /// In en, this message translates to:
  /// **'Smiles when you talk to or smile at her'**
  String get ms_two_month_smiles_when_you_talk_to_or_smile_at_her;

  /// No description provided for @ms_two_month_makes_cooing_sounds.
  ///
  /// In en, this message translates to:
  /// **'Makes cooing sounds'**
  String get ms_two_month_makes_cooing_sounds;

  /// No description provided for @ms_two_month_reacts_to_loud_sounds.
  ///
  /// In en, this message translates to:
  /// **'Reacts to loud sounds'**
  String get ms_two_month_reacts_to_loud_sounds;

  /// No description provided for @ms_two_month_watches_you_as_you_move.
  ///
  /// In en, this message translates to:
  /// **'Watches you as you move'**
  String get ms_two_month_watches_you_as_you_move;

  /// No description provided for @ms_two_month_looks_at_a_toy_for_several_seconds.
  ///
  /// In en, this message translates to:
  /// **'Looks at a toy for several seconds'**
  String get ms_two_month_looks_at_a_toy_for_several_seconds;

  /// No description provided for @ms_two_month_movement_physical_development.
  ///
  /// In en, this message translates to:
  /// **'Movement & Physical Development'**
  String get ms_two_month_movement_physical_development;

  /// No description provided for @ms_two_month_holds_head_up_when_on_tummy.
  ///
  /// In en, this message translates to:
  /// **'Holds head up when on tummy'**
  String get ms_two_month_holds_head_up_when_on_tummy;

  /// No description provided for @ms_two_month_moves_both_arms_and_both_legs.
  ///
  /// In en, this message translates to:
  /// **'Moves both arms and both legs'**
  String get ms_two_month_moves_both_arms_and_both_legs;

  /// No description provided for @ms_two_month_opens_hands_briefly.
  ///
  /// In en, this message translates to:
  /// **'Opens hands briefly'**
  String get ms_two_month_opens_hands_briefly;

  /// No description provided for @ms_two_month_only_check_milestones_you_re_confident_your_child_has_achiev.
  ///
  /// In en, this message translates to:
  /// **'Only check milestones you\'re confident your child has achieved'**
  String
      get ms_two_month_only_check_milestones_you_re_confident_your_child_has_achiev;

  /// No description provided for @ms_two_month_completedcount_of_totalmilestones_milestones_complete.
  ///
  /// In en, this message translates to:
  /// **'{completedCount} of {totalMilestones} milestones complete'**
  String ms_two_month_completedcount_of_totalmilestones_milestones_complete(
      Object completedCount, Object totalMilestones);

  /// No description provided for @activityLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity Library'**
  String get activityLibraryTitle;

  /// No description provided for @act_2m_1.
  ///
  /// In en, this message translates to:
  /// **'Make eye contact and smile at your baby'**
  String get act_2m_1;

  /// No description provided for @act_2m_2.
  ///
  /// In en, this message translates to:
  /// **'Talk to your baby during feeding and diaper changes'**
  String get act_2m_2;

  /// No description provided for @act_2m_3.
  ///
  /// In en, this message translates to:
  /// **'Copy your baby’s sounds and wait for a response'**
  String get act_2m_3;

  /// No description provided for @act_2m_4.
  ///
  /// In en, this message translates to:
  /// **'Place a baby-safe mirror for face exploration'**
  String get act_2m_4;

  /// No description provided for @act_2m_5.
  ///
  /// In en, this message translates to:
  /// **'Give short supervised tummy time'**
  String get act_2m_5;

  /// No description provided for @act_2m_6.
  ///
  /// In en, this message translates to:
  /// **'Show high-contrast images or faces'**
  String get act_2m_6;

  /// No description provided for @act_4m_1.
  ///
  /// In en, this message translates to:
  /// **'Move a toy slowly for your baby to follow with their eyes'**
  String get act_4m_1;

  /// No description provided for @act_4m_2.
  ///
  /// In en, this message translates to:
  /// **'Let your baby reach for nearby toys'**
  String get act_4m_2;

  /// No description provided for @act_4m_3.
  ///
  /// In en, this message translates to:
  /// **'Shake a rattle and let your baby track the sound'**
  String get act_4m_3;

  /// No description provided for @act_4m_4.
  ///
  /// In en, this message translates to:
  /// **'Sing songs while gently moving arms and legs'**
  String get act_4m_4;

  /// No description provided for @act_4m_5.
  ///
  /// In en, this message translates to:
  /// **'Play on a floor mat with toys around the baby'**
  String get act_4m_5;

  /// No description provided for @act_4m_6.
  ///
  /// In en, this message translates to:
  /// **'Encourage kicking by placing toys near the feet'**
  String get act_4m_6;

  /// No description provided for @act_6m_1.
  ///
  /// In en, this message translates to:
  /// **'Support your baby in sitting while playing with toys'**
  String get act_6m_1;

  /// No description provided for @act_6m_2.
  ///
  /// In en, this message translates to:
  /// **'Place toys just out of reach to encourage rolling'**
  String get act_6m_2;

  /// No description provided for @act_6m_3.
  ///
  /// In en, this message translates to:
  /// **'Name objects your baby looks at'**
  String get act_6m_3;

  /// No description provided for @act_6m_4.
  ///
  /// In en, this message translates to:
  /// **'Let your baby drop objects and watch them fall'**
  String get act_6m_4;

  /// No description provided for @act_6m_5.
  ///
  /// In en, this message translates to:
  /// **'Explore textures with safe household items'**
  String get act_6m_5;

  /// No description provided for @act_6m_6.
  ///
  /// In en, this message translates to:
  /// **'Play music and let your baby listen and react'**
  String get act_6m_6;

  /// No description provided for @act_9m_1.
  ///
  /// In en, this message translates to:
  /// **'Hide a toy under a cloth and let your baby find it'**
  String get act_9m_1;

  /// No description provided for @act_9m_2.
  ///
  /// In en, this message translates to:
  /// **'Encourage crawling by placing toys farther away'**
  String get act_9m_2;

  /// No description provided for @act_9m_3.
  ///
  /// In en, this message translates to:
  /// **'Practice simple gestures like waving'**
  String get act_9m_3;

  /// No description provided for @act_9m_4.
  ///
  /// In en, this message translates to:
  /// **'Pass toys back and forth in turn-taking play'**
  String get act_9m_4;

  /// No description provided for @act_9m_5.
  ///
  /// In en, this message translates to:
  /// **'Let your baby pull to stand using safe furniture'**
  String get act_9m_5;

  /// No description provided for @act_9m_6.
  ///
  /// In en, this message translates to:
  /// **'Dump toys from a container and refill it together'**
  String get act_9m_6;

  /// No description provided for @act_1y_1.
  ///
  /// In en, this message translates to:
  /// **'Read picture books and name familiar objects'**
  String get act_1y_1;

  /// No description provided for @act_1y_2.
  ///
  /// In en, this message translates to:
  /// **'Encourage walking using push toys'**
  String get act_1y_2;

  /// No description provided for @act_1y_3.
  ///
  /// In en, this message translates to:
  /// **'Let your child bang pots or simple instruments'**
  String get act_1y_3;

  /// No description provided for @act_1y_4.
  ///
  /// In en, this message translates to:
  /// **'Respond with words when your child points'**
  String get act_1y_4;

  /// No description provided for @act_1y_5.
  ///
  /// In en, this message translates to:
  /// **'Play imitation games (clapping, waving)'**
  String get act_1y_5;

  /// No description provided for @act_1y_6.
  ///
  /// In en, this message translates to:
  /// **'Expand on your child’s single words'**
  String get act_1y_6;

  /// No description provided for @act_15m_1.
  ///
  /// In en, this message translates to:
  /// **'Stack blocks and knock them down together'**
  String get act_15m_1;

  /// No description provided for @act_15m_2.
  ///
  /// In en, this message translates to:
  /// **'Play simple pretend with stuffed animals'**
  String get act_15m_2;

  /// No description provided for @act_15m_3.
  ///
  /// In en, this message translates to:
  /// **'Sing songs with actions (hands, feet, head)'**
  String get act_15m_3;

  /// No description provided for @act_15m_4.
  ///
  /// In en, this message translates to:
  /// **'Let your child help put toys away'**
  String get act_15m_4;

  /// No description provided for @act_15m_5.
  ///
  /// In en, this message translates to:
  /// **'Offer crayons for scribbling'**
  String get act_15m_5;

  /// No description provided for @act_15m_6.
  ///
  /// In en, this message translates to:
  /// **'Practice drinking from a cup and using a spoon'**
  String get act_15m_6;

  /// No description provided for @act_18m_1.
  ///
  /// In en, this message translates to:
  /// **'Name body parts during play'**
  String get act_18m_1;

  /// No description provided for @act_18m_2.
  ///
  /// In en, this message translates to:
  /// **'Roll a ball back and forth'**
  String get act_18m_2;

  /// No description provided for @act_18m_3.
  ///
  /// In en, this message translates to:
  /// **'Offer two choices and let your child decide'**
  String get act_18m_3;

  /// No description provided for @act_18m_4.
  ///
  /// In en, this message translates to:
  /// **'Encourage pretend play with dolls or toy food'**
  String get act_18m_4;

  /// No description provided for @act_18m_5.
  ///
  /// In en, this message translates to:
  /// **'Blow bubbles and let your child pop them'**
  String get act_18m_5;

  /// No description provided for @act_18m_6.
  ///
  /// In en, this message translates to:
  /// **'Talk about simple emotions using words'**
  String get act_18m_6;

  /// No description provided for @act_2y_1.
  ///
  /// In en, this message translates to:
  /// **'Do simple puzzles together'**
  String get act_2y_1;

  /// No description provided for @act_2y_2.
  ///
  /// In en, this message translates to:
  /// **'Let your child help with easy chores'**
  String get act_2y_2;

  /// No description provided for @act_2y_3.
  ///
  /// In en, this message translates to:
  /// **'Play with sand or water using cups'**
  String get act_2y_3;

  /// No description provided for @act_2y_4.
  ///
  /// In en, this message translates to:
  /// **'Kick and throw balls outdoors'**
  String get act_2y_4;

  /// No description provided for @act_2y_5.
  ///
  /// In en, this message translates to:
  /// **'Draw with crayons or finger paint'**
  String get act_2y_5;

  /// No description provided for @act_2y_6.
  ///
  /// In en, this message translates to:
  /// **'Build towers with blocks'**
  String get act_2y_6;

  /// No description provided for @act_30m_1.
  ///
  /// In en, this message translates to:
  /// **'Encourage play with other children'**
  String get act_30m_1;

  /// No description provided for @act_30m_2.
  ///
  /// In en, this message translates to:
  /// **'Ask simple questions about pictures or stories'**
  String get act_30m_2;

  /// No description provided for @act_30m_3.
  ///
  /// In en, this message translates to:
  /// **'Sort objects by size or color'**
  String get act_30m_3;

  /// No description provided for @act_30m_4.
  ///
  /// In en, this message translates to:
  /// **'Use chalk or washable paint for drawing'**
  String get act_30m_4;

  /// No description provided for @act_30m_5.
  ///
  /// In en, this message translates to:
  /// **'Pretend play using boxes or household items'**
  String get act_30m_5;

  /// No description provided for @act_30m_6.
  ///
  /// In en, this message translates to:
  /// **'Practice sharing during play'**
  String get act_30m_6;

  /// No description provided for @act_3y_1.
  ///
  /// In en, this message translates to:
  /// **'Play counting games using everyday objects'**
  String get act_3y_1;

  /// No description provided for @act_3y_2.
  ///
  /// In en, this message translates to:
  /// **'Match shapes or pictures'**
  String get act_3y_2;

  /// No description provided for @act_3y_3.
  ///
  /// In en, this message translates to:
  /// **'Play with playdough'**
  String get act_3y_3;

  /// No description provided for @act_3y_4.
  ///
  /// In en, this message translates to:
  /// **'Act out short stories together'**
  String get act_3y_4;

  /// No description provided for @act_3y_5.
  ///
  /// In en, this message translates to:
  /// **'Talk about feelings and calming down'**
  String get act_3y_5;

  /// No description provided for @act_3y_6.
  ///
  /// In en, this message translates to:
  /// **'Help your child say their name and age'**
  String get act_3y_6;

  /// No description provided for @act_4y_1.
  ///
  /// In en, this message translates to:
  /// **'Play board or matching games with simple rules'**
  String get act_4y_1;

  /// No description provided for @act_4y_2.
  ///
  /// In en, this message translates to:
  /// **'Count objects during daily activities'**
  String get act_4y_2;

  /// No description provided for @act_4y_3.
  ///
  /// In en, this message translates to:
  /// **'Role-play new situations (doctor, school)'**
  String get act_4y_3;

  /// No description provided for @act_4y_4.
  ///
  /// In en, this message translates to:
  /// **'Play outdoor group games'**
  String get act_4y_4;

  /// No description provided for @act_4y_5.
  ///
  /// In en, this message translates to:
  /// **'Help with simple chores'**
  String get act_4y_5;

  /// No description provided for @act_4y_6.
  ///
  /// In en, this message translates to:
  /// **'Practice turn-taking during play'**
  String get act_4y_6;

  /// No description provided for @act_5y_1.
  ///
  /// In en, this message translates to:
  /// **'Play memory or attention games'**
  String get act_5y_1;

  /// No description provided for @act_5y_2.
  ///
  /// In en, this message translates to:
  /// **'Do rhyming word games'**
  String get act_5y_2;

  /// No description provided for @act_5y_3.
  ///
  /// In en, this message translates to:
  /// **'Build with complex blocks or construction toys'**
  String get act_5y_3;

  /// No description provided for @act_5y_4.
  ///
  /// In en, this message translates to:
  /// **'Solve simple problems during play'**
  String get act_5y_4;

  /// No description provided for @act_5y_5.
  ///
  /// In en, this message translates to:
  /// **'Encourage independent daily tasks'**
  String get act_5y_5;

  /// No description provided for @act_5y_6.
  ///
  /// In en, this message translates to:
  /// **'Prepare for school routines through play'**
  String get act_5y_6;

  /// No description provided for @childQrPopupInstruction.
  ///
  /// In en, this message translates to:
  /// **'Show this QR code to your healthcare provider'**
  String get childQrPopupInstruction;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @remindersPleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login'**
  String get remindersPleaseLogin;

  /// No description provided for @remindersNoneForDays.
  ///
  /// In en, this message translates to:
  /// **'No reminders for the next {days} days'**
  String remindersNoneForDays(Object days);

  /// No description provided for @remindersDueToday.
  ///
  /// In en, this message translates to:
  /// **'{childName}: {label} is due today.'**
  String remindersDueToday(Object childName, Object label);

  /// No description provided for @remindersDueInOneDay.
  ///
  /// In en, this message translates to:
  /// **'{childName}: {label} is due in 1 day.'**
  String remindersDueInOneDay(Object childName, Object label);

  /// No description provided for @remindersDueInDays.
  ///
  /// In en, this message translates to:
  /// **'{childName}: {label} is due in {days} days.'**
  String remindersDueInDays(Object childName, Object days, Object label);

  /// No description provided for @remindersMonthVaccination.
  ///
  /// In en, this message translates to:
  /// **'{months}-month vaccination'**
  String remindersMonthVaccination(Object months);

  /// No description provided for @remindersVaccineNewborn.
  ///
  /// In en, this message translates to:
  /// **'Newborn vaccination'**
  String get remindersVaccineNewborn;

  /// No description provided for @remindersVaccine2Months.
  ///
  /// In en, this message translates to:
  /// **'2-month vaccination'**
  String get remindersVaccine2Months;

  /// No description provided for @remindersVaccine4Months.
  ///
  /// In en, this message translates to:
  /// **'4-month vaccination'**
  String get remindersVaccine4Months;

  /// No description provided for @remindersVaccine6Months.
  ///
  /// In en, this message translates to:
  /// **'6-month vaccination'**
  String get remindersVaccine6Months;

  /// No description provided for @remindersVaccine9Months.
  ///
  /// In en, this message translates to:
  /// **'9-month vaccination'**
  String get remindersVaccine9Months;

  /// No description provided for @remindersVaccine12Months.
  ///
  /// In en, this message translates to:
  /// **'12-month vaccination'**
  String get remindersVaccine12Months;

  /// No description provided for @remindersVaccine18Months.
  ///
  /// In en, this message translates to:
  /// **'18-month vaccination'**
  String get remindersVaccine18Months;

  /// No description provided for @remindersVaccine24Months.
  ///
  /// In en, this message translates to:
  /// **'24-month vaccination'**
  String get remindersVaccine24Months;

  /// No description provided for @remindersVaccineSchoolAge.
  ///
  /// In en, this message translates to:
  /// **'School-age vaccination'**
  String get remindersVaccineSchoolAge;

  /// No description provided for @remindersMilestone2Months.
  ///
  /// In en, this message translates to:
  /// **'2-month milestone check-up'**
  String get remindersMilestone2Months;

  /// No description provided for @remindersMilestone4Months.
  ///
  /// In en, this message translates to:
  /// **'4-month milestone check-up'**
  String get remindersMilestone4Months;

  /// No description provided for @remindersMilestone6Months.
  ///
  /// In en, this message translates to:
  /// **'6-month milestone check-up'**
  String get remindersMilestone6Months;

  /// No description provided for @remindersMilestone9Months.
  ///
  /// In en, this message translates to:
  /// **'9-month milestone check-up'**
  String get remindersMilestone9Months;

  /// No description provided for @remindersMilestone12Months.
  ///
  /// In en, this message translates to:
  /// **'1-year milestone check-up'**
  String get remindersMilestone12Months;

  /// No description provided for @remindersMilestone15Months.
  ///
  /// In en, this message translates to:
  /// **'15-month milestone check-up'**
  String get remindersMilestone15Months;

  /// No description provided for @remindersMilestone18Months.
  ///
  /// In en, this message translates to:
  /// **'18-month milestone check-up'**
  String get remindersMilestone18Months;

  /// No description provided for @remindersMilestone24Months.
  ///
  /// In en, this message translates to:
  /// **'2-year milestone check-up'**
  String get remindersMilestone24Months;

  /// No description provided for @remindersMilestone30Months.
  ///
  /// In en, this message translates to:
  /// **'30-month milestone check-up'**
  String get remindersMilestone30Months;

  /// No description provided for @remindersMilestone36Months.
  ///
  /// In en, this message translates to:
  /// **'3-year milestone check-up'**
  String get remindersMilestone36Months;

  /// No description provided for @remindersMilestone48Months.
  ///
  /// In en, this message translates to:
  /// **'4-year milestone check-up'**
  String get remindersMilestone48Months;

  /// No description provided for @remindersMilestone60Months.
  ///
  /// In en, this message translates to:
  /// **'5-year milestone check-up'**
  String get remindersMilestone60Months;

  /// No description provided for @childDashboardNoImmediateVaccinations.
  ///
  /// In en, this message translates to:
  /// **'No immediate vaccinations. All set! ✨'**
  String get childDashboardNoImmediateVaccinations;

  /// No description provided for @childDashboardVaccinationTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Timeline'**
  String get childDashboardVaccinationTimelineTitle;

  /// No description provided for @childDashboardNextAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next Appointment: {date}'**
  String childDashboardNextAppointment(Object date);

  /// No description provided for @childDashboardNextAppointmentNone.
  ///
  /// In en, this message translates to:
  /// **'Next Appointment: ---'**
  String get childDashboardNextAppointmentNone;

  /// No description provided for @childDashboardViewFullTimeline.
  ///
  /// In en, this message translates to:
  /// **'View Full Timeline'**
  String get childDashboardViewFullTimeline;

  /// No description provided for @childDashboardCalculatingAge.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get childDashboardCalculatingAge;

  /// No description provided for @childDashboardHealthJourney.
  ///
  /// In en, this message translates to:
  /// **'Health Journey'**
  String get childDashboardHealthJourney;

  /// No description provided for @childDashboardMilestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get childDashboardMilestonesTitle;

  /// No description provided for @childDashboardMilestonesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor growth and learning'**
  String get childDashboardMilestonesSubtitle;

  /// No description provided for @childDashboardAiSkinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload photos for insights'**
  String get childDashboardAiSkinSubtitle;

  /// No description provided for @childDashboardMedicalConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Conditions'**
  String get childDashboardMedicalConditionsTitle;

  /// No description provided for @childDashboardMedicalConditionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Overview of conditions'**
  String get childDashboardMedicalConditionsSubtitle;

  /// No description provided for @childDashboardActivityLibrarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Curated learning content'**
  String get childDashboardActivityLibrarySubtitle;

  /// No description provided for @childDashboardGrowthChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth Chart'**
  String get childDashboardGrowthChartTitle;

  /// No description provided for @childDashboardGrowthChartHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get childDashboardGrowthChartHeight;

  /// No description provided for @childDashboardGrowthChartWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get childDashboardGrowthChartWeight;

  /// No description provided for @childDashboardGrowthChartNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal Growth'**
  String get childDashboardGrowthChartNormal;

  /// No description provided for @childDashboardGrowthChartChild.
  ///
  /// In en, this message translates to:
  /// **'Child Growth'**
  String get childDashboardGrowthChartChild;

  /// No description provided for @ageMonths.
  ///
  /// In en, this message translates to:
  /// **'{months} months'**
  String ageMonths(Object months);

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String ageYears(Object years);

  /// No description provided for @ageYearsMonths.
  ///
  /// In en, this message translates to:
  /// **'{years} years, {months} months'**
  String ageYearsMonths(Object months, Object years);

  /// No description provided for @vaccinationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vaccinationsTitle;

  /// No description provided for @vaccinationsBirthDateMissing.
  ///
  /// In en, this message translates to:
  /// **'Birth date not found for this child.'**
  String get vaccinationsBirthDateMissing;

  /// No description provided for @vaccinationsLateVaccinations.
  ///
  /// In en, this message translates to:
  /// **'Late Vaccinations'**
  String get vaccinationsLateVaccinations;

  /// No description provided for @vaccinationsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get vaccinationsUpcoming;

  /// No description provided for @vaccinationsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get vaccinationsCompleted;

  /// No description provided for @vaccinationsOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get vaccinationsOverdue;

  /// No description provided for @vaccinationsConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Vaccinations'**
  String get vaccinationsConfirmTitle;

  /// No description provided for @vaccinationsNoConfirm.
  ///
  /// In en, this message translates to:
  /// **'No vaccinations available for confirmation.'**
  String get vaccinationsNoConfirm;

  /// No description provided for @vaccinationsConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get vaccinationsConfirmButton;

  /// No description provided for @vaccinationsTakenOn.
  ///
  /// In en, this message translates to:
  /// **'Taken on {date}'**
  String vaccinationsTakenOn(Object date);

  /// No description provided for @vaccinationsAvailableUntil.
  ///
  /// In en, this message translates to:
  /// **'Available until {months} months'**
  String vaccinationsAvailableUntil(Object months);

  /// No description provided for @vaccinationsMustBeTakenBefore.
  ///
  /// In en, this message translates to:
  /// **'Must be taken before {months} months'**
  String vaccinationsMustBeTakenBefore(Object months);

  /// No description provided for @vaccinationsTakenLate.
  ///
  /// In en, this message translates to:
  /// **'Taken late • {date}'**
  String vaccinationsTakenLate(Object date);

  /// No description provided for @vaccinationsOverdueFrom.
  ///
  /// In en, this message translates to:
  /// **'Overdue from {months}m'**
  String vaccinationsOverdueFrom(Object months);

  /// No description provided for @vaccinationsSectionAtBirth.
  ///
  /// In en, this message translates to:
  /// **'At Birth'**
  String get vaccinationsSectionAtBirth;

  /// No description provided for @vaccinationsSection2Months.
  ///
  /// In en, this message translates to:
  /// **'2 Months'**
  String get vaccinationsSection2Months;

  /// No description provided for @vaccinationsSection4Months.
  ///
  /// In en, this message translates to:
  /// **'4 Months'**
  String get vaccinationsSection4Months;

  /// No description provided for @vaccinationsSection6Months.
  ///
  /// In en, this message translates to:
  /// **'6 Months'**
  String get vaccinationsSection6Months;

  /// No description provided for @vaccinationsSection9Months.
  ///
  /// In en, this message translates to:
  /// **'9 Months'**
  String get vaccinationsSection9Months;

  /// No description provided for @vaccinationsSection12Months.
  ///
  /// In en, this message translates to:
  /// **'12 Months'**
  String get vaccinationsSection12Months;

  /// No description provided for @vaccinationsSection18Months.
  ///
  /// In en, this message translates to:
  /// **'18 Months'**
  String get vaccinationsSection18Months;

  /// No description provided for @vaccinationsSection24Months.
  ///
  /// In en, this message translates to:
  /// **'24 Months'**
  String get vaccinationsSection24Months;

  /// No description provided for @vaccinationsSectionSchoolAge.
  ///
  /// In en, this message translates to:
  /// **'School Age'**
  String get vaccinationsSectionSchoolAge;

  /// No description provided for @vaxBCG0.
  ///
  /// In en, this message translates to:
  /// **'BCG (Tuberculosis)'**
  String get vaxBCG0;

  /// No description provided for @vaxHEPBBIRTH.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (Birth Dose)'**
  String get vaxHEPBBIRTH;

  /// No description provided for @vaxHEPB1.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (Dose 1)'**
  String get vaxHEPB1;

  /// No description provided for @vaxHEPB2.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (Dose 2)'**
  String get vaxHEPB2;

  /// No description provided for @vaxHEPB3.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis B (Dose 3)'**
  String get vaxHEPB3;

  /// No description provided for @vaxDTAP1.
  ///
  /// In en, this message translates to:
  /// **'DTaP (Dose 1)'**
  String get vaxDTAP1;

  /// No description provided for @vaxDTAP2.
  ///
  /// In en, this message translates to:
  /// **'DTaP (Dose 2)'**
  String get vaxDTAP2;

  /// No description provided for @vaxDTAP3.
  ///
  /// In en, this message translates to:
  /// **'DTaP (Dose 3)'**
  String get vaxDTAP3;

  /// No description provided for @vaxDTAP4.
  ///
  /// In en, this message translates to:
  /// **'DTaP (Dose 4)'**
  String get vaxDTAP4;

  /// No description provided for @vaxDTAP5.
  ///
  /// In en, this message translates to:
  /// **'DTaP/Td (School Age)'**
  String get vaxDTAP5;

  /// No description provided for @vaxHIB1.
  ///
  /// In en, this message translates to:
  /// **'Hib (Dose 1)'**
  String get vaxHIB1;

  /// No description provided for @vaxHIB2.
  ///
  /// In en, this message translates to:
  /// **'Hib (Dose 2)'**
  String get vaxHIB2;

  /// No description provided for @vaxHIB3.
  ///
  /// In en, this message translates to:
  /// **'Hib (Dose 3)'**
  String get vaxHIB3;

  /// No description provided for @vaxHIBFINAL.
  ///
  /// In en, this message translates to:
  /// **'Hib (Final Dose)'**
  String get vaxHIBFINAL;

  /// No description provided for @vaxPCV1.
  ///
  /// In en, this message translates to:
  /// **'PCV (Dose 1)'**
  String get vaxPCV1;

  /// No description provided for @vaxPCV2.
  ///
  /// In en, this message translates to:
  /// **'PCV (Dose 2)'**
  String get vaxPCV2;

  /// No description provided for @vaxPCV3.
  ///
  /// In en, this message translates to:
  /// **'PCV (Dose 3)'**
  String get vaxPCV3;

  /// No description provided for @vaxPCVFINAL.
  ///
  /// In en, this message translates to:
  /// **'PCV (Final)'**
  String get vaxPCVFINAL;

  /// No description provided for @vaxIPV1.
  ///
  /// In en, this message translates to:
  /// **'IPV (Polio Dose 1)'**
  String get vaxIPV1;

  /// No description provided for @vaxIPV2.
  ///
  /// In en, this message translates to:
  /// **'IPV (Polio Dose 2)'**
  String get vaxIPV2;

  /// No description provided for @vaxIPV3.
  ///
  /// In en, this message translates to:
  /// **'IPV (Polio Dose 3)'**
  String get vaxIPV3;

  /// No description provided for @vaxIPVFINAL.
  ///
  /// In en, this message translates to:
  /// **'IPV (Polio Final)'**
  String get vaxIPVFINAL;

  /// No description provided for @vaxOPV1.
  ///
  /// In en, this message translates to:
  /// **'OPV (Dose 1)'**
  String get vaxOPV1;

  /// No description provided for @vaxOPV2.
  ///
  /// In en, this message translates to:
  /// **'OPV (Dose 2)'**
  String get vaxOPV2;

  /// No description provided for @vaxOPV3.
  ///
  /// In en, this message translates to:
  /// **'OPV (Dose 3)'**
  String get vaxOPV3;

  /// No description provided for @vaxOPV4.
  ///
  /// In en, this message translates to:
  /// **'OPV (Dose 4)'**
  String get vaxOPV4;

  /// No description provided for @vaxROTA1.
  ///
  /// In en, this message translates to:
  /// **'Rotavirus (Dose 1)'**
  String get vaxROTA1;

  /// No description provided for @vaxROTA2.
  ///
  /// In en, this message translates to:
  /// **'Rotavirus (Dose 2)'**
  String get vaxROTA2;

  /// No description provided for @vaxMEASLES1.
  ///
  /// In en, this message translates to:
  /// **'Measles (Dose 1)'**
  String get vaxMEASLES1;

  /// No description provided for @vaxMMR1.
  ///
  /// In en, this message translates to:
  /// **'MMR (Dose 1)'**
  String get vaxMMR1;

  /// No description provided for @vaxMMR2.
  ///
  /// In en, this message translates to:
  /// **'MMR (Dose 2)'**
  String get vaxMMR2;

  /// No description provided for @vaxMMRSCHOOL.
  ///
  /// In en, this message translates to:
  /// **'MMR (School Age)'**
  String get vaxMMRSCHOOL;

  /// No description provided for @vaxVARICELLA1.
  ///
  /// In en, this message translates to:
  /// **'Varicella (Dose 1)'**
  String get vaxVARICELLA1;

  /// No description provided for @vaxVARICELLA2.
  ///
  /// In en, this message translates to:
  /// **'Varicella (Dose 2)'**
  String get vaxVARICELLA2;

  /// No description provided for @vaxVARICELLASCHOOL.
  ///
  /// In en, this message translates to:
  /// **'Varicella (School Age)'**
  String get vaxVARICELLASCHOOL;

  /// No description provided for @vaxMCV41.
  ///
  /// In en, this message translates to:
  /// **'MCV4 (Dose 1)'**
  String get vaxMCV41;

  /// No description provided for @vaxMCV42.
  ///
  /// In en, this message translates to:
  /// **'MCV4 (Dose 2)'**
  String get vaxMCV42;

  /// No description provided for @vaxHEPA1.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis A (Dose 1)'**
  String get vaxHEPA1;

  /// No description provided for @vaxHEPA2.
  ///
  /// In en, this message translates to:
  /// **'Hepatitis A (Dose 2)'**
  String get vaxHEPA2;

  /// No description provided for @doctorVisitEnterValidHeightWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter valid height & weight.'**
  String get doctorVisitEnterValidHeightWeight;

  /// No description provided for @doctorVisitBirthDateNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Birth date not available.'**
  String get doctorVisitBirthDateNotAvailable;

  /// No description provided for @doctorVisitSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved ✅'**
  String get doctorVisitSaved;

  /// No description provided for @doctorVisitSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save measurement.'**
  String get doctorVisitSaveFailed;

  /// No description provided for @doctorVisitChildNotFound.
  ///
  /// In en, this message translates to:
  /// **'Child not found'**
  String get doctorVisitChildNotFound;

  /// No description provided for @doctorVisitChildId.
  ///
  /// In en, this message translates to:
  /// **'Child ID: {id}'**
  String doctorVisitChildId(Object id);

  /// No description provided for @doctorVisitMilestonesNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Milestones data not available yet.'**
  String get doctorVisitMilestonesNotAvailable;

  /// No description provided for @doctorVisitLatestMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Latest Measurements'**
  String get doctorVisitLatestMeasurements;

  /// No description provided for @doctorVisitEnterHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter height'**
  String get doctorVisitEnterHeight;

  /// No description provided for @doctorVisitEnterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter weight'**
  String get doctorVisitEnterWeight;

  /// No description provided for @doctorVisitSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get doctorVisitSaving;

  /// No description provided for @doctorVisitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get doctorVisitConfirm;

  /// No description provided for @doctorVisitPatientDetails.
  ///
  /// In en, this message translates to:
  /// **'Patient Details'**
  String get doctorVisitPatientDetails;

  /// No description provided for @doctorVisitMilestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get doctorVisitMilestonesTitle;

  /// No description provided for @doctorVisitMilestonesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track development progress'**
  String get doctorVisitMilestonesSubtitle;

  /// No description provided for @doctorVisitAiSkinHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Skin Analysis History'**
  String get doctorVisitAiSkinHistoryTitle;

  /// No description provided for @doctorVisitAiSkinHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View previous AI results'**
  String get doctorVisitAiSkinHistorySubtitle;

  /// No description provided for @doctorVisitMedicalConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Conditions'**
  String get doctorVisitMedicalConditionsTitle;

  /// No description provided for @doctorVisitMedicalConditionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan & extract conditions'**
  String get doctorVisitMedicalConditionsSubtitle;

  /// No description provided for @doctorVisitVaccinationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review & confirm'**
  String get doctorVisitVaccinationsSubtitle;

  /// No description provided for @doctorVisitFinishVisit.
  ///
  /// In en, this message translates to:
  /// **'Finish Visit'**
  String get doctorVisitFinishVisit;

  /// No description provided for @milestonesOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Developmental Milestones'**
  String get milestonesOverviewTitle;

  /// No description provided for @doctorMilestonesNoDelayed.
  ///
  /// In en, this message translates to:
  /// **'No delayed milestones'**
  String get doctorMilestonesNoDelayed;

  /// No description provided for @doctorMilestonesExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected {expected}'**
  String doctorMilestonesExpected(Object expected);

  /// No description provided for @doctorMilestonesDelayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get doctorMilestonesDelayed;

  /// No description provided for @childSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Child Summary'**
  String get childSummaryTitle;

  /// No description provided for @childSummaryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Child not found'**
  String get childSummaryNotFound;

  /// No description provided for @childSummaryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Child summary will appear here later.'**
  String get childSummaryPlaceholder;

  /// No description provided for @childSummaryDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get childSummaryDefaultName;

  /// No description provided for @aiSkinHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Skin Analysis History'**
  String get aiSkinHistoryTitle;

  /// No description provided for @aiSkinHistoryParentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Parent not found for this child.'**
  String get aiSkinHistoryParentNotFound;

  /// No description provided for @aiSkinHistoryNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No AI skin analysis history yet.'**
  String get aiSkinHistoryNoHistory;

  /// No description provided for @aiSkinHistoryUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get aiSkinHistoryUnknown;

  /// No description provided for @aiSkinHistoryUnknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get aiSkinHistoryUnknownDate;

  /// No description provided for @medicalReportsInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid file URL.'**
  String get medicalReportsInvalidUrl;

  /// No description provided for @medicalReportsOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the file.'**
  String get medicalReportsOpenFailed;

  /// No description provided for @medicalReportsNoConditions.
  ///
  /// In en, this message translates to:
  /// **'No medical conditions recorded yet.'**
  String get medicalReportsNoConditions;

  /// No description provided for @medicalReportsPreviousReports.
  ///
  /// In en, this message translates to:
  /// **'Previous Reports'**
  String get medicalReportsPreviousReports;

  /// No description provided for @medicalReportsNoReports.
  ///
  /// In en, this message translates to:
  /// **'No reports uploaded yet.'**
  String get medicalReportsNoReports;

  /// No description provided for @medicalReportsReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get medicalReportsReport;

  /// No description provided for @medicalReportsNoExtractedText.
  ///
  /// In en, this message translates to:
  /// **'No extracted text available for this condition yet.'**
  String get medicalReportsNoExtractedText;

  /// No description provided for @doctorOcrDigitizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Digitize Medical Reports'**
  String get doctorOcrDigitizeTitle;

  /// No description provided for @doctorOcrDigitizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF or images and convert them using OCR.'**
  String get doctorOcrDigitizeSubtitle;

  /// No description provided for @doctorOcrUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get doctorOcrUploading;

  /// No description provided for @doctorOcrUploadReport.
  ///
  /// In en, this message translates to:
  /// **'Upload Report'**
  String get doctorOcrUploadReport;

  /// No description provided for @doctorOcrUnsupportedFile.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type.'**
  String get doctorOcrUnsupportedFile;

  /// No description provided for @doctorOcrFailedButSaved.
  ///
  /// In en, this message translates to:
  /// **'OCR failed (upload saved).'**
  String get doctorOcrFailedButSaved;

  /// No description provided for @doctorOcrUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed. Check permissions.'**
  String get doctorOcrUploadFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
