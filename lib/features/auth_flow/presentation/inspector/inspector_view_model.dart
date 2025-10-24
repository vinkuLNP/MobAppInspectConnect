import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/additional_details_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/personal_detail_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/professtional_detail_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/service_area_entity.dart';
import 'package:inspect_connect/features/auth_flow/utils/otp_enum.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InspectorViewModelProvider extends BaseViewModel {
  void init() {}

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool get obscure => _obscure;

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  Future<void> signIn({required GlobalKey<FormState> formKey}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
  }

  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrlSignUp = TextEditingController();
  final addressCtrl = TextEditingController();
  final passwordCtrlSignUp = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool _obscureConfirm = true;
  bool get obscureConfirm => _obscureConfirm;
  void toggleObscureConfirm() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  bool agreeTnC = false;
  bool isTruthful = false;
  void setAgreeTnC(bool? v) {
    agreeTnC = v ?? false;
    notifyListeners();
  }

  void setIsTruthful(bool? v) {
    isTruthful = v ?? false;
    notifyListeners();
  }

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    return v.trim().length < 10 ? 'Enter a valid phone' : null;
  }

  String? validatePassword(String? v) {
    RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$',
    );
    if (v == null || v.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(v)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  String? validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Confirm your password';
    if (v != passwordCtrlSignUp.text) return 'Passwords do not match';
    return null;
  }

  Future<void> submitSignUp({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    // if (!agreeTnC || !isTruthful) {
    //   return;
    // }
    startOtpFlow(OtpPurpose.signUp);

    context.pushRoute(const OtpVerificationRoute());
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrlSignUp.dispose();
    addressCtrl.dispose();
    passwordCtrlSignUp.dispose();
    confirmPasswordCtrl.dispose();
    _timer?.cancel();
    pinController.dispose();
    focusNode.dispose();
    resetEmailCtrl.dispose();
    resetPhoneCtrl.dispose();
    _otpPurpose = null;
    super.dispose();
  }

  final pinController = TextEditingController();
  final focusNode = FocusNode();

  static const int codeLength = 6;
  static const int resendCooldownSec = 30;

  int _secondsLeft = resendCooldownSec;
  int get secondsLeft => _secondsLeft;

  bool get canVerify => pinController.text.trim().length == codeLength;
  bool get canResend => _secondsLeft == 0;

  Timer? _timer;

  bool _lastCanVerify = false;

  void verifyInit() {
    _startCooldown();
    pinController.addListener(() {
      final now = canVerify;
      if (now != _lastCanVerify) {
        _lastCanVerify = now;
        notifyListeners();
      }
    });
  }

  Future<void> verify({required BuildContext context}) async {
    if (!canVerify) return;
    switch (_otpPurpose) {
      case OtpPurpose.signUp:
        context.router.replaceAll([const InspectorSignInRoute()]);
        break;
      case OtpPurpose.forgotPassword:
        context.router.replaceAll([const ResetPasswordRoute()]);
        break;
      default:
        context.router.replaceAll([const InspectorSignInRoute()]);
        break;
    }
  }

  Future<void> resend() async {
    if (!canResend) return;
    _startCooldown();
  }

  void _startCooldown() {
    _secondsLeft = resendCooldownSec;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
      } else {
        _secondsLeft--;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  String? phoneIso;
  String? phoneDial;
  String? phoneRaw;
  String? phoneE164;

  void setPhoneParts({
    required String iso,
    required String dial,
    required String number,
    required String e164,
  }) {
    phoneIso = iso;
    phoneDial = dial;
    phoneRaw = number;
    phoneE164 = e164;
  }

  String? validateIntlPhone() {
    if ((phoneE164 ?? '').isEmpty) return 'Phone is required';
    if ((phoneRaw ?? '').length < 6) return 'Enter a valid phone';
    return null;
  }

  final resetEmailCtrl = TextEditingController();
  final resetPhoneCtrl = TextEditingController();

  bool _isSendingReset = false;
  bool get isSendingReset => _isSendingReset;

  bool _isResetting = false;
  bool get isResetting => _isResetting;

  String? _resetTargetLabel;
  String? get resetTargetLabel => _resetTargetLabel;

  String? validateEmailOrIntlPhone() {
    final email = resetEmailCtrl.text.trim();
    final eOk =
        email.isNotEmpty &&
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    final pOk =
        (phoneE164 != null &&
        phoneE164!.isNotEmpty &&
        (phoneRaw?.length ?? 0) >= 6);
    if (!eOk && !pOk) return 'Enter a valid email or phone';
    return null;
  }

  Future<void> requestPasswordReset({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    _isSendingReset = true;
    notifyListeners();

    try {
      final email = resetEmailCtrl.text.trim();
      final useEmail = email.isNotEmpty;

      _resetTargetLabel = useEmail ? email : phoneE164;

      // verifyInit();
      startOtpFlow(OtpPurpose.forgotPassword);
      context.pushRoute(const OtpVerificationRoute());
    } finally {
      _isSendingReset = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!canVerify) return;

    _isResetting = true;
    notifyListeners();

    try {

      context.router.replaceAll([const ClientSignInRoute()]);
    } finally {
      _isResetting = false;
      notifyListeners();
    }
  }

  OtpPurpose? _otpPurpose;
  OtpPurpose? get otpPurpose => _otpPurpose;

  void startOtpFlow(OtpPurpose purpose) {
    _otpPurpose = purpose;
    verifyInit(); 
    notifyListeners();
  }

  int _currentStep = 0;
  int get currentStep => _currentStep;

  final personal = PersonalDetails();
  final professional = ProfessionalDetails();
  final serviceArea = ServiceAreaDetails();
  final additional = AdditionalDetails();

  void goNext() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void goPrevious() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goTo(int index) {
    _currentStep = index.clamp(0, 3);
    notifyListeners();
  }

  /// Example final submission
  Future<void> submit() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

 void addServiceArea(String area) {
    if (area.trim().isEmpty) return;
    serviceArea.serviceAreas.add(area.trim());
    notifyListeners();
  }

  void removeServiceArea(String area) {
    serviceArea.serviceAreas.remove(area);
    notifyListeners();
  }

  void setCity(String city) {
    serviceArea.city = city.trim();
    notifyListeners();
  }

  // --- Terms toggle ---
  void setTermsAccepted(bool v) {
    additional.termsAccepted = v;
    notifyListeners();
  }

final Map<String, String> certAuthorityByType = {
    'PMP Certification': 'Project Management Institute (PMI)',
    'NEBOSH IGC': 'NEBOSH',
    'ISO 9001 Lead Auditor': 'IRCA / Exemplar Global',
    'Other': 'Self-declared / Local body'
  };

 String? certificationType;
  String? certifyingBody;             // auto-filled
  DateTime? expirationDate;
  List<PlatformFile> certFiles = [];
  
  void setCertificationType(String? v) {
    certificationType = v;
    certifyingBody = v == null ? null : certAuthorityByType[v];
    notifyListeners();
  }

  void setExpirationDate(DateTime? d) {
    expirationDate = d;
    notifyListeners();
  }

  Future<void> pickCertificationFiles() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (res != null && res.files.isNotEmpty) {
      certFiles = res.files;
      notifyListeners();
    }
  }

  int get uploadedCount => certFiles.length;

  // validators you can reuse in the form
  String? validateCertType(String? _) =>
      certificationType == null ? 'Certification type is required' : null;

  String? validateExpiry(String? _) {
    if (expirationDate == null) return 'Select an expiration date';
    final today = DateTime.now();
    if (!expirationDate!.isAfter(DateTime(today.year, today.month, today.day))) {
      return 'Date must be in the future';
    }
    return null;
  }
}




/// --- Data Models --- ///






// /// --- Provider (State) --- ///
// class SignUpProvider extends ChangeNotifier {
//   int _currentStep = 0;
//   int get currentStep => _currentStep;

//   final personal = PersonalDetails();
//   final professional = ProfessionalDetails();
//   final serviceArea = ServiceAreaDetails();
//   final additional = AdditionalDetails();

//   void goNext() {
//     if (_currentStep < 3) {
//       _currentStep++;
//       notifyListeners();
//     }
//   }

//   void goPrevious() {
//     if (_currentStep > 0) {
//       _currentStep--;
//       notifyListeners();
//     }
//   }

//   void goTo(int index) {
//     _currentStep = index.clamp(0, 3);
//     notifyListeners();
//   }

//   Map<String, dynamic> buildPayload() => {
//         'personal': personal.toJson(),
//         'professional': professional.toJson(),
//         'serviceArea': serviceArea.toJson(),
//         'additional': additional.toJson(),
//       };

//   /// Example final submission
//   Future<void> submit() async {
//     // TODO: call your API here with buildPayload()
//     // e.g., await http.post(url, body: jsonEncode(buildPayload()));
//     await Future.delayed(const Duration(milliseconds: 400));
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'signup_provider.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _personalKey = GlobalKey<FormState>();
//   final _professionalKey = GlobalKey<FormState>();
//   final _serviceAreaKey = GlobalKey<FormState>();
//   final _additionalKey = GlobalKey<FormState>();

//   bool _showPwd = false;
//   bool _showConfirmPwd = false;

//   @override
//   Widget build(BuildContext context) {
//     final p = context.watch<SignUpProvider>();
//     final steps = [
//       _StepMeta('Personal Details', _buildPersonal(p), _personalKey),
//       _StepMeta('Professional Details', _buildProfessional(p), _professionalKey),
//       _StepMeta('Service Area', _buildServiceArea(p), _serviceAreaKey),
//       _StepMeta('Additional Details', _buildAdditional(p), _additionalKey),
//     ];

//     final theme = Theme.of(context);
//     final cardRadius = BorderRadius.circular(16);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       body: SafeArea(
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 760),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 12),
//                   Icon(Icons.settings_suggest_rounded,
//                       size: 64, color: theme.colorScheme.onSurface),
//                   const SizedBox(height: 8),
//                   Text('Sign Up',
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       )),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Please fill in the details below to sign up',
//                     style: theme.textTheme.titleMedium
//                         ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   _StepperHeader(
//                     current: p.currentStep,
//                     labels: const [
//                       'Personal\nDetails',
//                       'Professional\nDetails',
//                       'Service\nArea',
//                       'Additional\nDetails'
//                     ],
//                     onTap: (i) {
//                       // Allow going back by tap
//                       if (i <= p.currentStep) p.goTo(i);
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: theme.colorScheme.surface,
//                         borderRadius: cardRadius,
//                         boxShadow: [
//                           BoxShadow(
//                             color:
//                                 theme.colorScheme.onSurface.withOpacity(0.05),
//                             blurRadius: 24,
//                             spreadRadius: 2,
//                             offset: const Offset(0, 12),
//                           ),
//                         ],
//                       ),
//                       child: Card(
//                         margin: EdgeInsets.zero,
//                         color: theme.colorScheme.surface,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: cardRadius,
//                           side: BorderSide(
//                             color:
//                                 theme.colorScheme.outlineVariant.withOpacity(.6),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Form(
//                             key: steps[p.currentStep].formKey,
//                             child: SingleChildScrollView(
//                               child: steps[p.currentStep].content,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: p.currentStep == 0 ? null : p.goPrevious,
//                           style: OutlinedButton.styleFrom(
//                             minimumSize: const Size.fromHeight(52),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: const Text('Previous'),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: FilledButton(
//                           onPressed: () async {
//                             final key = steps[p.currentStep].formKey;
//                             if (key.currentState?.validate() ?? false) {
//                               key.currentState?.save();
//                               if (p.currentStep < steps.length - 1) {
//                                 p.goNext();
//                               } else {
//                                 if (!p.additional.termsAccepted) {
//                                   _toast(context,
//                                       'Please accept Terms & Conditions.');
//                                   return;
//                                 }
//                                 await p.submit();
//                                 if (!mounted) return;
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => AlertDialog(
//                                     title: const Text('Success'),
//                                     content: Text(
//                                       'We captured your details.\n\n${p.buildPayload()}',
//                                       style: theme.textTheme.bodySmall,
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () =>
//                                             Navigator.of(context).pop(),
//                                         child: const Text('OK'),
//                                       )
//                                     ],
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                           style: FilledButton.styleFrom(
//                             minimumSize: const Size.fromHeight(52),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: Text(p.currentStep < 3 ? 'Next' : 'Submit'),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// --- Step 1: Personal --- ///
//   Widget _buildPersonal(SignUpProvider p) {
//     final cc = const ['+1', '+44', '+61', '+91'];
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const _SectionTitle('Personal Details'),
//         const SizedBox(height: 10),
//         _roundedField(
//           initialValue: p.personal.fullName,
//           label: 'Full Name',
//           validator: (v) =>
//               (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
//           onSaved: (v) => p.personal.fullName = v!.trim(),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child: _roundedDropdown<String>(
//                 value: p.personal.countryCode,
//                 label: 'Code',
//                 items: cc.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
//                 onChanged: (v) => setState(() => p.personal.countryCode = v!),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               flex: 7,
//               child: _roundedField(
//                 initialValue: p.personal.phone,
//                 label: 'Phone Number',
//                 keyboardType: TextInputType.phone,
//                 validator: (v) =>
//                     (v == null || v.trim().length < 6) ? 'Invalid phone' : null,
//                 onSaved: (v) => p.personal.phone = v!.trim(),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         _roundedField(
//           initialValue: p.personal.email,
//           label: 'Email',
//           keyboardType: TextInputType.emailAddress,
//           validator: (v) {
//             if (v == null || v.trim().isEmpty) return 'Email is required';
//             final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
//             return ok ? null : 'Enter a valid email';
//           },
//           onSaved: (v) => p.personal.email = v!.trim(),
//         ),
//         const SizedBox(height: 12),
//         _roundedField(
//           initialValue: p.personal.address,
//           label: 'Mailing Address',
//           onSaved: (v) => p.personal.address = v?.trim() ?? '',
//         ),
//         const SizedBox(height: 12),
//         _roundedField(
//           initialValue: p.personal.password,
//           label: 'Password',
//           obscureText: !_showPwd,
//           validator: (v) =>
//               (v == null || v.length < 6) ? 'Min 6 characters' : null,
//           onSaved: (v) => p.personal.password = v!,
//           suffix: IconButton(
//             icon: Icon(_showPwd ? Icons.visibility_off : Icons.visibility),
//             onPressed: () => setState(() => _showPwd = !_showPwd),
//           ),
//         ),
//         const SizedBox(height: 12),
//         _roundedField(
//           initialValue: p.personal.confirmPassword,
//           label: 'Confirm Password',
//           obscureText: !_showConfirmPwd,
//           validator: (v) =>
//               (v != p.personal.password) ? 'Passwords do not match' : null,
//           onSaved: (v) => p.personal.confirmPassword = v!,
//           suffix: IconButton(
//             icon:
//                 Icon(_showConfirmPwd ? Icons.visibility_off : Icons.visibility),
//             onPressed: () => setState(() => _showConfirmPwd = !_showConfirmPwd),
//           ),
//         ),
//       ],
//     );
//   }

//   /// --- Step 2: Professional --- ///
//   Widget _buildProfessional(SignUpProvider p) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const _SectionTitle('Professional Details'),
//         const SizedBox(height: 10),
//         _roundedField(
//           initialValue: p.professional.company,
//           label: 'Company',
//           onSaved: (v) => p.professional.company = v?.trim() ?? '',
//         ),
//         const SizedBox(height: 12),
//         _roundedField(
//           initialValue: p.professional.designation,
//           label: 'Designation',
//           onSaved: (v) => p.professional.designation = v?.trim() ?? '',
//         ),
//         const SizedBox(height: 12),
//         _roundedField(
//           initialValue: p.professional.experienceYears.toString(),
//           label: 'Years of Experience',
//           keyboardType: TextInputType.number,
//           validator: (v) {
//             if (v == null || v.isEmpty) return null;
//             final n = int.tryParse(v);
//             return (n == null || n < 0) ? 'Enter a valid number' : null;
//           },
//           onSaved: (v) =>
//               p.professional.experienceYears = int.tryParse(v ?? '0') ?? 0,
//         ),
//       ],
//     );
//   }

//   /// --- Step 3: Service Area --- ///
//   Widget _buildServiceArea(SignUpProvider p) {
//     final addCtl = TextEditingController();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const _SectionTitle('Service Area'),
//         const SizedBox(height: 10),
//         _roundedField(
//           initialValue: p.serviceArea.city,
//           label: 'Base City',
//           validator: (v) =>
//               (v == null || v.trim().isEmpty) ? 'City is required' : null,
//           onSaved: (v) => p.serviceArea.city = v!.trim(),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _roundedRawField(
//                 controller: addCtl,
//                 label: 'Add Area (e.g., suburb or zip)',
//               ),
//             ),
//             const SizedBox(width: 12),
//             FilledButton(
//               onPressed: () {
//                 final text = addCtl.text.trim();
//                 if (text.isNotEmpty) {
//                   setState(() => p.serviceArea.serviceAreas.add(text));
//                   addCtl.clear();
//                 }
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: p.serviceArea.serviceAreas
//               .map(
//                 (s) => Chip(
//                   label: Text(s),
//                   onDeleted: () =>
//                       setState(() => p.serviceArea.serviceAreas.remove(s)),
//                 ),
//               )
//               .toList(),
//         ),
//       ],
//     );
//   }

//   /// --- Step 4: Additional --- ///
//   Widget _buildAdditional(SignUpProvider p) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const _SectionTitle('Additional Details'),
//         const SizedBox(height: 10),
//         SwitchListTile(
//           contentPadding: EdgeInsets.zero,
//           title: const Text('I accept the Terms & Conditions'),
//           value: p.additional.termsAccepted,
//           onChanged: (v) => setState(() => p.additional.termsAccepted = v),
//         ),
//         const SizedBox(height: 12),
//         _roundedField(
//           initialValue: p.additional.notes,
//           label: 'Notes (optional)',
//           maxLines: 4,
//           onSaved: (v) => p.additional.notes = v?.trim() ?? '',
//         ),
//         const SizedBox(height: 8),
//         if (!p.additional.termsAccepted)
//           const Text(
//             'Please accept the Terms & Conditions to continue.',
//             style: TextStyle(color: Colors.red),
//           ),
//       ],
//     );
//   }

//   // ---------- Styled Inputs ----------
//   Widget _roundedField({
//     required String? initialValue,
//     required String label,
//     String? Function(String?)? validator,
//     void Function(String?)? onSaved,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     int maxLines = 1,
//     Widget? suffix,
//   }) {
//     return TextFormField(
//       initialValue: initialValue,
//       keyboardType: keyboardType,
//       validator: validator,
//       onSaved: onSaved,
//       obscureText: obscureText,
//       maxLines: maxLines,
//       decoration: _roundedDecoration(label).copyWith(suffixIcon: suffix),
//     );
//   }

//   Widget _roundedRawField({
//     required TextEditingController controller,
//     required String label,
//   }) {
//     return TextField(
//       controller: controller,
//       decoration: _roundedDecoration(label),
//     );
//   }

//   InputDecoration _roundedDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       filled: true,
//       isDense: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(
//           color: Theme.of(context).colorScheme.outlineVariant,
//         ),
//       ),
//     );
//   }

//   Widget _roundedDropdown<T>({
//     required T value,
//     required String label,
//     required List<DropdownMenuItem<T>> items,
//     required void Function(T?) onChanged,
//   }) {
//     return DropdownButtonFormField<T>(
//       value: value,
//       items: items,
//       onChanged: onChanged,
//       decoration: _roundedDecoration(label),
//     );
//   }

//   void _toast(BuildContext context, String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }
// }

// // --- Small structs & widgets ---
// class _StepMeta {
//   final String title;
//   final Widget content;
//   final GlobalKey<FormState> formKey;
//   _StepMeta(this.title, this.content, this.formKey);
// }

// class _StepperHeader extends StatelessWidget {
//   final int current;
//   final List<String> labels;
//   final void Function(int index)? onTap;
//   const _StepperHeader({
//     required this.current,
//     required this.labels,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(labels.length, (i) {
//         final active = i == current;
//         final done = i < current;
//         final bg = active
//             ? theme.colorScheme.primary
//             : theme.colorScheme.surfaceVariant;
//         final fg = active
//             ? theme.colorScheme.onPrimary
//             : theme.colorScheme.onSurfaceVariant;

//         return Expanded(
//           child: InkWell(
//             onTap: onTap == null ? null : () => onTap!(i),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundColor: bg,
//                   child: Text(
//                     '${i + 1}',
//                     style: TextStyle(
//                       color: fg,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   labels[i],
//                   textAlign: TextAlign.center,
//                   style: theme.textTheme.labelMedium?.copyWith(
//                     color: (active || done)
//                         ? theme.colorScheme.onSurface
//                         : theme.colorScheme.onSurface.withOpacity(0.6),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String text;
//   const _SectionTitle(this.text);
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: Theme.of(context)
//           .textTheme
//           .titleLarge
//           ?.copyWith(fontWeight: FontWeight.w700),
//     );
//   }
// }
