const String importantPolicies = 'Important Policies';
const String showUpFeePolicy = 'Show-Up Fee Policy';
const String cancellationPolicy = 'Cancellation Policy';
const String billingHours = 'Billing Hours';
const String policyAcknowledgmentText =
    'I acknowledge and agree to the Show-Up Fee, Cancellation, and Billing Hours Policy';
const String showUpFeeBullet1 =
    'A show-up fee will be charged if the inspector arrives at the scheduled time but cannot perform the inspection due to client unavailability or unpreparedness.';
const String showUpFeeBullet2 =
    "The show-up fee covers the inspector's time and travel expenses.";
const String showUpFeeBullet3 =
    'This fee will be automatically invoiced to your account.';
const String cancellationBullet1 =
    'Free cancellation: Up to 8 hours before the scheduled inspection time.';
const String cancellationBullet2 =
    'Late cancellation fee: Cancellations made less than 8 hours before the scheduled time will incur a cancellation fee.';
const String cancellationBullet3 =
    'The cancellation fee will be automatically invoiced to your account.';
const String cancellationBullet4 =
    'No refund for no-show or same-day cancellations.';
const String billingBullet1 =
    'All inspections are billed for a minimum of 4 hours.';
const String billingBullet2 =
    'Inspections over 4 hours and less than 8 hours are billed as 8 hours.';

const String declineBookingMsg =
    'Are you sure you want to decline this booking request?';
const String declineBookingBtnText = "Decline Booking";
const String declineTxt = 'Decline';
const String approvedInspectionTxt = "Approved Inspections";
const String timerTxt = 'Timer';
const String pauseTxt = 'Pause';
const String resumeTxt = 'Resume';
const String stopTxt = 'Stop';
const String startTxt = 'Start';
const String cancelTxt = 'Cancel';
const String workDoneTxt = 'Work Done';
const String cancelFeeTxt = '$cancelTxt Fee';
const String applyShowUpFeeTxt = "Apply Show-Up Fee";
const String logOutTxt = 'Log Out?';
const String logOutTitle = 'Log Out';

const String loggedOutTxt = 'Logged Out!';
const String logOutMsgTxt = 'Are you sure you want to Log Out?';
const String slctRaiseAmtTxt = "Select Raise Amount";
const String slctRaiseAmtMsgTxt =
    "This amount will be added to the booking charge and requires client approval.";
const String cnfrmRaiseTxt = "Confirm & Raise";
const String fileMstBeUnder2Txt = 'File must be under 4 MB';
const String cnclShowUpFeeMsgTxt =
    "Do you want to cancel the applied Show-Up Fee?";
const String applyShowUpFeeMsgTxt =
    "Are you sure you want to apply a Show-Up Fee to this booking?";
const String signUpTitle = 'Sign Up';
const String signUpSubtitle = 'Create Your Account!';

const String previousTxt = 'Previous';
const String nextTxt = 'Next';
const String submitTxt = 'Submit';

const String personalDetails = 'Personal Details';
const String professionalDetails = 'Professional Details';
const String serviceArea = 'Service Area';
const String additionalDetails = 'Additional Details';

const String personalDetailsLabel = 'Personal\nDetails';
const String professionalDetailsLabel = 'Professional\nDetails';
const String serviceAreaLabel = 'Service\nArea';
const String additionalDetailsLabel = 'Additional\nDetails';

const String invalidInput = 'Invalid input';

const String agreeToTerms = 'Please agree to all terms before continuing.';
const imageExtensions = [
  'jpg',
  'jpeg',
  'png',
  'heic',
  'webp'
      'gif',
  'bmp',
];
const String signupStart = 'Starting signup process';
const String collectingDeviceInfo = 'Collecting device info';
const String parametersReady = 'Signup parameters ready';
const String signupSuccess = 'Signup successful';
const String signupFailed = 'Signup failed';
const String verifyOtp = '$verifyTxt Your OTP Now';

const String pleaseSelectCertificateType = "Please select a certificate type";

const String uploadAtLeastOneDoc =
    "Please upload at least one certification document";

const String fileSizeLimit = "File must be under 2 MB";

const String imageUploadFailed = "Image upload failed";

const String logLoadedSavedData = 'Loaded saved inspector data';
const String logSignupStart = '[SignUP] START';
const String logSignupCleanup = '[SignUP] CLEANUP';
const String logSignupException = '[SignUP] EXCEPTION';
const String errorTxt = 'Error';

const String errorSignupFailed = 'Signup failed. Please try again.';
const String selectCountryError = "Please select a country";
const String selectStateError = "Please select a state";
const String selectCityError = "Select at least 1 city";

