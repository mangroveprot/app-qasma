class ResetPasswordParams {
  final String email;
  final String newPassword;

  ResetPasswordParams({required this.email, required this.newPassword});

  Map<String, dynamic> toJson() => {
        'email': email,
        'newPassword': newPassword,
      };
}
