class UserSubscriptionByIdDto {
  final String planId;
  final String isManual;


 UserSubscriptionByIdDto({
    required this.planId,
    required this.isManual,


  });


  Map<String, dynamic> toJson() => {
        "planId": planId,
        "isManual": isManual,

      };
}