const String mailingAddressRequired = "Please enter mailing address";

const String zipRequired = "Please enter zip code";
const String zipNumericOnly = "Zip must be numeric";

String cityNotFound(String city, String state) =>
    "City $city not found in $state";

const maxFileSizeInBytes = 4 * 1024 * 1024;

const certificateExtensions = ['pdf', 'doc', 'docx'];
const mixedExtensions = ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'];

const uploadTypeId = 'id';
const uploadTypeRef = 'ref';
const String signInTitle = 'Sign In';
const String welcomeBack = 'Welcome Back';

const String emailLabel = 'Email';
const String emailHint = 'example@gmail.com';

const String passwordLabel = 'Password';

const String forgotPassword = 'Forget Password?';

const String signingIn = 'Signing In...';

const String dontHaveAccount = "Don’t have an account? ";
const String createAccountSubtitle = 'Create Your Account!';

const String alreadyHaveAccount = 'Already have an account?';

const String fullNameLabel = 'Full Name';
const String fullNameHint = 'Full Name';

const String phoneNumberLabel = 'Phone Number';
const String phoneNumberHint = 'Phone Number';

const String phoneRequiredError = 'Phone is required';
const String phoneInvalidError = 'Enter a valid phone';
const String forgotPasswordSubtitle =
    'Enter your email \nto receive a reset code';

const String sendVerificationCode = 'Send Verification Code';
const String sendingText = 'Sending...';

const String rememberPasswordText = 'Remember your password? ';

const String profileImageOptional = 'Profile Image(Optional)';
const String profileImage = 'Profile Image';
const String uploadIdLicense = 'ID / License';
const String idLicenseExpiryDate = 'ID / License Expiry Date';
const String uploadCoiDocument = 'COI Document';
const String coiDocumentExpiryDate = 'COI Document Expiry Date';
const String uploadReferenceLetters = 'Reference Letters(Optional)';
const String workHistoryDescription = 'Work History Description';
const String workHistoryHint = 'Enter work experience details...';
const String informationTruthful = 'I confirm all information is truthful.';
const String selectExpiryDate = 'Select Expiry date';
const String documentType = 'Document Type';
const String pleaseSelectDocumentType = 'Please select document type';
const String tapToUploadImage = "Tap to upload image";
const String tapToUploadFile = "Tap to upload file (image or PDF)";
const String httpProtocol = 'http://';
const String httpsProtocol = 'https://';
const String certificateType = 'Certificate Type';
const String selectExpirationDate = 'Select Expiration Date';
const String certificationDocuments = 'ICC Documents (max 4)';
const String select = 'Select';
const String selectCertificateType = '$select $certificateType';

const String uploadDocument = 'Upload Document';
const String maxNumber = 'You can select a maximum of';
const String citiesText = 'Cities';
const String selectCities = '$select $citiesText';
const String addressDetails = 'Address Details';
const String selectYourServiceArea = '$select Your Service Area';

const String countryTxt = 'Country';
const String stateTxt = 'State';
const String expiryTxt = 'Expiry';

const String cityTxt = 'City';

const String defaultCountry = "$select $countryTxt";
const String defaultState = "$select $stateTxt";
const String defaultCity = "$select $cityTxt";
const String addEdit = 'Add / Edit';
const String noCitiesSelected = 'No cities selected';
const String uploadtxt = 'Upload';

const String iccDocumentFor = 'Residency Document for';
const String zipCodeFor = 'Zip Code for';
const String enterTxt = 'Enter your';
const String mailingAddress = 'Mailing Address';
const String searchCities = '$searchTxt Cities';
const String doneTxt = 'Done';
const String searchTxt = 'Search';
const String iccDocumentRequiredFor = 'Residency document required for';
const String expiryDateRequiredForIccIn =
    'Expiry date required for Residency Document for';
const String verifyCode = '$verifyTxt Code';
const String enterTheCodeSent = 'Enter the code sent \nto your email or phone';
const String enterTheOtpSent = 'Enter the OTP sent \nto ';
const String enterTheCodeSentToPhone =
    'Enter the code sent \nto your phone number';
const String didntReceiveOtp = 'Didn’t receive OTP?';
const String resendCode = 'Resend code';
const String resendIn = 'Resend in ';
const String verifyTxt = 'Verify';
const String resetPassword = 'Reset Password';
const String createAccount = 'Create Account';
const String newPasswordLabel = 'New Password';
const String confirmNewPasswordLabel = 'Confirm New Password';

const String enterYourNewPassword = 'Enter your $newPasswordLabel';
const String enterPasswordAndAddressDetailToContinue =
    'Enter password and address detail to continue';
