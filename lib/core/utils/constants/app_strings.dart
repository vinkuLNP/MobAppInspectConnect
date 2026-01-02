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
const String loggedOutTxt = 'Logged Out!';
const String logOutMsgTxt = 'Are you sure you want to Log Out?';
const String slctRaiseAmtTxt = "Select Raise Amount";
const String slctRaiseAmtMsgTxt =
    "This amount will be added to the booking charge and requires client approval.";
const String cnfrmRaiseTxt = "Confirm & Raise";
const String fileMstBeUnder2Txt = 'File must be under 2 MB';
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

const String signupStart = 'Starting signup process';
const String collectingDeviceInfo = 'Collecting device info';
const String parametersReady = 'Signup parameters ready';
const String signupSuccess = 'Signup successful';
const String signupFailed = 'Signup failed';
const String verifyOtp = 'Verify Your OTP Now';

const String selectCertificateType = "Please select a certificate type";

const String uploadAtLeastOneDoc =
    "Please upload at least one certification document";

const String fileSizeLimit = "File must be under 2 MB";

const String uploadFailed = "Image upload failed";

const String logLoadedSavedData = 'Loaded saved inspector data';
const String logSignupStart = '[SignUP] START';
const String logSignupCleanup = '[SignUP] CLEANUP';
const String logSignupException = '[SignUP] EXCEPTION';
const String logApiError = '[SignUP] API ERROR';

const String errorSignupFailed = 'Signup failed. Please try again.';
const String selectCountryError = "Please select a country";
const String selectStateError = "Please select a state";
const String selectCityError = "Select at least 1 city";

const String mailingAddressRequired = "Please enter mailing address";

const String zipRequired = "Please enter zip code";
const String zipNumericOnly = "Zip must be numeric";

const String defaultCountry = "Select Country";
const String defaultState = "Select State";

String cityNotFound(String city, String state) =>
    "City $city not found in $state";

const maxFileSizeInBytes = 2 * 1024 * 1024;

const certificateExtensions = ['pdf', 'doc', 'docx'];

const mixedExtensions = ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'];

const uploadTypeId = 'id';
const uploadTypeRef = 'ref';
