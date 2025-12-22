enum InspectorStatus {
  initial,
  unverified,
  needsSubscription,
  underReview,
  rejected,
  approved,
}

extension InspectorStatusDescription on InspectorStatus {
  String get label {
    switch (this) {
      case InspectorStatus.initial:
        return 'Status Loading';
      case InspectorStatus.unverified:
        return 'Phone not verified';
      case InspectorStatus.needsSubscription:
        return 'Needs subscription';
      case InspectorStatus.underReview:
        return 'Profile under review';
      case InspectorStatus.rejected:
        return 'Profile rejected';
      case InspectorStatus.approved:
        return 'Approved';
    }
  }
}
