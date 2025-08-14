class ChangePasswordParams {
  final String idNumber;
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.idNumber,
    required this.newPassword,
    required this.currentPassword,
  });

  Map<String, dynamic> toJson() => {
        'idNumber': idNumber,
        'newPassword': newPassword,
        'currentPassword': currentPassword,
      };
}
