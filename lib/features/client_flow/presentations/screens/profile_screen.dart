import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_assets_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/payment_screens/wallet_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        return Consumer<UserProvider>(
          builder: (context, userProv, _) {
            final user = userProv.user;
            return Scaffold(
              backgroundColor: Colors.grey[200],
              body: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: rc.screenWidth,
                        height: rc.screenHeight * 0.35,
                        child: imageAsset(
                          image: finalImage,
                          width: rc.screenWidth,
                          height: rc.screenHeight * 0.5,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: rc.screenWidth,
                        height: rc.screenHeight * 0.4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        top: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(
                              text: user?.name.toString() ?? '',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            SizedBox(height: 4),
                            textWidget(
                              text: user?.email.toString() ?? '',
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  '${user?.countryCode ?? ''} ${user?.phoneNumber ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  user?.mailingAddress ?? 'N/A',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildOptionTile(
                          context,
                          icon: Icons.settings,
                          label: 'Account Settings',
                          onTap: () =>
                              context.router.push(const AccountSettingsRoute()),
                        ),
                        const SizedBox(height: 12),
                        _buildOptionTile(
                          context,
                          icon: Icons.wallet,
                          label: 'Payments',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => WalletProvider(),
                                child: const WalletScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildOptionTile(
                          context,
                          icon: Icons.lock,
                          label: 'Change Password',
                          onTap: () =>
                              context.router.push(const ChangePasswordRoute()),
                        ),
                        const SizedBox(height: 12),
                        _buildOptionTile(
                          context,
                          icon: Icons.logout,
                          label: 'Logout',
                          color: Colors.redAccent,
                          onTap: () async {
                            logOutUser(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void logOutUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: textWidget(text: 'LOG OUT?'),
        content: textWidget(text: 'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: textWidget(text: 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<UserProvider>().clearUser();
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Logged out')));
                context.router.replaceAll([const OnBoardingRoute()]);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: textWidget(text: 'Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.black87),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }
}