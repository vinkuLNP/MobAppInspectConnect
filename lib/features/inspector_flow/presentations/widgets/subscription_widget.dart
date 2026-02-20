import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/subscription_model.dart';

class SubscriptionCarousel extends StatefulWidget {
  final List<SubscriptionPlanModel> plans;
  final void Function(SubscriptionPlanModel plan, int isMnaual)? onSubscribe;

  const SubscriptionCarousel({
    super.key,
    required this.plans,
    this.onSubscribe,
  });

  @override
  State<SubscriptionCarousel> createState() => _SubscriptionCarouselState();
}

class _SubscriptionCarouselState extends State<SubscriptionCarousel> {
  int _currentIndex = 0;
  bool _autoRenew = true;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        const SizedBox(height: 30),
        Stack(
          children: [
            CarouselSlider.builder(
              itemCount: widget.plans.length,
              options: CarouselOptions(
                height: height * 0.75,
                enlargeCenterPage: true,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                autoPlay: false,
                autoPlayCurve: Curves.easeInOutCubic,
                autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
              itemBuilder: (context, index, _) {
                final plan = widget.plans[index];
                final isActive = _currentIndex == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(vertical: isActive ? 8 : 24),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 400),
                    scale: isActive ? 1 : 0.9,
                    child: _buildPlanCard(context, plan, isActive),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 120,
              left: MediaQuery.of(context).size.width / 2.8,
              child: Column(children: [_buildDotsIndicator()]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.plans.asMap().entries.map((entry) {
        final isActive = _currentIndex == entry.key;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive ? AppColors.authThemeColor : Colors.grey.shade400,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    SubscriptionPlanModel plan,
    bool isActive,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade700,
            Colors.indigo.shade800,
            Colors.purple.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  textWidget(
                    text: plan.name.toString(),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  textWidget(
                    text: plan.displayPrice,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),

                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.greenAccent, width: 1),
                    ),
                    child: textWidget(
                      text: "${plan.trialDays}-days Trial Period",
                      fontSize: 12,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: plan.features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              feature.isApplied
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              color: feature.isApplied
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: textWidget(
                                text: feature.name,
                                fontSize: 14,
                                color: feature.isApplied
                                    ? Colors.white
                                    : Colors.white54,
                                fontWeight: feature.isApplied
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              Column(
                children: [
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.autorenew_rounded,
                              color: _autoRenew
                                  ? Colors.greenAccent
                                  : Colors.white54,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            textWidget(
                              text: "Auto Renew",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Switch(
                          value: _autoRenew,
                          activeThumbColor: Colors.greenAccent,
                          inactiveThumbColor: Colors.grey.shade400,
                          inactiveTrackColor: Colors.white24,
                          onChanged: (value) {
                            setState(() => _autoRenew = value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      buttonBackgroundColor: AppColors.backgroundColor,
                      textColor: AppColors.authThemeColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      onTap: () =>
                          widget.onSubscribe?.call(plan, _autoRenew ? 0 : 1),
                      text: 'Subscribe Now',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
