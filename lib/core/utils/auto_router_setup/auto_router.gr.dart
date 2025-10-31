// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'auto_router.dart';

/// generated route for
/// [AccountSettingsView]
class AccountSettingsRoute extends PageRouteInfo<void> {
  const AccountSettingsRoute({List<PageRouteInfo>? children})
    : super(AccountSettingsRoute.name, initialChildren: children);

  static const String name = 'AccountSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccountSettingsView();
    },
  );
}

/// generated route for
/// [ChangePasswordView]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
    : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangePasswordView();
    },
  );
}

/// generated route for
/// [ClientAuthAutoWrapperView]
class ClientAuthAutoWrapperRoute extends PageRouteInfo<void> {
  const ClientAuthAutoWrapperRoute({List<PageRouteInfo>? children})
    : super(ClientAuthAutoWrapperRoute.name, initialChildren: children);

  static const String name = 'ClientAuthAutoWrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ClientAuthAutoWrapperView());
    },
  );
}

/// generated route for
/// [ClientDashboardView]
class ClientDashboardRoute extends PageRouteInfo<void> {
  const ClientDashboardRoute({List<PageRouteInfo>? children})
    : super(ClientDashboardRoute.name, initialChildren: children);

  static const String name = 'ClientDashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClientDashboardView();
    },
  );
}

/// generated route for
/// [ClientSignInView]
class ClientSignInRoute extends PageRouteInfo<ClientSignInRouteArgs> {
  ClientSignInRoute({
    Key? key,
    required bool showBackButton,
    List<PageRouteInfo>? children,
  }) : super(
         ClientSignInRoute.name,
         args: ClientSignInRouteArgs(key: key, showBackButton: showBackButton),
         initialChildren: children,
       );

  static const String name = 'ClientSignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClientSignInRouteArgs>();
      return ClientSignInView(
        key: args.key,
        showBackButton: args.showBackButton,
      );
    },
  );
}

class ClientSignInRouteArgs {
  const ClientSignInRouteArgs({this.key, required this.showBackButton});

  final Key? key;

  final bool showBackButton;

  @override
  String toString() {
    return 'ClientSignInRouteArgs{key: $key, showBackButton: $showBackButton}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ClientSignInRouteArgs) return false;
    return key == other.key && showBackButton == other.showBackButton;
  }

  @override
  int get hashCode => key.hashCode ^ showBackButton.hashCode;
}

/// generated route for
/// [ClientSignUpView]
class ClientSignUpRoute extends PageRouteInfo<ClientSignUpRouteArgs> {
  ClientSignUpRoute({
    Key? key,
    required bool showBackButton,
    List<PageRouteInfo>? children,
  }) : super(
         ClientSignUpRoute.name,
         args: ClientSignUpRouteArgs(key: key, showBackButton: showBackButton),
         initialChildren: children,
       );

  static const String name = 'ClientSignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClientSignUpRouteArgs>();
      return ClientSignUpView(
        key: args.key,
        showBackButton: args.showBackButton,
      );
    },
  );
}

class ClientSignUpRouteArgs {
  const ClientSignUpRouteArgs({this.key, required this.showBackButton});

  final Key? key;

  final bool showBackButton;

  @override
  String toString() {
    return 'ClientSignUpRouteArgs{key: $key, showBackButton: $showBackButton}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ClientSignUpRouteArgs) return false;
    return key == other.key && showBackButton == other.showBackButton;
  }

  @override
  int get hashCode => key.hashCode ^ showBackButton.hashCode;
}

/// generated route for
/// [ForgotpPasswordView]
class ForgotpPasswordRoute extends PageRouteInfo<ForgotpPasswordRouteArgs> {
  ForgotpPasswordRoute({
    Key? key,
    required bool showBackButton,
    List<PageRouteInfo>? children,
  }) : super(
         ForgotpPasswordRoute.name,
         args: ForgotpPasswordRouteArgs(
           key: key,
           showBackButton: showBackButton,
         ),
         initialChildren: children,
       );

