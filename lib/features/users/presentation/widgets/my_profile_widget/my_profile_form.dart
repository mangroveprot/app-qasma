import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/custom_input_field.dart';
import '../../../../../common/widgets/custom_input_dropdown.dart';
import '../../../../../common/widgets/toast/app_toast.dart';
import '../../../../../infrastructure/injection/service_locator.dart';
import '../../../data/models/params/dynamic_param.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/other_info_model.dart';
import '../../../domain/usecases/is_register_usecase.dart';
import '../../bloc/user_cubit.dart';
import '../../pages/my_profile_page.dart';

class MyProfileForm extends StatefulWidget {
  final MyProfilePageState state;
  const MyProfileForm({super.key, required this.state});

  @override
  State<MyProfileForm> createState() => _MyProfileFormState();
}

class _MyProfileFormState extends State<MyProfileForm> {
  UserModel? _currentUser;
  bool _hasLocalChanges = false;

  // Field configurations
  static const Map<String, List<String>> _dropdownOptions = {
    'gender': genderList,
    'course': courseList,
    'yearLevel': yearLevelList,
    'block': blockList,
  };

  static const Map<String, String> _fieldLabels = {
    'first_name': 'First Name',
    'middle_name': 'Middle Name',
    'last_name': 'Last Name',
    'suffix': 'Suffix',
    'gender': 'Gender',
    'email': 'Email',
    'contact_number': 'Contact Number',
    'address': 'Address',
    'facebook': 'Facebook',
    'course': 'Course',
    'yearLevel': 'Year Level',
    'block': 'Block',
  };

  static const List<String> _otherInfoFields = ['course', 'yearLevel', 'block'];

  Future<void> _updateField(String fieldName, String newValue) async {
    if (_currentUser == null) return;

    if (fieldName == 'email') {
      if (newValue == _currentUser!.email) return;

      final isValid = isValidEmail(newValue.trim());

      if (!isValid)
        return AppToast.show(
            message: 'This is not a valid email.', type: ToastType.error);

      final result = await sl<IsRegisterUsecase>().call(param: newValue);

      result.fold((error) {
        AppToast.show(
            message: error.errorMessages.first, type: ToastType.error);
        return;
      }, (isNotRegistered) {
        if (!isNotRegistered) {
          AppToast.show(
              message: 'This email is already registered.',
              type: ToastType.error);
          return;
        }

        _proceedWithUpdate(fieldName, newValue);
      });
    } else {
      await _proceedWithUpdate(fieldName, newValue);
    }
  }

