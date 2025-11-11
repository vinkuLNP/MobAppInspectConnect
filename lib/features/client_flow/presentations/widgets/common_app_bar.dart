import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogo;
  final bool showBackButton;
  final bool showNotification, showBookButton, showDrawerIcon;
  final String? title;
  final VoidCallback? onBack;
  final VoidCallback? onNotificationTap;

  const CommonAppBar({
    super.key,
    this.showLogo = true,
    this.showBackButton = false,
    this.showBookButton = false,
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
            Color(0xFF1B90FF), 
            Color(0xFF0070F2), 

            Color(0xFF002A86), 
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
          if (showNotification)
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.whiteColor,
              ),
              onPressed:
                  onNotificationTap ??
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: textWidget(text: 'Notifications tapped')),
                  ),
            ),
          if (showBookButton)
            IconButton(
              icon: const Icon(
                Icons.my_library_books_outlined,
                color: AppColors.whiteColor,
              ),
              onPressed:
                  onNotificationTap ??
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: textWidget(text: 'Notifications tapped')),
                  ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
