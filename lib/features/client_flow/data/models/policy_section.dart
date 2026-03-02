import 'package:inspect_connect/features/client_flow/data/models/policy_bullet.dart';

class PolicySection {
  final String title;
  final List<PolicyBullet> bullets;
  final bool highlight;

  const PolicySection({
    required this.title,
    required this.bullets,
    this.highlight = false,
  });
}
