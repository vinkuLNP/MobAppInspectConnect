import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/additional_detail.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/professional_details.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/view/sign_up_steps/service_area.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

// class _AccountSettingsViewState extends State<AccountSettingsView> {
//   late final TextEditingController nameCtrl;
//   late final TextEditingController emailCtrl;
//   late final TextEditingController phoneCtrl;

//   final _formKey = GlobalKey<FormState>();
//   bool isUpdating = false;

//   @override
//   void initState() {
//     super.initState();

//     final user = context.read<UserProvider>().user;

//     nameCtrl = TextEditingController(text: user?.name ?? '');
//     emailCtrl = TextEditingController(text: user?.email ?? '');
//     phoneCtrl = TextEditingController(
//       text: "${user?.countryCode ?? ''} ${user?.phoneNumber ?? ''}",
//     );
//   }

//   Future<void> _updateProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isUpdating = true);
//     try {
//       await context.read<UserProvider>().updateUserName(
//         context,
//         nameCtrl.text.trim(),
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: textWidget(
//               text: profileUpdatedSuccessfully,
//               color: Colors.white,
//             ),
//           ),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: textWidget(
//               text: '$failedToUpdate: $e',
//               color: Colors.white,
//             ),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => isUpdating = false);
//     }
//   }

//   @override
//   void dispose() {
//     nameCtrl.clear();
//     emailCtrl.clear();
//     phoneCtrl.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<UserProvider>().user;

//     if (user == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: const CommonAppBar(
//         title: accountSettings,
//         showLogo: false,
//         showBackButton: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             const SizedBox(height: 16),
//             AppInputField(
//               label: fullNameLabel,
//               controller: nameCtrl,
//               validator: (value) =>
//                   value == null || value.trim().isEmpty ? nameRequired : null,
//             ),
//             const SizedBox(height: 20),
//             AppInputField(
//               label: emailLabel,
//               controller: emailCtrl,
//               readOnly: true,
//             ),

//             const SizedBox(height: 20),
//             AppInputField(
//               label: phoneNumberLabel,
//               controller: phoneCtrl,
//               readOnly: true,
//             ),

//             const SizedBox(height: 32),

//             AppButton(
//               isLoading: isUpdating,
//               text: isUpdating ? saving : saveChanges,
//               onTap: isUpdating ? null : _updateProfile,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _AccountSettingsViewState extends State<AccountSettingsView> {
  final _formKey = GlobalKey<FormState>();
  late InspectorViewModelProvider vm;

  @override
  void initState() {
    super.initState();

    final user = context.read<UserProvider>().user!;
    vm = context.read<InspectorViewModelProvider>();
    log(
      '---------------> user getting profile image- 1 AuthUserLocalEntity? get user----${user.profileImage.toString()}',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      log(
        '---------------> user getting profile image- 1 toDomainEntity? get user----${user.toDomainEntity().profileImage.toString()}',
      );
      final user2 = await context.read<UserProvider>().refreshUserFromServer(
        context,
      );
      log(
        '---------------> user getting profile image- 1 toDomainEntity? get user----${user2!.toDomainEntity().profileImage.toString()}',
      );
      vm.initFromUser(user2!.toDomainEntity(), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: accountSettings,
        showBackButton: true,
        showLogo: false,
      ),
      body: Form(
        key: _formKey,
        child: Consumer<InspectorViewModelProvider>(
          builder: (_, vm, __) {
            // if (!vm.isEditMode) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// BASIC INFO
                // _basicInfoSection(),
                const Divider(height: 32),

                /// SERVICE AREA
                ServiceAreaStep(vm, _formKey),

                const Divider(height: 32),

                /// PROFESSIONAL DETAILS
                ProfessionalDetailsStep(vm, _formKey),

                const Divider(height: 32),

                /// ADDITIONAL DETAILS
                AdditionalDetailsStep(vm, _formKey),

                const SizedBox(height: 24),

                AppButton(
                  text: saveChanges,
                  onTap: () => (),
                  // onTap: () => _updateAccount(vm),
                ),
                const SizedBox(height: 50),
              ],
            );
          },
        ),
      ),
    );
  }
}
