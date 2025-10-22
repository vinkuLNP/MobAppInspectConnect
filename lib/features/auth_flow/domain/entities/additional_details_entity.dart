class AdditionalDetails {
  bool termsAccepted = false;
  String notes = '';

  Map<String, dynamic> toJson() => {
        'termsAccepted': termsAccepted,
        'notes': notes,
      };
}
