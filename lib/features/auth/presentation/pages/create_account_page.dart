import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/button/custom_app_button.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../widgets/signup_header.dart';

// ignore: must_be_immutable
class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();

  String? _gender;
  String? _day, _month, _year;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
