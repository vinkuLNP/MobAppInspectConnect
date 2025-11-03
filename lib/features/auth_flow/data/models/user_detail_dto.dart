class UserDetailDto {
  final String userID;

 UserDetailDto({
    required this.userID,
  });


  Map<String, dynamic> toJson() => {
        "id": userID,
      };
}