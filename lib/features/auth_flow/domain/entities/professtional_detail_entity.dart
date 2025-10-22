
class ProfessionalDetails {
  String company = '';
  String designation = '';
  int experienceYears = 0;

  Map<String, dynamic> toJson() => {
        'company': company,
        'designation': designation,
        'experienceYears': experienceYears,
      };
}