const String addressLabel = 'Address';
const String resetting = 'Resetting...';
const String userNotFoundInLocal = 'User not found in local storage';
const String bookingCreatedSuccessfully = 'Booking created successfully';
const String bookingCreationFailed = 'Booking creation failed';
const String bookingUpdatedSuccessfully = 'Booking Updated successfully.';
const String bookingUpdateFailed = 'Booking update failed';
const String bookingDeletedSuccessfully = 'Booking Deleted successfully.';
const String bookingDeletionFailed = 'Booking Deletion failed';
const String fetchingBookingDetailFailed = 'Fetching Booking Detail failed';
const String failedTxt = 'Failed';
const String showUpFeeStatusFailedToUpdate =
    'Show Up fee Status failed to update.';
const String paymentSuccessfulAndBookingApproved =
    'Payment successful and booking approved.';
const String pleaseSelect = 'Please select';
const String pleaseSelectATime = '$pleaseSelect a time';
const String pleaseSelectAnInspectionType = '$pleaseSelect an inspection type';

const String pleaseSelectALocation = '$pleaseSelect a location';
const String pleaseEnterADescription = 'Please enter a description';
const String pleaseAddAtLeastOneImage = 'Please add at least one image';
const String pleaseAgreeToPolicies =
    'You must agree to the policies before continuing.';
const String passwordUpdatedSuccessfully = 'Password updated successfully.';
const String passwordUpdateFailed = 'Password update failed';
const String requiredTxt = 'Required';
const String minimumSixCharactersRequired = 'Minimum 6 characters required';
const String includeUpperLowerNumberSymbol =
    'Include upper, lower, number & symbol';
const String confirmYourPassword = 'Confirm your password';
const String passwordsDoNotMatch = 'Passwords do not match';
const String sessionExpired = 'Session Expired';
const String sessionExpiredMessage = 'Your session has expired.';
const String pleaseLogInAgain = 'Please log in again.';
const String okTxt = 'OK';
const String recentTransactions = 'Recent Transactions';
const String noTransactionsYet = 'No transactions yet';
const String availableBalance = 'Available Balance';
const String addMoney = 'Add Money';
const String wallet = 'Wallet';
const String somethingWentWrong = 'Something went wrong';
const String enterAmountHint = 'Enter amount (e.g. 50)';
const String proceedToPay = 'Proceed to Pay';
const String pleaseEnterValidAmount =
    'Please enter a valid amount - min \$50 AND max -\$100000';
const String profileUpdatedSuccessfully = 'Profile updated successfully!';
const String failedToUpdate = 'Failed to update';
const String accountSettings = 'Account Settings';
const String payments = 'Payments';
const String nameRequired = 'Name required';
const String saving = 'Saving...';
const String saveChanges = 'Save Changes';
const String bookingTxt = 'Booking';
const String confirmBooking = 'Confirm $bookingTxt';

const String viewBooking = 'View $bookingTxt';
const String editBooking = 'Edit $bookingTxt';
const String deleteBooking = '$deleteText $bookingTxt';

const String labelTxt = 'label';
const String valueTxt = 'value';

const String allValueTxt = 'all';
const String inspectionTxt = 'Inspection';

const String allLabelTxt = 'All';
const String awaitingYourApprovalLabelTxt = 'Awaiting Your Approval';
const String waitingForClientApprovalLabelTxt = 'Waiting for Client Approval';
const String acceptedLabelTxt = 'Accepted';
const String pendingLabelTxt = 'Pending';
const String rejectedLabelTxt = 'Rejected';
const String inspectionStartedLabelTxt = 'Inspection Started';
const String completedLabelTxt = 'Completed';
const String expiredLabelTxt = 'Expired';
const String pausedLabelTxt = 'Paused';
const String stoppedLabelTxt = 'Stopped';
const String cancelledByClientLabelTxt = 'Cancelled By Client';

const String cancelledByInspectorLabelTxt = 'Cancelled By Inspector';
const String cancelledByYouTxt = 'Cancelled (You)';
const String cancelledByInspTxt = 'Cancelled (Inspector)';
const String noDescriptionProvided = 'No description provided';
const String inspectionCompletedApprovalRequired =
    'Inspection Completed - Approval Required';
const String inspectionDetails = '$inspectionTxt Details';
const String dateTxt = 'Date';
const String timeTxt = 'Time';
const String locationTxt = 'Location';
const String descriptionTxt = 'Description';
const String durationTxt = 'Duration';
const String zeroMinutes = '0 minutes';
const String paymentInformationTxt = 'Payment Information';
const String disagreeTxt = 'Disagree';
const String deleteText = 'Delete';

