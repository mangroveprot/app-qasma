class VerifyParams {
  final String email;
  final String code;

  VerifyParams({required this.email, required this.code});

  Map<String, dynamic> toJson() => {'email': email, 'code': code};
}