  Future<void> _proceedWithUpdate(String fieldName, String newValue) async {
    final completer = Completer<void>();
    late StreamSubscription subscription;

    subscription = widget.state.controller.buttonCubit.stream.listen((state) {
      if (state is ButtonSuccessState) {
        subscription.cancel();
        if (!completer.isCompleted) {
          _updateLocalUser(fieldName, newValue);
          completer.complete();
        }
      } else if (state is ButtonFailureState) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.completeError(Exception(state.errorMessages));
        }
      }
    });

    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.completeError(Exception('Update timed out'));
      }
    });

    try {
      final updatedData = _getAllFieldsData();
      updatedData[fieldName] = newValue;

      final param = DynamicParam(fields: updatedData);
      widget.state.controller.updateUser(param);

      await completer.future;
    } catch (e) {
      subscription.cancel();
      rethrow;
    }
  }

  void _updateLocalUser(String fieldName, String newValue) {
    setState(() {
      _hasLocalChanges = true;

      if (_otherInfoFields.contains(fieldName)) {
        final currentOtherInfo =
            OtherInfoModel.fromEntity(_currentUser!.other_info);
        final updatedOtherInfo =
            _updateOtherInfo(currentOtherInfo, fieldName, newValue);
        _currentUser = _currentUser!.copyWith(other_info: updatedOtherInfo);
      } else {
        _currentUser = _updateMainUser(_currentUser!, fieldName, newValue);
      }
    });
  }

  OtherInfoModel _updateOtherInfo(
      OtherInfoModel otherInfo, String fieldName, String newValue) {
    switch (fieldName) {
      case 'course':
        return otherInfo.copyWith(course: newValue);
      case 'yearLevel':
        return otherInfo.copyWith(yearLevel: newValue);
      case 'block':
        return otherInfo.copyWith(block: newValue);
      default:
        return otherInfo;
    }
  }

  UserModel _updateMainUser(UserModel user, String fieldName, String newValue) {
    switch (fieldName) {
      case 'first_name':
        return user.copyWith(first_name: newValue);
      case 'last_name':
        return user.copyWith(last_name: newValue);
      case 'middle_name':
        return user.copyWith(middle_name: newValue);
      case 'email':
        return user.copyWith(email: newValue);
      case 'suffix':
        return user.copyWith(suffix: newValue);
      case 'gender':
        return user.copyWith(gender: newValue);
      case 'address':
        return user.copyWith(address: newValue);
      case 'contact_number':
        return user.copyWith(contact_number: newValue);
      case 'facebook':
        return user.copyWith(facebook: newValue);
      default:
        return user;
    }
  }

  Map<String, String> _getAllFieldsData() {
    return {
      'first_name': _currentUser!.first_name,
      'last_name': _currentUser!.last_name,
      'middle_name': _currentUser!.middle_name,
      'email': _currentUser!.email,
      'suffix': _currentUser!.suffix,
      'gender': _currentUser!.gender,
      'address': _currentUser!.address,
      'contact_number': _currentUser!.contact_number,
      'facebook': _currentUser!.facebook,
      'course': _currentUser!.other_info.course ?? '',
      'yearLevel': _currentUser!.other_info.yearLevel ?? '',
      'block': _currentUser!.other_info.block ?? '',
    };
  }

  String _getFieldValue(String fieldName) {
    if (_currentUser == null) return '';

    if (_otherInfoFields.contains(fieldName)) {
      switch (fieldName) {
        case 'course':
          return _currentUser!.other_info.course ?? '';
        case 'yearLevel':
          return _currentUser!.other_info.yearLevel ?? '';
        case 'block':
          return _currentUser!.other_info.block ?? '';
        default:
          return '';
      }
    }

    switch (fieldName) {
      case 'first_name':
        return _currentUser!.first_name;
      case 'last_name':
        return _currentUser!.last_name;
      case 'middle_name':
        return _currentUser!.middle_name;
      case 'email':
        return _currentUser!.email;
      case 'suffix':
        return _currentUser!.suffix;
      case 'gender':
        return _currentUser!.gender;
      case 'address':
        return _currentUser!.address;
      case 'contact_number':
        return _currentUser!.contact_number;
      case 'facebook':
        return _currentUser!.facebook;
      default:
        return '';
    }
  }

  Widget _buildField(String fieldName) {
    final label = _fieldLabels[fieldName] ?? fieldName;
    final value = _getFieldValue(fieldName);
    final options = _dropdownOptions[fieldName];

    if (options != null) {
      return CustomInputDropdown(
        label: label,
        value: value,
        options: options,
        placeholder: 'Select $label',
        onChanged: (newValue) => _updateField(fieldName, newValue ?? ''),
      );
    }

    return CustomInputField(
      label: label,
      value: value,
      placeholder: 'Enter $label',
      onChanged: (newValue) => _updateField(fieldName, newValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<UserCubit, UserCubitState>(
        builder: (context, state) {
          if (state is UserLoadedState) {
            if (!_hasLocalChanges || _currentUser == null) {
              _currentUser = state.user;
            }
            return _buildForm();
          }

          if (state is UserFailureState) {
            return _buildError(state.errorMessages.first);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildForm() {
    const personalFields = [
      'first_name',
      'middle_name',
      'last_name',
      'suffix',
      'gender'
    ];
    const contactFields = ['email', 'contact_number', 'address', 'facebook'];
    const academicFields = ['course', 'yearLevel', 'block'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Personal Information', personalFields),
          _buildSection('Contact Information', contactFields),
          _buildSection('Academic Information', academicFields),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...fields.map((field) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildField(field),
            )),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(fontSize: 16, color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.state.controller.refreshUser,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
