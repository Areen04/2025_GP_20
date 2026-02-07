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
  /// **'Review and manage your patients’ health profiles.'**
  String get doctorGreeting;

  /// No description provided for @scanQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Child\'s QR Code'**
  String get scanQrTitle;

  /// No description provided for @scanQrInstruction.
  ///
  /// In en, this message translates to:
  /// **'Align the QR code within the frame below\\nto begin the identification process.'**
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
