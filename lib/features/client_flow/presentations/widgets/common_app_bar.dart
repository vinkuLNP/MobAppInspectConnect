import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogo;
  final bool showBackButton;
  final bool showNotification;
  final String? title;
  final VoidCallback? onBack;
  final VoidCallback? onNotificationTap;

  const CommonAppBar({
    super.key,
    this.showLogo = true,
    this.showBackButton = false,
    this.showNotification = true,
    this.title,
    this.onBack,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        // gradient: LinearGradient(
        //   colors: [

        //     //    Color(0xFFBFD7FF),
        //     // Color(0xFF89AFFF), // sky blue
        //   // light powder blue
        //   ],
        // begin: Alignment.topLeft,
        // end: Alignment.bottomRight,
        // ),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6),
        ],
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),

        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xFF415A77), // Softer blue tone
        //     Color(0xFF1B263B), // Muted navy blue

        //     Color(0xFF0D1B2A), // Deep navy
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black26,
        //     offset: Offset(0, 2),
        //     blurRadius: 6,
        //   ),
        // ],
        // borderRadius: BorderRadius.vertical(
        //   bottom: Radius.circular(20),
        // ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.themeColor),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              )
            : showLogo
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Image.asset(
                  appLogo,
                  height: 36,
                  width: 36,
                  // color: Colors.white, // make sure logo looks clean
                ),
              )
            : null,
        title: title != null
            ? Text(
                title!,
                style: TextStyle(
                  color: AppColors.themeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              )
            : null,
        actions: [
          if (showNotification)
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.themeColor,
              ),
              onPressed:
                  onNotificationTap ??
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications tapped')),
                  ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}
