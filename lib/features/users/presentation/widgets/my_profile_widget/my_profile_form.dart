import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../common/widgets/custom_input_dropdown.dart';
import '../../../../../common/widgets/custom_input_field.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../bloc/user_cubit_extensions.dart';
import '../profile_skeleton_loader/my_profile_skeletal_loader.dart';
import 'profile_section.dart';
import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/toast/app_toast.dart';
import '../../../../../infrastructure/injection/service_locator.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/usecases/is_register_usecase.dart';
import '../../bloc/user_cubit.dart';
import '../../config/profile_config.dart';
import '../../pages/my_profile_page.dart';
import '../../utils/profile_utils.dart';
import 'my_profile_action_buttons.dart';
import 'my_profile_header.dart';

class MyProfileForm extends StatefulWidget {
  final MyProfilePageState state;
  const MyProfileForm({super.key, required this.state});

  @override
  State<MyProfileForm> createState() => _MyProfileFormState();
}

class _MyProfileFormState extends State<MyProfileForm> {
  UserModel? _originalUser;
  UserModel? _currentUser;
  bool _hasChanges = false;
  bool _isSaving = false;
  bool _isMinimumLoadingTime = true;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isMinimumLoadingTime = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _initializeControllers() {
    for (String fieldName in ProfileFieldConfig.fieldLabels.keys) {
      if (!ProfileFieldConfig.dropdownOptions.containsKey(fieldName)) {
        _controllers[fieldName] = TextEditingController();
      }
    }
  }

  void _populateControllers() {
    if (_currentUser == null) return;

    for (String fieldName in _controllers.keys) {
      _controllers[fieldName]?.text =
          ProfileFormUtils.getFieldValue(_currentUser!, fieldName);
    }
  }

  void _onFieldChanged() {
    setState(() {
      _hasChanges = _hasAnyChanges();
    });
  }

  bool _hasAnyChanges() {
    if (_originalUser == null || _currentUser == null) return false;

    for (String fieldName in _controllers.keys) {
      final String currentValue = _controllers[fieldName]?.text ?? '';
      final String originalValue =
          ProfileFormUtils.getFieldValue(_originalUser!, fieldName);
      if (currentValue != originalValue) return true;
    }

    for (String fieldName in ProfileFieldConfig.dropdownOptions.keys) {
      final String currentValue =
          ProfileFormUtils.getFieldValue(_currentUser!, fieldName);
      final String originalValue =
          ProfileFormUtils.getFieldValue(_originalUser!, fieldName);
      if (currentValue != originalValue) return true;
    }

    return false;
  }

  void _onDropdownChanged(String fieldName, String newValue) {
    setState(() {
      _currentUser =
          ProfileFormUtils.updateMainUser(_currentUser!, fieldName, newValue);
      _hasChanges = _hasAnyChanges();
    });
  }

  void _cancelChanges() {
    setState(() {
      _currentUser = _originalUser?.copyWith();
      _populateControllers();
      _hasChanges = false;
    });
  }

  Future<void> _saveChanges() async {
    if (_currentUser == null || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      _updateCurrentUserWithTextFields();

      final emailChanged = _controllers['email']?.text != _originalUser?.email;
      final idNumberChanged =
          _controllers['idNumber']?.text != _originalUser?.idNumber;

      if (idNumberChanged) {
        final idNumber = _controllers['idNumber']?.text.trim() ?? '';

        final bool isNotRegisteredId = await _validate(
            field: idNumber, message: 'This ID Number is already registered');
        if (!isNotRegisteredId) return;
      }

      if (emailChanged) {
        final email = _controllers['email']?.text.trim() ?? '';
        if (!isValidEmail(email)) {
          _showError('This is not a valid email.');
          return;
        }

        final bool isNotRegisteredEmail = await _validate(
            field: email, message: 'This email is already registered');
        if (!isNotRegisteredEmail) return;
      }

      await _performUpdate();
    } catch (e) {
      // _showError(e.toString());
    }
  }

  Future<bool> _validate({
    required String field,
    String message = 'This is already registered.',
  }) async {
    final result = await sl<IsRegisterUsecase>().call(param: field);

    return result.fold((error) {
      _showError(error.message ?? error.errorMessages.first);
      return false;
    }, (isNotRegistered) {
      if (!isNotRegistered) {
        _showError(message);
        return false;
      }
      return true;
    });
  }

  void _showError(String message) {
    setState(() {
      _isSaving = false;
    });
    AppToast.show(message: message, type: ToastType.error);
  }

  void _updateCurrentUserWithTextFields() {
    for (String fieldName in _controllers.keys) {
      final String newValue = _controllers[fieldName]?.text ?? '';
      _currentUser =
          ProfileFormUtils.updateMainUser(_currentUser!, fieldName, newValue);
    }
  }