const String agreeAndPayTxt = 'Agree & Pay';

const String wntDeleteBooking = '$deleteText Booking?';
const String deleteBookingConfirmationTxt =
    'Are you sure you want to delete this booking? This action cannot be undone.';

const String cancellationFeeNotePrefixTxt =
    '⚠ Note: Since the booking time is within the next 8 hours, a cancellation fee of \$';

const String cancellationFeeNoteSuffixTxt = ' will be applied.';

const String filterSortTitleTxt = 'Filter & Sort Options';

const String sortByDateAscTxt = 'Sort by Date (Ascending)';
const String sortByDateDescTxt = 'Sort by Date (Descending)';
const String clearAllFiltersTxt = 'Clear All Filters';

const String changePassword = 'Change Password';
const String oldPassword = 'Old Password';
const String confirmPassword = 'Confirm Password';
const String updating = 'Updating...';
const String updatePassword = 'Update Password';
const String bookings = 'Bookings';
const String profile = 'Profile';
const String bookInspection = 'Book Inspection';
const String myBookings = 'My Bookings';
const String bookNow = 'Book Now';
const String selectDateTime = 'Select Date & Time';
const String pickTime = 'Pick Time';
const String inspectionType = 'Inspection Type';
const String confirmTxt = 'Confirm';
const String selectInspectionType = '$select $inspectionType';
const String descriptionHint = 'Add details...';
const String uploadImages = 'Upload Images (max 5)';
const String addImage = 'Add Image';

const String retryTxt = 'Retry';
const String paymentSuccessful = 'Payment Successful!';

const String continueTxt = 'Continue';
const String withdrawal = 'Withdrawal';
const String iAgree = 'I AGREE';
const String recentApprovedBooking = 'RECENT APPROVED BOOKING';
const String bookingDate = 'Booking Date';
const String bookingTime = 'Booking Time';
const String deposit = 'Deposit';
const String walletBalanceUpdatedSuccessfully =
    'Your wallet balance has been updated successfully.';

const String stripeAlreadyConnected = 'Stripe Already Connected';
const String stripeTransfersEnabled = 'transfer enabled';

String paymentDeductionInfoTxt(double amount) =>
    'Upon your approval, a payment of \$${amount.toStringAsFixed(2)} '
    'will be automatically deducted from your wallet and transferred '
    'to the inspector.';

String rateCalculationTxt({required double rate, required int blocks}) {
  final total = rate * blocks;
  return 'Rate: \$${rate.toStringAsFixed(2)} per 4-hour block × '
      '$blocks = \$${total.toStringAsFixed(2)}';
}

String cancellationFeeWarningTxt(double fee) =>
    '⚠ Note: Since the booking time is within the next 8 hours, '
    'a cancellation fee of \$${fee.toStringAsFixed(2)} will be applied.';

const String inspectConnectTitle = "Inspect Connect";
const String clientTxt = "Client";
const String loginTxt = "Log in";

const String successToastTxt = "Success";
const String warningToastTxt = "Warning";
const String infoToastTxt = "Info";
const String errorToastTxt = "Error";
const String signInSuccess = 'Sign-in successful';
const String signInFailed = 'Sign-in failed';
const String noInternet = 'No internet connection';
const String loginCompleted = 'Sign-in process completed';

const String emailRequired = 'Email is required';
const String invalidEmail = 'Enter a valid email';
const String passwordRequired = 'Please enter password';
const String invalidPassword = 'Enter valid password';
const String addressHintDefault = 'Enter address';
const String googlePlacesInitFailed =
    'Google Places initialization failed, switching to fallback mode';

const String alreadyHaveAccTxt = "Already have an account? ";
const String inspectorTxt = "Inspector";
const String onBoardingBullet1 =
    "Connecting Quality Inspections\nwith Quality Projects\nfor Every Build that Matters";
const String onBoardingBullet2 =
    "Join a Trusted Network\nof Inspectors Connecting\nyou with Quality Opportunities";
const String onBoardingBullet3 =
    "Welcome to Inspect Connect - \nWhere Projects and Inspectors\nMeet to Build Better Together";

const String defaultCountryCode = 'IN';

const String fieldRequiredError = 'Required';

const String emailRequiredError = 'Email address is required';
const String emailInvalidError = 'Enter a valid email address';

const String passwordRequiredError = 'Password is required';
const String passwordMinLengthError = 'Password must be at least 8 characters';

const String confirmPasswordRequiredError = 'Confirm password is required';
const String passwordMismatchError = 'Passwords do not match';

