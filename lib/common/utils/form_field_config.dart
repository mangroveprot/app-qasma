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
  hint: 'e.g., KC-2-123',
);
const FormFieldConfig field_idNumber_email = FormFieldConfig(
  field_key: 'idNumber-email',
  name: 'ID Number or Email',
  hint: 'Enter your id number or email...',
);
const FormFieldConfig field_course = FormFieldConfig(
  field_key: 'course',
  name: 'Course',
  hint: 'Select a course....',
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
const FormFieldConfig field_current_password = FormFieldConfig(
  field_key: 'current-password',
  name: 'Current Password',
  hint: 'Enter your current password...',
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
  hint: 'Juan',
);

const FormFieldConfig field_lastName = FormFieldConfig(
  field_key: 'lastName',
  name: 'Last Name',
  hint: 'Dela Cruz',
);
const FormFieldConfig field_suffix = FormFieldConfig(
  field_key: 'suffix',
  name: 'Suffix',
  hint: 'e.g, Jr.',
);
const FormFieldConfig field_middle_name = FormFieldConfig(
  field_key: 'middle-initial',
  name: 'Middle Initial',
  hint: 'e.g, D',
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
  hint: 'e.g., House No., Street, City',
);

const FormFieldConfig field_contact_number = FormFieldConfig(
  field_key: 'contact_number',
  name: 'Contact Number',
  hint: 'e.g, 9812487711',
);

const FormFieldConfig field_email = FormFieldConfig(
  field_key: 'email',
  name: 'Email',
  hint: 'e.g, your.active@email.com',
);

const FormFieldConfig field_facebook = FormFieldConfig(
  field_key: 'facebook',
  name: 'Facebook',
  hint: 'e.g, www.facebook.com/username',
);

const FormFieldConfig field_otp_verification = FormFieldConfig(
  field_key: 'otp-verfication',
  name: 'OTP Verification',
  hint: 'Please enter the 6-digit code sent to your email ',
);

const FormFieldConfig field_other_option = FormFieldConfig(
  field_key: 'other-option',
  name: 'Others',
  hint: 'Please specify...',
);

const FormFieldConfig field_appointmentType = FormFieldConfig(
  field_key: 'appointment-type',
  name: 'Appointment Type',
  hint: 'Select an appointment type...',
);

const FormFieldConfig field_appointmentDateTime = FormFieldConfig(
  field_key: 'appointment-dateTime',
  name: 'Data & Time',
  hint: 'Select an date time...',
);

const FormFieldConfig field_description = FormFieldConfig(
  field_key: 'description',
  name: 'Description',
  hint: 'Write something here...',
);
const FormFieldConfig field_remarks = FormFieldConfig(
  field_key: 'remarks',
  name: 'Remarks',
  hint: 'Write something here...',
);
const FormFieldConfig field_code = FormFieldConfig(
  field_key: 'code',
  name: 'Code',
  hint: 'Enter code here',
);
