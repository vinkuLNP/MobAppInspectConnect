import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:flutter/material.dart';

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: -4, end: 4),
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          onEnd: () {},
          builder: (context, value, child) {
            return Transform.translate(offset: Offset(0, value), child: child);
          },
          child: Image.asset(image, height: 246, fit: BoxFit.fitWidth),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37),
          child: Column(
            children: [
              textWidget(
                text: title,
                color: AppColors.themeColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                alignment: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: SizedBox(
                  child: textWidget(
                    text: subTitle,
                    alignment: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}





// Perfect, this fits exactly the pattern you’re already using with BaseViewModel.
// I’ll convert your Onboarding flow into a clean, scalable, low-overhead architecture without breaking animations or UX.

// I will NOT over-engineer.
// No domain/usecase layers.
// Everything stays ViewModel + UI, aligned with your Splash refactor.

// ✅ TARGET CLEAN ARCHITECTURE (Feature-based)
// features/
//  └─ onboarding/
//     ├─ presentation/
//     │  ├─ pages/
//     │  │  └─ onboarding_page.dart
//     │  ├─ widgets/
//     │  │  └─ onboarding_widget.dart
//     │  └─ view_model/
//     │     └─ onboarding_view_model.dart

// 1️⃣ OnBoardingWidget (Already Clean ✅)

// Your OnBoardingWidget is pure UI → ✅ NO changes needed

// ✔ Stateless
// ✔ No logic
// ✔ Reusable
// ✔ Animation-safe

// We keep it as-is.

// 2️⃣ OnBoarding ViewModel (Extends BaseViewModel)
// onboarding_view_model.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
// import 'package:inspect_connect/features/auth_flow/enum/auth_user_enum.dart';
// import 'package:inspect_connect/features/auth_flow/presentation/auth_user_provider.dart';



// 🔑 Why this ViewModel is Correct

// ✔ Extends BaseViewModel
// ✔ Uses notifyListeners() only when needed
// ✔ No animation logic
// ✔ No widget references
// ✔ No system load
// ✔ Testable

// 3️⃣ Register ViewModel (Factory)



// ✔ Route-scoped
// ✔ Auto-disposed

// 4️⃣ Clean OnBoardingPage (UI Only)
// onboarding_page.dart


// 5️⃣ UI Widget (No Business Logic)
// _OnBoardingUI


// 6️⃣ Result: What You Achieved 🎯
// Aspect	Result
// Clean Architecture	✅
// Performance	🚀 Minimal
// BaseViewModel reuse	✅
// Navigation safety	✅
// Scalability	🔥
// Readability	💯
// 🧠 Senior Dev Insight

// You’re following Flutter-practical Clean Architecture, not academic Clean Architecture.

// ✔ Providers = ViewModels
// ✔ BaseViewModel = lifecycle + async wrapper
// ✔ UI = animation only
// ✔ Feature-scoped state

// This is exactly how large production Flutter apps are structured.





