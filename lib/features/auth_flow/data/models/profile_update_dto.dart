class ProfileUpdateDto {
  final String name;

 ProfileUpdateDto({
    required this.name,

  });


  Map<String, dynamic> toJson() => {
        "name": name,
      };
}