const String addressRequiredError = 'Address is required';
const String emailRegexExpression =
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

const String passwordRegexExpression =
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';

const String networkError = "Network error occurred";
const String tapToSelectDateTime = "Tap to select date & time";
const String tapToChooseDate = "Tap to choose date";
const String inspectorProfileStatus = 'Inspector Profile Status';

const String inspectorProfileStatusApproved = 'Approved';
const String inspectorProfileStatusPending = 'Pending';
const String inspectorProfileStatusDeclined = 'Declined';
const String profileReviewStatus = 'Profile Review Status';
const String profileUnderReview = 'Profile Under Review';
const String profileUnderReviewMessage =
    "Your profile is currently being reviewed by our team.\n\nThis may take 48–72 hours.\n\nYou’ll be notified once approved.";
const String checkAgainButton = 'Check Again';
const String profileRequiresUpdates = 'Profile Requires Updates';
const String profileRequiresUpdatesMessage =
    'Your profile requires updates before approval.\n\n'
    'Please review the rejected documents and resubmit.\n\n'
    'Rejected Reason:';
const String updateProfile = 'Update Profile';
const String profileApproved = 'Profile Approved';
const String profileApprovedMessage =
    'Congratulations! Your profile has been approved.\n'
    'You now have full access to your dashboard.';
const String goToDashboard = 'Go to Dashboard';
const String documentTxt = 'Document';
const String adminNotes = 'Admin Notes:';
const String connected = 'Connected';
const String disconnected = 'Disconnected';
const String accountDisabled = 'Your account is disabled by admin';
const String tapToGoOffline = 'Tap to go Offline';
const String tapToGoOnline = 'Tap to go Online';
const String goOfflineMsg = 'You will stop receiving new booking requests.';
const String goOnline = 'Go Online';
const String goOffline = 'Go Offline';
const String goOfflineQues = '$goOffline?';

const String goOnlineQues = '$goOnline?';

const String goOnlineMsg = 'You will start receiving booking requests.';
const String connectStripe = 'Connect Stripe';
const String withdraw = 'Withdraw';
const String stripeConnected = 'Stripe Connected';
const String notConnected = 'Stripe Not Connected';
const String stripeAmountReleaseDate =
    'Will be released by Stripe within 7–30 days';
const String available = 'Available';
const String walletBalance = 'Wallet Balance';
const String accountBalance = 'Account Balance';
const String actionNotAvailable = 'Action not available';
const String withdrawMsg =
    "You can't withdraw money if your account is disabled by admin.\n\nPlease contact admin for more details.";
const String youTxt = 'You';
const String typeTxt = 'Type';
const String dateFormatWithTime = 'dd MMM yyyy, hh:mm a';
const String bookingReport = 'Booking Report';
const String viewReport = 'View Report';
const String inspectionInfo = 'Inspection Information';
const String inspectionStatus = 'Inspection Status';
const String bookingSchedule = 'Booking Schedule';
const String clientDetails = 'Client Details';
const String clientName = 'Client Name';
const String phoneTxt = 'Phone';
const String inspectorDetails = 'Inspector Details';

const String financialInfo = 'Financial Information';
const String payoutInfo = 'Payout Information';
const String inspectorName = 'Inspector Name';
const String totalBillingAmount = 'Total Billing Amount';
const String showUpFeeTxt = 'Show Up Fee';
const String platformFeeTxt = 'Platform Fee';
const String showUpFeeAppliedTxt = 'Show-Up Fee Applied';
const String raisedAmountTxt = 'Raised Amount Applied';
const String lateCancellationTxt = 'Late Cancellation';
const String payoutRatePerHour = 'Payout Rate (per hour)';
const String minPayout4hTxt = 'Minimum Payout (4 hours)';
const String maxPayout8hTxt = 'Maximum Payout (8 hours)';
const String totalPayoutTxt = 'Total Payout Amount after deductions';
const String yesTxt = 'Yes';
const String noTxt = 'No';
const String notAvailableTxt = 'N/A';
const String noImagesTxt = 'No Images';

const String clientInformation = 'CLIENT INFORMATION';
const String inspectorInformation = 'INSPECTOR INFORMATION';
const String bookingInformation = 'BOOKING INFORMATION';
const String inspectionImages = 'INSPECTION IMAGES';
const String bookingInspectionReport = 'Booking Inspection Report';
const String generatedOn = 'Generated on';
const String createdAtLabel = 'Created At';
const String updatedAtLabel = 'Last Updated';
const String statusLabel = 'Status';
const String reportFooterText =
    'This report was generated by Inspect Connect System';
const String reportIdLabel = 'Report ID';
