import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/inspector_flow/providers/inspector_main_provider.dart';
import 'package:provider/provider.dart';

class ApprovalStatusScreen extends StatelessWidget {
  final AuthUser user;

  const ApprovalStatusScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InspectorDashboardProvider>();
    final status = user.approvalStatusByAdmin;
    final reason = user.rejectedReason ?? '';

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: CommonAuthBar(
            title: 'Inspector Profile Status',
            subtitle: 'Profile Review Status',

            showBackButton: false,
            image: finalImage,
            rc: rc,
            form: _buildStatusCard(
              rc: rc,
              provider: provider,
              status: 1,
              // status,
              reason: reason,
              context: context,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCard({
    required dynamic rc,
    required InspectorDashboardProvider provider,
    required int? status,
    required String reason,
    required BuildContext context,
  }) {
    IconData icon;
    Color mainColor;
    List<Color> gradientColors;
    String title;
    String message;
    String buttonText;
    VoidCallback onPressed;

    switch (status) {
      case 0:
        icon = Icons.access_time_rounded;
        mainColor = Colors.orangeAccent;
        gradientColors = [Colors.orange.shade400, Colors.deepOrange.shade600];
        title = 'Profile Under Review';
        message =
            'Your profile is currently being reviewed by our team.\nThis may take 48–72 hours.\n\nYou’ll be notified once approved.';
        buttonText = 'Check Again';
        onPressed = () => provider.initializeUserState(context);
        break;

      case 2:
        icon = Icons.cancel_rounded;
        mainColor = Colors.redAccent;
        gradientColors = [Colors.red.shade500, Colors.deepOrange.shade700];
        title = 'Profile Rejected';
        message =
            'Unfortunately, your profile has been rejected.\n\nReason: $reason\n\nPlease update your profile and resubmit for review.';
        buttonText = 'Update Profile';
        onPressed = () async{
           await provider.initializeUserState(context);
        };
        break;

      case 1:
        icon = Icons.verified_rounded;
        mainColor = Colors.greenAccent.shade400;
        gradientColors = [Colors.green.shade500, Colors.teal.shade700];
        title = 'Profile Approved';
        message =
            'Congratulations! Your profile has been approved.\nYou now have full access to your dashboard.';
        buttonText = 'Go to Dashboard';
        onPressed = () async{
           await provider.initializeUserState(context);
        };
        break;

      default:
        icon = Icons.info_outline_rounded;
        mainColor = Colors.blueGrey;
        gradientColors = [Colors.blueGrey.shade400, Colors.blueGrey.shade700];
        title = 'Unknown Status';
        message = 'We’re unable to determine your profile status at this time.';
        buttonText = 'Try Again';
        onPressed = () => provider.initializeUserState(context);
    }

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(icon, size: 48, color: Colors.white),
                ),

                const SizedBox(height: 20),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 2,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 28),

                // Gradient button like subscription card style
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : onPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 36,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




  // Widget _buildStatusCard({
  //   required dynamic rc,
  //   required InspectorDashboardProvider provider,
  //   required int? status,
  //   required String reason,
  //   required BuildContext context,
  // }) {
  //   IconData icon;
  //   Color color;
  //   String title;
  //   String message;
  //   String buttonText;
  //   VoidCallback onPressed;

  //   switch (status) {
  //     case 0:
  //       icon = Icons.access_time;
  //       color = Colors.orange;
  //       title = 'Profile Under Review';
  //       message =
  //           'Your profile is currently being reviewed by our team.\nThis may take 48–72 hours.\n\nYou’ll be notified once approved.';
  //       buttonText = 'Check Again';
  //       onPressed = () => await provider.initializeUserState(context);
  //       break;

  //     case 2:
  //       icon = Icons.cancel;
  //       color = Colors.red;
  //       title = 'Profile Rejected';
  //       message =
  //           'Unfortunately, your profile has been rejected.\n\nReason: $reason\n\nPlease update your profile and resubmit for review.';
  //       buttonText = 'Update Profile';
  //       onPressed = () {
  //         // TODO: navigate to profile update screen
  //       };
  //       break;

  //     case 1:
  //       icon = Icons.check_circle;
  //       color = Colors.green;
  //       title = 'Profile Approved';
  //       message =
  //           'Congratulations! Your profile has been approved.\nYou now have full access to your dashboard.';
  //       buttonText = 'Go to Dashboard';
  //       onPressed = () {
  //         // TODO: navigate to dashboard
  //       };
  //       break;

  //     default:
  //       icon = Icons.info_outline;
  //       color = Colors.blueGrey;
  //       title = 'Unknown Status';
  //       message = 'We’re unable to determine your profile status at this time.';
  //       buttonText = 'Try Again';
  //       onPressed = () => await provider.initializeUserState(context);
  //   }

  //   return Center(
  //     child: Card(
  //       elevation: 6,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       color: Colors.white,
  //       margin: const EdgeInsets.symmetric(horizontal: 8),
  //       child: Padding(
  //         padding: const EdgeInsets.all(24),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(icon, size: 80, color: color),
  //             const SizedBox(height: 16),
  //             Text(
  //               title,
  //               style: const TextStyle(
  //                 fontSize: 22,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 12),
  //             Text(
  //               message,
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(fontSize: 16, height: 1.4),
  //             ),
  //             const SizedBox(height: 24),
  //             ElevatedButton(
  //               onPressed: provider.isLoading ? null : onPressed,
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: color,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 32,
  //                   vertical: 12,
  //                 ),
  //               ),
  //               child: provider.isLoading
  //                   ? const SizedBox(
  //                       width: 22,
  //                       height: 22,
  //                       child: CircularProgressIndicator(
  //                         color: Colors.white,
  //                         strokeWidth: 2,
  //                       ),
  //                     )
  //                   : Text(buttonText),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }