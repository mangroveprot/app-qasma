class FormFieldConfig {
  final String field_key;
  final String name;
  final String hint;

  const FormFieldConfig({
    required this.field_key,
    required this.name,
    required this.hint,
  });
}

// get-started
const FormFieldConfig field_idNumber = FormFieldConfig(
  field_key: 'idNumber',
  name: 'ID Number',
  hint: 'Enter your id number...',
);
const FormFieldConfig field_course = FormFieldConfig(
  field_key: 'course',
  name: 'Course',
  hint: 'Enter your first name...',
);
const FormFieldConfig field_password = FormFieldConfig(
  field_key: 'password',
  name: 'Password',
  hint: 'Enter your password...',
);
const FormFieldConfig field_confirm_password = FormFieldConfig(
  field_key: 'confirm-password',
  name: 'Confirm Password',
  hint: 'Re-enter...',
);
const FormFieldConfig field_block = FormFieldConfig(
  field_key: 'block',
  name: 'Block',
  hint: 'select...',
);
const FormFieldConfig field_year_level = FormFieldConfig(
  field_key: 'year-level',
  name: 'Year Level',
  hint: 'select...',
);

// create-account
const FormFieldConfig field_firstName = FormFieldConfig(
  field_key: 'firstName',
  name: 'First Name',
  hint: 'Enter your first name...',
);

const FormFieldConfig field_lastName = FormFieldConfig(
  field_key: 'lastName',
  name: 'Last Name',
  hint: 'Enter your last name...',
);
const FormFieldConfig field_suffix = FormFieldConfig(
  field_key: 'suffix',
  name: 'Suffix',
  hint: '(optional)',
);
const FormFieldConfig field_middle_name = FormFieldConfig(
  field_key: 'middle-initial',
  name: 'Middle Name',
  hint: '(optional)',
);
const FormFieldConfig field_gender = FormFieldConfig(
  field_key: 'gender',
  name: 'Gender',
  hint: 'select...',
);
const FormFieldConfig field_month = FormFieldConfig(
  field_key: 'month',
  name: 'Month',
  hint: 'select...',
);

const FormFieldConfig field_day = FormFieldConfig(
  field_key: 'day',
  name: 'Day',
  hint: 'select...',
);

const FormFieldConfig field_year = FormFieldConfig(
  field_key: 'year',
  name: 'Year',
  hint: 'select...',
);

const FormFieldConfig field_address = FormFieldConfig(
  field_key: 'address',
  name: 'Address',
  hint: 'Enter your address... (optional)',
);

const FormFieldConfig field_contact_number = FormFieldConfig(
  field_key: 'contact_number',
  name: 'Contact Number',
  hint: 'Enter your contact number...',
);

const FormFieldConfig field_email = FormFieldConfig(
  field_key: 'email',
  name: 'Email',
  hint: 'Enter your email address...',
);

const FormFieldConfig field_facebook = FormFieldConfig(
  field_key: 'facebook',
  name: 'Facebook',
  hint: 'Enter your Facebook profile link... (optional)',
);
