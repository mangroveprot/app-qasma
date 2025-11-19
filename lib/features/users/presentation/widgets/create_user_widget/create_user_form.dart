import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../../../auth/presentation/widgets/get_started_widget/next_button.dart';
import '../../pages/create_user_page.dart';
import 'create_user_header.dart';
import 'user_fields_section.dart';

class CreateUserForm extends StatelessWidget {
  final CreateUserPageState state;
  const CreateUserForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CreateUserHeader(
            headingTitle: 'Create a new ${state.role}!',
          ),
          Spacing.verticalLarge,
          UserFieldsSection(
            idNumberController:
                state.textControllers[field_idNumber.field_key]!,
            passwordController:
                state.textControllers[field_password.field_key]!,
          ),
          Spacing.verticalLarge,
          NextButton(
            title: 'Done',
            onPressed: () => state.handleSubmit(context),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
        ],
      ),
    );
  }
}
