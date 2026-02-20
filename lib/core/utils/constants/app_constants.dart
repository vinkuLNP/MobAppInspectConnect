import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';

const String commonErrorUnexpectedMessage =
    'Something went wrong please try again';
const int timeoutRequestStatusCode = 1000;

/// app flavors strings
const String devEnvironmentString = 'DEV';
const String qaEnvironmentString = 'QA';
const String sitEnvironmentString = 'SIT';
const String uatEnvironmentString = 'UAT';
const String prodEnvironmentString = 'PROD';

///  IOException request constants
const String commonConnectionFailedMessage =
    'Please check your Internet Connection';
const int ioExceptionStatusCode = 900;

/// http client header constants

const String acceptLanguageKey = 'Accept-Language';
const String authorisationKey = 'Authorization';
const String bearerKey = 'Bearer ';
const String contentTypeKey = 'Content-Type';
const String contentTypeValue = 'application/json';
const String contentMultipartTypeValue = 'multipart/form-data';

///This is the time limit for every api call
const Duration timeOutDuration = Duration(seconds: 60);

///The app base Url should be provided in this value
String webViewUrl =
    "https://inspect-connect-cjdwdhh6b4erb5b8.westus2-01.azurewebsites.net";
String socketUrl =
    "https://inspect-connect-api-auakczg0ave2bqex.westus2-01.azurewebsites.net/";
// Platform.isIOS ? "http://localhost:5002" : "http://10.0.2.2:5002";

String devBaseUrl =
    // Platform.isIOS
    // ?
    // 'http://localhost:5002/api/v1/';
    // : 'http://10.0.2.2:5002/api/v1/';
    // "http://192.168.1.8:5002/api/v1/";
    'https://inspect-connect-api-auakczg0ave2bqex.westus2-01.azurewebsites.net/api/v1/';

const String stripePublishableKey =
    "pk_test_51RuoE4A1eZHeCW31LaeAmCLpWw0Zmyme5RfE3HG8Svoum8yGvBmYhm2gatOR6zWhyn0PmQGcJQqE5GtzvEIuAVKN00W26f1it7";

const String prodBaseUrl =
    'https://inspect-connect-api-auakczg0ave2bqex.westus2-01.azurewebsites.net/api/v1/';
const String qaBaseUrl =
    'https://inspect-connect-api-auakczg0ave2bqex.westus2-01.azurewebsites.net/api/v1/';
const String uatBaseUrl =
    'https://inspect-connect-api-auakczg0ave2bqex.westus2-01.azurewebsites.net/api/v1/';

/// api keys endpoints
const String signInEndPoint = 'signIn';
const String signUpEndPoint = 'signUp';
const String verifyOtpndPoint = 'verifyOtp';
const String resendOtpEndPoint = 'resendOtp';
const String changePasswordEndPoint = 'user/changePassword';
const String updateUser = 'user';

const String getCertificateSubTypesEndPoint = 'certificate/subTypes';
const String getInspectorCertificateTypesEndPoint = 'certificate/types';
const String getInspectorCertificateTAgenciesEndPoint = 'certificate/agencies';
const String getJurisdictionCitiesEndPoint = 'cities/jurisdictions';
const String getInspectorDocumentTypeEndPoint = 'document/types';
const String getSettingsEndPoint = 'settings';
const String createBookingEndPoint = 'bookings';
const String bookingStatusEndPoint = 'status';
const String bookingTimerEndPoint = 'timer';
const String uploadImageEndPoint = 'uploads';
const String walletEndPoint = 'wallet';
const String paymentEndPOint = 'payments';
const String paymentIntentEndPOint = 'payments/paymentIntent';
const String onboardingEndPOint = 'payments/onboard';
const String notificationsEndPoint = 'notifications';
const String deductAndTransferWalletEndPoint =
    '$walletEndPoint/deductAndTransferWallet';
const String withdrawMoneyEndPoint = '$walletEndPoint/withdraw';

const String subscriptionEndPoint = 'subscriptionPlans';
const String userSubscriptionByIdEndPoint = 'subscriptions';

const String appIdValue = '0ae6735afdc6f99d7af23db5d1bd1fbe';
const String cityNameKey = 'q';
const String latitudeKey = 'lat';
const String longitudeKey = 'lon';

/// local database keys
const String weatherInfoTable = 'WeatherInfo';