  Future<void> _performUpdate() async {
    final completer = Completer<void>();
    late StreamSubscription subscription;

    subscription = widget.state.controller.buttonCubit.stream.listen((state) {
      if (state is ButtonSuccessState) {
        subscription.cancel();
        if (!completer.isCompleted) {
          setState(() {
            _isSaving = false;
            _originalUser = _currentUser?.copyWith();
            _hasChanges = false;
          });
          AppToast.show(
            message: 'Profile updated successfully',
            type: ToastType.success,
          );
          completer.complete();
        }
      } else if (state is ButtonFailureState) {
        subscription.cancel();
        if (!completer.isCompleted) {
          _showError(state.errorMessages.first);
          completer.completeError(Exception(state.errorMessages));
        }
      }
    });

    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        subscription.cancel();
        _showError('Update timed out. Please try again.');
        completer.completeError(Exception('Update timed out'));
      }
    });

    try {
      final updatedData =
          ProfileFormUtils.getAllFieldsData(_currentUser!, _controllers);
      print(['=============================', updatedData]);
      // final param = DynamicParam(fields: updatedData);
      // widget.state.controller.updateUser(param);
      await completer.future;
    } catch (e) {
      subscription.cancel();
      rethrow;
    }
  }

  List<Widget> _buildFieldsForSection(List<String> fields, {String? userRole}) {
    return fields
        .map((fieldName) {
          final label = ProfileFieldConfig.fieldLabels[fieldName] ?? fieldName;
          final value =
              ProfileFormUtils.getFieldValue(_currentUser!, fieldName);
          final options = ProfileFieldConfig.dropdownOptions[fieldName];
          final icon = ProfileFieldConfig.fieldIcons[fieldName];

          if (userRole != null &&
              userRole != RoleType.student.field.toString()) {
            final studentOnlyFields = ['course', 'year_level', 'section'];
            if (studentOnlyFields.contains(fieldName) &&
                (options?.isEmpty ?? true)) {
              return const SizedBox.shrink();
            }
          }

          if (options != null && options.isNotEmpty) {
            final List<String> updatedOptions = List.from(options);

            if (value.isNotEmpty && !options.contains(value)) {
              updatedOptions.add(value);
            }

            String finalValue;
            if (value.isNotEmpty && updatedOptions.contains(value)) {
              finalValue = value;
            } else if (updatedOptions.isNotEmpty) {
              finalValue = updatedOptions.first;
            } else {
              return CustomInputField(
                fieldName: fieldName,
                label: label,
                controller: _controllers[fieldName] ??
                    TextEditingController(text: value),
                icon: icon,
                isEnabled: !_isSaving,
                keyboardType: ProfileFieldConfig.getKeyboardType(fieldName),
                onChanged: _onFieldChanged,
              );
            }

            return CustomInputDropdownField(
              fieldName: fieldName,
              label: label,
              value: finalValue,
              options: updatedOptions,
              icon: icon,
              isEnabled: !_isSaving,
              onChanged: (newValue) => _onDropdownChanged(fieldName, newValue),
            );
          } else {
            if (_controllers[fieldName] == null) {
              _controllers[fieldName] = TextEditingController(text: value);
            }

            return CustomInputField(
              fieldName: fieldName,
              label: label,
              controller: _controllers[fieldName]!,
              icon: icon,
              isEnabled: !_isSaving,
              keyboardType: ProfileFieldConfig.getKeyboardType(fieldName),
              onChanged: _onFieldChanged,
            );
          }
        })
        .where((widget) => widget is! SizedBox || (widget).height != 0.0)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocBuilder<UserCubit, UserCubitState>(
        builder: (context, state) {
          if (_isMinimumLoadingTime ||
              (state is! UserLoadedState && state is! UserFailureState)) {
            return MyProfileSkeletonLoader.profilePage();
          }

          if (state is UserLoadedState) {
            final id = widget.state.idNumber ?? '';
            final current = context.read<UserCubit>().getUserByIdNumber(id);

            if (current == null) {
              return _buildError('User not found');
            }

            if (_originalUser == null) {
              _originalUser = current.copyWith();
              _currentUser = current.copyWith();
              _populateControllers();
            }
            return Column(
              children: [
                Expanded(
                  child: _buildForm(_currentUser!),
                ),
                MyProfileActionButtons(
                  hasChanges: _hasChanges,
                  isSaving: _isSaving,
                  onCancel: _cancelChanges,
                  onSave: _saveChanges,
                ),
              ],
            );
          }

          if (state is UserFailureState) {
            return _buildError(state.errorMessages.first);
          }

          return MyProfileSkeletonLoader.profilePage();
        },
      ),
    );
  }

  Widget _buildForm(UserModel user) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ProfileHeader(
                user: user,
              ),
              const SizedBox(height: 32),
              if (user.role == RoleType.student.field.toString()) ...[
                ProfileSection(
                  title: 'User Information',
                  icon: Icons.info_outline,
                  fields: _buildFieldsForSection(
                      ProfileFieldConfig.informationFields),
                ),
                const SizedBox(height: 24),
              ],
              ProfileSection(
                title: 'Personal Information',
                icon: Icons.person_outline,
                fields:
                    _buildFieldsForSection(ProfileFieldConfig.personalFields),
              ),
              const SizedBox(height: 24),
              ProfileSection(
                title: 'Contact Information',
                icon: Icons.contact_phone_outlined,
                fields:
                    _buildFieldsForSection(ProfileFieldConfig.contactFields),
              ),
              if (user.role == RoleType.student.field.toString()) ...[
                const SizedBox(height: 24),
                ProfileSection(
                  title: 'Academic Information',
                  icon: Icons.school_outlined,
                  fields: _buildFieldsForSection(
                      ProfileFieldConfig.otherInfoFields),
                ),
              ],
              if (user.role == RoleType.student.field.toString()) ...[
                const SizedBox(height: 24),
                ProfileSection(
                  title: 'Academic Information',
                  icon: Icons.school_outlined,
                  fields: _buildFieldsForSection(
                      ProfileFieldConfig.otherInfoFields),
                ),
              ],
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.error.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: colors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: fontWeight.bold,
                color: colors.black.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: widget.state.controller.refreshUser,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.secondary,
                foregroundColor: colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
