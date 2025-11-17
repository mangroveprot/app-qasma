class VerifyParams {
  final String email;
  final String code;
  final String purpose;

  VerifyParams({
    required this.email,
    required this.code,
    required this.purpose,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
        'purpose': purpose,
      };
}
