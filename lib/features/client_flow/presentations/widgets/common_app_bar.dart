import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/notification_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/notification_screens/notification_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/connection_status_badge.dart';
import 'package:provider/provider.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogo;
  final bool showBackButton;
  final bool showNotification, showDrawerIcon;
  final String? title;
  final VoidCallback? onBack;
  final VoidCallback? onNotificationTap;

  const CommonAppBar({
    super.key,
    this.showLogo = true,
    this.showBackButton = false,
    this.showNotification = true,
    this.showDrawerIcon = false,
    this.title,
    this.onBack,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.authThemeColor,
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLightColor,
            AppColors.authThemeLightColor,
            AppColors.authThemeColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: showDrawerIcon
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.whiteColor),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              )
            : null,
        title: Row(
          mainAxisAlignment: showLogo
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,

          children: [
            showLogo
                ? Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          appLogo,
                          height: 30,
                          width: 30,
                          fit: BoxFit.contain,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: Platform.isIOS ? 100 : 120),
                    ],
                  )
                : SizedBox(),

            title != null
                ? textWidget(
                    text: title!,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )
                : SizedBox(),
          ],
        ),
        actions: [
          if (context.watch<UserProvider>().isUserInspector)
            ConnectionStatusBadge(),

          if (showNotification)
            Consumer<NotificationProvider>(
              builder: (_, provider, _) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: AppColors.whiteColor,
                      ),
                      onPressed:
                          onNotificationTap ??
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationListScreen(),
                              ),
                            );
                          },
                    ),
                    if (provider.unreadCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            provider.unreadCount > 99
                                ? '99+'
                                : provider.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
