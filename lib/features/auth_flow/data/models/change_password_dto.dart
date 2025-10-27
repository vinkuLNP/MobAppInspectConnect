class ChangePasswordDto {
  final String password;
  final String currentPassword;

 ChangePasswordDto({
    required this.password,
    required this.currentPassword,

  });


  Map<String, dynamic> toJson() => {
        "password": password,
        "currentPassword":currentPassword
      };
}