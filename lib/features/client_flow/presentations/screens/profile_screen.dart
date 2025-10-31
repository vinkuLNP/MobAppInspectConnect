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
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<UserProvider>().user;
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: const CommonAppBar(showLogo: true, title: 'Profile'),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 24),
//             user == null
//                 ? const Center(child: Text("No user data"))
//                 : Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.blue[100],
//                         child: Text(
//                           (user.name?.isNotEmpty ?? false)
//                               ? user.name![0].toUpperCase()
//                               : '?',
//                           style: const TextStyle(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         user.name ?? '',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         user.email ?? '',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         '${user.countryCode ?? ''} ${user.phoneNumber ?? ''}',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//             SizedBox(height: 24),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Account Settings'),
//               onTap: () => context.router.push(const AccountSettingsRoute()),
//             ),
//               ListTile(
//               leading: const Icon(Icons.wallet),
//               title: const Text('Payments'),
//               onTap:()=>  Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => ChangeNotifierProvider(
//         create: (_) => WalletProvider(),
//         child: const WalletScreen(),
//       ),
//     ),
//   ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.lock),
//               title: const Text('Change Password'),
//               onTap: () => context.router.push(const ChangePasswordRoute()),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: () async {
//                 await context.read<UserProvider>().clearUser();
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(const SnackBar(content: Text('Logged out')));
//                   context.router.replaceAll([const OnBoardingRoute()]);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/payment_screens/wallet_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final theme = Theme.of(context);

    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Column(
            children: [
              // Gradient Header
              // Container(
              //   height: 200,
              //   width: double.infinity,
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     borderRadius: BorderRadius.vertical(
              //       bottom: Radius.circular(30),
              //     ),
              //   ),
              //   child: SafeArea(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         CircleAvatar(
              //           radius: 45,
              //           backgroundColor: Colors.white,
              //           child: Text(
              //             (user?.name?.isNotEmpty ?? false)
              //                 ? user!.name![0].toUpperCase()
              //                 : '?',
              //             style: const TextStyle(
              //               fontSize: 32,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.black87,
              //             ),
              //           ),
              //         ),
              //         const SizedBox(height: 12),
              //         Text(
              //           user?.name ?? 'Guest User',
              //           style: const TextStyle(
              //             fontSize: 22,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white,
              //           ),
              //         ),
              //         const SizedBox(height: 4),
              //         Text(
              //           user?.email ?? '',
              //           style: const TextStyle(
              //             fontSize: 14,
              //             color: Colors.white70,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
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
                        SizedBox(height: 4),
                        // textWidget(
                        //   text: subtitle,
                        //   fontSize: 14,
                        //   color: Colors.white70,
                        // ),

                        // const SizedBox(height: 2),
                        textWidget(
                          text: user!.name ?? '',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // const SizedBox(height: 16),

              // Profile Info Card
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
                            const Icon(Icons.location_on, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              // user.locationName ?? 'No Address Provided',
                              'Broadyway',
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

              // Options
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
                        await context.read<UserProvider>().clearUser();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out')),
                          );
                          context.router.replaceAll([const OnBoardingRoute()]);
                        }
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