  static const String name = 'ForgotpPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ForgotpPasswordRouteArgs>();
      return ForgotpPasswordView(
        key: args.key,
        showBackButton: args.showBackButton,
      );
    },
  );
}

class ForgotpPasswordRouteArgs {
  const ForgotpPasswordRouteArgs({this.key, required this.showBackButton});

  final Key? key;

  final bool showBackButton;

  @override
  String toString() {
    return 'ForgotpPasswordRouteArgs{key: $key, showBackButton: $showBackButton}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ForgotpPasswordRouteArgs) return false;
    return key == other.key && showBackButton == other.showBackButton;
  }

  @override
  int get hashCode => key.hashCode ^ showBackButton.hashCode;
}

/// generated route for
/// [InspectorAuthAutoWrapperView]
class InspectorAuthAutoWrapperRoute extends PageRouteInfo<void> {
  const InspectorAuthAutoWrapperRoute({List<PageRouteInfo>? children})
    : super(InspectorAuthAutoWrapperRoute.name, initialChildren: children);

  static const String name = 'InspectorAuthAutoWrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const InspectorAuthAutoWrapperView());
    },
  );
}

/// generated route for
/// [InspectorSignInView]
class InspectorSignInRoute extends PageRouteInfo<void> {
  const InspectorSignInRoute({List<PageRouteInfo>? children})
    : super(InspectorSignInRoute.name, initialChildren: children);

  static const String name = 'InspectorSignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InspectorSignInView();
    },
  );
}

/// generated route for
/// [InspectorSignUpView]
class InspectorSignUpRoute extends PageRouteInfo<void> {
  const InspectorSignUpRoute({List<PageRouteInfo>? children})
    : super(InspectorSignUpRoute.name, initialChildren: children);

  static const String name = 'InspectorSignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InspectorSignUpView();
    },
  );
}

/// generated route for
/// [OnBoardingPage]
class OnBoardingRoute extends PageRouteInfo<void> {
  const OnBoardingRoute({List<PageRouteInfo>? children})
    : super(OnBoardingRoute.name, initialChildren: children);

  static const String name = 'OnBoardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnBoardingPage();
    },
  );
}

/// generated route for
/// [OtpVerificationView]
class OtpVerificationRoute extends PageRouteInfo<OtpVerificationRouteArgs> {
  OtpVerificationRoute({
    Key? key,
    required bool addShowButton,
    List<PageRouteInfo>? children,
  }) : super(
         OtpVerificationRoute.name,
         args: OtpVerificationRouteArgs(key: key, addShowButton: addShowButton),
         initialChildren: children,
       );

  static const String name = 'OtpVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpVerificationRouteArgs>();
      return OtpVerificationView(
        key: args.key,
        addShowButton: args.addShowButton,
      );
    },
  );
}

class OtpVerificationRouteArgs {
  const OtpVerificationRouteArgs({this.key, required this.addShowButton});

  final Key? key;

  final bool addShowButton;

  @override
  String toString() {
    return 'OtpVerificationRouteArgs{key: $key, addShowButton: $addShowButton}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OtpVerificationRouteArgs) return false;
    return key == other.key && addShowButton == other.addShowButton;
  }

  @override
  int get hashCode => key.hashCode ^ addShowButton.hashCode;
}

/// generated route for
/// [ResetPasswordView]
class ResetPasswordRoute extends PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    Key? key,
    required bool showBackButton,
    List<PageRouteInfo>? children,
  }) : super(
         ResetPasswordRoute.name,
         args: ResetPasswordRouteArgs(key: key, showBackButton: showBackButton),
         initialChildren: children,
       );

  static const String name = 'ResetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetPasswordRouteArgs>();
      return ResetPasswordView(
        key: args.key,
        showBackButton: args.showBackButton,
      );
    },
  );
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({this.key, required this.showBackButton});

  final Key? key;

  final bool showBackButton;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{key: $key, showBackButton: $showBackButton}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResetPasswordRouteArgs) return false;
    return key == other.key && showBackButton == other.showBackButton;
  }

  @override
  int get hashCode => key.hashCode ^ showBackButton.hashCode;
}

/// generated route for
/// [SplashView]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashView();
    },
  );
}
