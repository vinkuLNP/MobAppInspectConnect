import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/features/client_flow/data/models/policy_bullet.dart';
import 'package:inspect_connect/features/client_flow/data/models/policy_section.dart';

class BookingPoliciesText {
  static const String title = importantPolicies;
  static const String acknowledgmentText = policyAcknowledgmentText;

  static const List<PolicySection> sections = [
    PolicySection(
      title: showUpFeePolicy,
      highlight: true,
      bullets: [
        PolicyBullet(text: showUpFeeBullet1),
        PolicyBullet(text: showUpFeeBullet2),
        PolicyBullet(text: showUpFeeBullet3),
      ],
    ),
    PolicySection(
      title: cancellationPolicy,
      highlight: true,
      bullets: [
        PolicyBullet(text: cancellationBullet1),
        PolicyBullet(text: cancellationBullet2),
        PolicyBullet(text: cancellationBullet3),
        PolicyBullet(text: cancellationBullet4, highlight: true),
      ],
    ),
    PolicySection(
      title: billingHours,
      bullets: [
        PolicyBullet(text: billingBullet1),
        PolicyBullet(text: billingBullet2),
      ],
    ),
  ];
}
