class ResendOtpParams {
  final String? email;
  final String? idNumber;
  final String purposes;

  ResendOtpParams({
    this.email,
    this.idNumber,
    required this.purposes,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (email != null && email!.isNotEmpty) {
      data['email'] = email;
    }

    if (idNumber != null && idNumber!.isNotEmpty) {
      data['idNumber'] = idNumber;
    }

    data['purpose'] = purposes;

    return data;
  }
}
