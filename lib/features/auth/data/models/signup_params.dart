import '../../../users/data/models/other_info_model.dart';

class SignupParams {
  final String idNumber;
  final String email;
  final String password;
  final String role;
  final String firstName;
  final String middleName;
  final String lastName;
  final String suffix;
  final String gender;
  final DateTime dateOfBirth;
  final String contactNumber;
  final String address;
  final String facebook;
  final OtherInfoModel otherInfo;

  SignupParams({
    required this.idNumber,
    required this.email,
    required this.password,
    required this.role,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.suffix,
    required this.gender,
    required this.dateOfBirth,
    required this.contactNumber,
    required this.address,
    required this.facebook,
    required this.otherInfo,
  });

  Map<String, dynamic> toJson() => {
    'idNumber': idNumber,
    'email': email,
    'password': password,
    'role': role,
    'first_name': firstName,
    'middle_name': middleName,
    'last_name': lastName,
    'suffix': suffix,
    'gender': gender,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'contact_number': contactNumber,
    'address': address,
    'facebook': facebook,
    'other_info': otherInfo.toMap(),
  };
}
