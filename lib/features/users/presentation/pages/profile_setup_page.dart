import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final PageController _pageController = PageController();

  int _currentStep = 0;
  bool _isComplete = false;

  // Form data
  final Map<String, String> _formData = {
    'firstName': '',
    'lastName': '',
    'middle-initial': '',
    'suffix': '',
    'gender': '',
    'month': '',
    'day': '',
    'year': '',
    'email': '',
    'contact_number': '',
    'address': '',
    'facebook': '',
  };

  final List<String> _suffixes = ['Jr.', 'Sr.', 'II', 'III', 'IV', 'V'];
  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> get _days =>
      List.generate(31, (index) => (index + 1).toString());
  List<String> get _years =>
      List.generate(100, (index) => (DateTime.now().year - index).toString());

  // Text controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    final formCubit = context.read<FormCubit>();

    switch (_currentStep) {
      case 0:
        // Validate required fields for step 1
        final requiredFields = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'gender': _formData['gender']!,
          'month': _formData['month']!,
          'day': _formData['day']!,
          'year': _formData['year']!,
        };

        final optionalFields = ['middle-initial', 'suffix'];
        final allFields = Map<String, String>.from(requiredFields);
        allFields.addAll({
          'middle-initial': _middleNameController.text,
          'suffix': _formData['suffix']!,
        });

        return formCubit.validateAll(
          allFields,
          optionalFields: optionalFields,
          customErrorMessages: {
            'firstName': 'First name is required',
            'lastName': 'Last name is required',
            'gender': 'Gender is required',
            'month': 'Birth month is required',
            'day': 'Birth day is required',
            'year': 'Birth year is required',
          },
        );

      case 1:
        // Validate required fields for step 2
        final requiredFields = {
          'email': _emailController.text,
          'contact_number': _contactController.text,
        };

        final optionalFields = ['address', 'facebook'];
        final allFields = Map<String, String>.from(requiredFields);
        allFields.addAll({
          'address': _addressController.text,
          'facebook': _facebookController.text,
        });

        return formCubit.validateAll(
          allFields,
          optionalFields: optionalFields,
          customErrorMessages: {
            'email': 'Email address is required',
            'contact_number': 'Contact number is required',
          },
        );

      default:
        return true;
    }
  }

  void _completeSetup() {
    setState(() {
      _isComplete = true;
    });
  }

  void _resetForm() {
    setState(() {
      _isComplete = false;
      _currentStep = 0;
    });

    // Clear all controllers
    _firstNameController.clear();
    _lastNameController.clear();
    _middleNameController.clear();
    _emailController.clear();
    _contactController.clear();
    _addressController.clear();
    _facebookController.clear();

    // Reset form data
    _formData.forEach((key, value) {
      _formData[key] = '';
    });

    // Clear form validation
    context.read<FormCubit>().clearAll();

    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FormFieldConfig config,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return BlocBuilder<FormCubit, FormValidationState>(
      builder: (context, state) {
        final hasError = state.hasError(config.field_key);
        final errorMessage = state.getErrorMessage(config.field_key);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              required ? '${config.name} *' : config.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: config.hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: hasError ? Colors.red : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: hasError ? Colors.red : Colors.blue,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                errorText: hasError ? errorMessage : null,
              ),
              onChanged: (value) {
                _formData[config.field_key] = value;
                // Clear error when user starts typing
                if (hasError) {
                  context.read<FormCubit>().clearFieldError(config.field_key);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildDropdown({
    required FormFieldConfig config,
    required List<String> items,
    bool required = false,
  }) {
    return BlocBuilder<FormCubit, FormValidationState>(
      builder: (context, state) {
        final hasError = state.hasError(config.field_key);
        final errorMessage = state.getErrorMessage(config.field_key);
        final value = _formData[config.field_key]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              required ? '${config.name} *' : config.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: value.isEmpty ? null : value,
              decoration: InputDecoration(
                hintText: config.hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: hasError ? Colors.red : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: hasError ? Colors.red : Colors.blue,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                errorText: hasError ? errorMessage : null,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (selectedValue) {
                setState(() {
                  _formData[config.field_key] = selectedValue ?? '';
                });
                // Clear error when user selects a value
                if (hasError) {
                  context.read<FormCubit>().clearFieldError(config.field_key);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green[50]!, Colors.blue[50]!],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Profile Complete!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your profile has been set up successfully. Welcome aboard!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _resetForm,
                          child: const Text('Start Over'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.purple[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Profile Setup',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Let\'s get your information ready',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step ${_currentStep + 1} of 3',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${((_currentStep + 1) / 3 * 100).round()}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_currentStep + 1) / 3,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form Content
              Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildStep1(),
                              _buildStep2(),
                              _buildStep3(),
                            ],
                          ),
                        ),

                        // Navigation Buttons
                        Container(
                          padding: const EdgeInsets.only(top: 24),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: _currentStep == 0 ? null : _prevStep,
                                child: const Text('Back'),
                              ),
                              ElevatedButton(
                                onPressed: _currentStep == 2
                                    ? _completeSetup
                                    : _nextStep,
                                child: Text(_currentStep == 2
                                    ? 'Complete Setup'
                                    : 'Next'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _currentStep == 2
                                      ? Colors.green
                                      : Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Required Fields Note
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '* Required fields',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.blue,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 32),

          // Form Fields
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _firstNameController,
                  config: field_firstName,
                  required: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _lastNameController,
                  config: field_lastName,
                  required: true,
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _middleNameController,
                  config: field_middle_name,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  config: field_suffix,
                  items: _suffixes,
                ),
              ),
            ],
          ),

          _buildDropdown(
            config: field_gender,
            items: _genders,
            required: true,
          ),

          Text(
            'Date of Birth *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  config: field_month,
                  items: _months,
                  required: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  config: field_day,
                  items: _days,
                  required: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  config: field_year,
                  items: _years,
                  required: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone,
              color: Colors.green,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 32),

          // Form Fields
          _buildTextField(
            controller: _emailController,
            config: field_email,
            required: true,
            keyboardType: TextInputType.emailAddress,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _contactController,
                config: field_contact_number,
                required: true,
                keyboardType: TextInputType.phone,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: Text(
                  'Include country code (e.g., +63 for Philippines)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),

          _buildTextField(
            controller: _addressController,
            config: field_address,
            maxLines: 3,
          ),

          _buildTextField(
            controller: _facebookController,
            config: field_facebook,
            keyboardType: TextInputType.url,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.purple[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.purple,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Review Your Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 32),

          // Review Sections
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                    'Name: ${_firstNameController.text} ${_middleNameController.text} ${_lastNameController.text} ${_formData['suffix']}'),
                Text('Gender: ${_formData['gender']}'),
                Text(
                    'Date of Birth: ${_formData['month']} ${_formData['day']}, ${_formData['year']}'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Information',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text('Email: ${_emailController.text}'),
                Text('Phone: ${_contactController.text}'),
                if (_addressController.text.isNotEmpty)
                  Text('Address: ${_addressController.text}'),
                if (_facebookController.text.isNotEmpty)
                  Text('Facebook: ${_facebookController.text}'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Please review your information carefully. You can go back to make changes if needed.',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
