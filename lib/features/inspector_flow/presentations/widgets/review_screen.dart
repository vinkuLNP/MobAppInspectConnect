import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/models/document_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/common_auth_bar.dart';
import 'package:inspect_connect/features/inspector_flow/domain/enum/inspector_documents_enum.dart';
import 'package:inspect_connect/features/inspector_flow/providers/inspector_main_provider.dart';
import 'package:provider/provider.dart';

class ApprovalStatusScreen extends StatelessWidget {
  const ApprovalStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InspectorDashboardProvider>();

    log('🧾 [ApprovalStatusScreen] reviewStatus=${provider.reviewStatus}');

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: CommonAuthBar(
            title: inspectorProfileStatus,
            subtitle: profileReviewStatus,
            showBackButton: false,
            image: finalImage,
            rc: rc,
            form: _buildStatusCard(
              rc: rc,
              provider: provider,
              context: context,
              status: provider.reviewStatus,
              rejectedDocuments: provider.rejectedDocuments,
              reason: provider.rejectedReason,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCard({
    required dynamic rc,
    required InspectorDashboardProvider provider,
    required ReviewStatus status,
    required BuildContext context,
    required List<UserDocument> rejectedDocuments,
    String? reason,
  }) {
    late IconData icon;
    late Color mainColor;
    late List<Color> gradientColors;
    late String title;
    late String message;
    late String buttonText;
    late VoidCallback onPressed;

    switch (status) {
      case ReviewStatus.pending:
        icon = Icons.access_time_rounded;
        mainColor = AppColors.authThemeColor;
        gradientColors = [Colors.orange.shade400, Colors.deepOrange.shade600];
        title = profileUnderReview;
        message = profileUnderReviewMessage;
        buttonText = checkAgainButton;
        onPressed = () => provider.initializeUserState();
        break;

      case ReviewStatus.rejected:
        icon = Icons.cancel_rounded;
        mainColor = Colors.red;
        gradientColors = [Colors.red.shade500, Colors.red.shade700];
        title = profileRequiresUpdates;
        message = '$profileRequiresUpdatesMessage $reason';
        buttonText = updateProfile;
        onPressed = () {};
        break;

      case ReviewStatus.approved:
        icon = Icons.verified_rounded;
        mainColor = AppColors.authThemeColor;
        gradientColors = [Colors.green.shade500, Colors.teal.shade700];
        title = profileApproved;
        message = profileApprovedMessage;
        buttonText = goToDashboard;
        onPressed = () => provider.initializeUserState();
        break;
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
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: mainColor.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(icon, size: 48, color: Colors.white),
                ),

                const SizedBox(height: 20),

                textWidget(
                  text: title,
                  alignment: TextAlign.center,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
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

                textWidget(
                  text: message,
                  alignment: TextAlign.center,
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w400,
                ),

                if (status == ReviewStatus.rejected &&
                    rejectedDocuments.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rejectedDocuments.map((doc) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(
                              text: doc.documentType?.name ?? documentTxt,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            if (doc.adminNotes != null) ...[
                              const SizedBox(height: 6),
                              textWidget(
                                text: '$adminNotes ${doc.adminNotes}',
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : onPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : textWidget(
                            text: buttonText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