// booking status
const int bookingStatusPending = 0;
const int bookingStatusAccepted = 1;
const int bookingStatusRejected = 2;
const int bookingStatusCompleted = 3;
const int bookingStatusCancelledByClient = 4;
const int bookingStatusExpired = 5;
const int bookingStatusAwaiting = 6;
const int bookingStatusCancelledByInspector = 7;
const int bookingStatusStarted = 8;
const int bookingStatusPaused = 9;
const int bookingStatusStoppped = 10;

String bookingStatusToText(int status) {
  switch (status) {
    case bookingStatusPending:
      return pendingLabelTxt;

    case bookingStatusAccepted:
      return acceptedLabelTxt;

    case bookingStatusRejected:
      return rejectedLabelTxt;

    case bookingStatusStarted:
      return inspectionStartedLabelTxt;

    case bookingStatusStoppped:
      return stoppedLabelTxt;

    case bookingStatusCompleted:
      return completedLabelTxt;

    case bookingStatusCancelledByClient:
      return cancelledByClientLabelTxt;

    case bookingStatusExpired:
      return expiredLabelTxt;

    case bookingStatusAwaiting:
      return waitingForClientApprovalLabelTxt;

    case bookingStatusCancelledByInspector:
      return cancelledByInspectorLabelTxt;

    case bookingStatusPaused:
      return pausedLabelTxt;

    default:
      return 'Other';
  }
}

Color statusColor(int? status) {
  switch (status) {
    case bookingStatusPending:
      return Colors.amber.shade700;

    case bookingStatusAccepted:
      return Colors.green.shade700;

    case bookingStatusRejected:
      return Colors.red.shade600;

    case bookingStatusStarted:
      return Colors.blue.shade600;

    case bookingStatusStoppped:
      return Colors.deepPurple.shade600;

    case bookingStatusCompleted:
      return Colors.teal.shade700;

    case bookingStatusCancelledByClient:
      return Colors.grey.shade700;

    case bookingStatusCancelledByInspector:
      return Colors.redAccent.shade200;

    case bookingStatusExpired:
      return Colors.grey.shade500;

    case bookingStatusAwaiting:
      return Colors.orange.shade600;

    case bookingStatusPaused:
      return const Color.fromARGB(255, 26, 227, 221);

    default:
      return Colors.grey;
  }
}

IconData statusIcon(int status) {
  switch (status) {
    case bookingStatusPending:
      return Icons.hourglass_empty;

    case bookingStatusAccepted:
      return Icons.check_circle;

    case bookingStatusRejected:
      return Icons.cancel;

    case bookingStatusCompleted:
      return Icons.verified;

    case bookingStatusAwaiting:
      return Icons.hourglass_bottom;

    case bookingStatusCancelledByClient:
      return Icons.person_off;

    case bookingStatusCancelledByInspector:
      return Icons.engineering;

    case bookingStatusExpired:
      return Icons.timer_off;

    case bookingStatusStarted:
      return Icons.play_arrow;

    case bookingStatusPaused:
      return Icons.pause_circle_filled;

    case bookingStatusStoppped:
      return Icons.stop_circle;

    default:
      return Icons.info_outline;
  }
}

List<Map<String, dynamic>> statusOptions = [
  {labelTxt: allLabelTxt, valueTxt: allValueTxt},
  {
    labelTxt: awaitingYourApprovalLabelTxt,
    valueTxt: bookingStatusAwaiting.toString(),
  },
  {labelTxt: acceptedLabelTxt, valueTxt: bookingStatusAccepted.toString()},
  {
    labelTxt: inspectionStartedLabelTxt,
    valueTxt: bookingStatusStarted.toString(),
  },

  {
    labelTxt: '$inspectionTxt $pausedLabelTxt',
    valueTxt: bookingStatusPaused.toString(),
  },
  {
    labelTxt: '$inspectionTxt $stoppedLabelTxt',
    valueTxt: bookingStatusStoppped.toString(),
  },
  {labelTxt: pendingLabelTxt, valueTxt: bookingStatusPending.toString()},
  {labelTxt: rejectedLabelTxt, valueTxt: bookingStatusRejected.toString()},
  {labelTxt: completedLabelTxt, valueTxt: bookingStatusCompleted.toString()},
  {
    labelTxt: cancelledByYouTxt,
    valueTxt: bookingStatusCancelledByClient.toString(),
  },
  {
    labelTxt: cancelledByInspTxt,
    valueTxt: bookingStatusCancelledByInspector.toString(),
  },
  {labelTxt: expiredLabelTxt, valueTxt: bookingStatusExpired.toString()},
];
