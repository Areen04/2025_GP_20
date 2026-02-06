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
  String get loginFailed => 'Login Failed';

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
  String get loginLink => 'Login';

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
  String get logOut => 'Log out';

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
  String get confirmLogoutTitle => 'Log out';

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
      'Align the QR code within the frame below\\nto begin the identification process.';

  @override
  String get qrInvalid => 'QR code expired or invalid';

  @override
  String get childUpdatedSuccess => 'Child information updated successfully';

  @override
  String errorSavingChild(Object error) {
    return 'Error saving child: $error';
  }
}
