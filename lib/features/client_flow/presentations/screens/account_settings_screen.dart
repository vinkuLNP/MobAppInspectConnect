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
      vm.initFromUser(user2.toDomainEntity(), context);
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
          builder: (_, vm, _) {

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Divider(height: 32),

                ServiceAreaStep(vm, _formKey),

                const Divider(height: 32),

                ProfessionalDetailsStep(vm, _formKey),

                const Divider(height: 32),

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
