class ProfileUpdateDto {
  final String? name;
  final int? status;

  ProfileUpdateDto({this.name, this.status});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (name != null) {
      data['name'] = name;
    }

    if (status != null) {
      data['status'] = status;
    }

    return data;
  }
}
