/// timeout request constants
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
const Duration timeOutDuration = Duration(seconds: 20);

///The app base Url should be provided in this value
///
///
// const String devBaseUrl = 'http://localhost:5002/api/v1/';
// const String devBaseUrl = 'http://10.0.2.2:5002/api/v1/';
const String devBaseUrl = 'https://inspect-connect-api-auakczg0ave2bqex.westus2-01.azurewebsites.net/api/v1/';

 

const String prodBaseUrl = '';
const String qaBaseUrl = '';
const String uatBaseUrl = '';

/// api keys endpoints
const String signInEndPoint = 'signIn';
const String signUpEndPoint = 'signUp';
const String verifyOtpndPoint = 'verifyOtp';
const String resendOtpEndPoint = 'resendOtp';
const String changePasswordEndPoint = 'user/changePassword';
const String updateUser = 'user';

const String getCertificateSubTypesEndPoint = 'certificate/subTypes';
const String createBookingEndPoint = 'bookings';
const String uploadImageEndPoint = 'uploads';

const String walletEndPoint = 'wallet';
const String paymentEndPOint = 'payments';





const String appIdValue = '0ae6735afdc6f99d7af23db5d1bd1fbe';
const String cityNameKey = 'q';
const String latitudeKey = 'lat';
const String longitudeKey = 'lon';

/// local database keys
const String weatherInfoTable = 'WeatherInfo';
