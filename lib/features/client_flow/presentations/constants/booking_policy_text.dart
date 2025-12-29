import 'package:inspect_connect/features/client_flow/data/models/policy_bullet.dart';
import 'package:inspect_connect/features/client_flow/data/models/policy_section.dart';

class BookingPoliciesText {
  static const String title = "Important Policies";

  static const String acknowledgmentText =
      "I acknowledge and agree to the Show-Up Fee, Cancellation, and Billing Hours Policy";

  static const List<PolicySection> sections = [
    PolicySection(
      title: "Show-Up Fee Policy",
      highlight: true,
      bullets: [
        PolicyBullet(
          text:
              "A show-up fee will be charged if the inspector arrives at the scheduled time but cannot perform the inspection due to client unavailability or unpreparedness.",
        ),
        PolicyBullet(
          text:
              "The show-up fee covers the inspector's time and travel expenses.",
        ),
        PolicyBullet(
          text: "This fee will be automatically invoiced to your account.",
        ),
      ],
    ),
    PolicySection(
      title: "Cancellation Policy",
      highlight: true,
      bullets: [
        PolicyBullet(
          text:
              "Free cancellation: Up to 8 hours before the scheduled inspection time.",
        ),
        PolicyBullet(
          text:
              "Late cancellation fee: Cancellations made less than 8 hours before the scheduled time will incur a cancellation fee.",
        ),
        PolicyBullet(
          text:
              "The cancellation fee will be automatically invoiced to your account.",
        ),
        PolicyBullet(
          text: "No refund for no-show or same-day cancellations.",
          highlight: true,
        ),
      ],
    ),
    PolicySection(
      title: "Billing Hours",
      bullets: [
        PolicyBullet(
          text: "All inspections are billed for a minimum of 4 hours.",
        ),
        PolicyBullet(
          text:
              "Inspections over 4 hours and less than 8 hours are billed as 8 hours.",
        ),
      ],
    ),
  ];
}
