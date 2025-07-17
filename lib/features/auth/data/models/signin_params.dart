class SigninParams {
  final String idNumber;
  final String password;

  SigninParams({required this.idNumber, required this.password});

  Map<String, dynamic> toJson() => {'idNumber': idNumber, 'password': password};
}
