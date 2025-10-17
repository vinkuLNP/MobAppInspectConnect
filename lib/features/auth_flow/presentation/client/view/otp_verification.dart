import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_logo_bar.dart';
import 'package:clean_architecture/core/utils/presentation/app_common_text_widget.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ClientOtpVerificationView extends StatelessWidget {
  const ClientOtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    
        return Scaffold(body: Column(
          children: [
            // appCommonLogoBar(context: context),
            textWidget(text: "OTP VERIFICATION"),
          ],
        ),);
  
  }
}
