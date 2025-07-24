import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController officeAddressController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode genderFocus = FocusNode();
  final FocusNode birthdayFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode officeAddressFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    birthdayController.dispose();
    addressController.dispose();
    officeAddressController.dispose();

    nameFocus.dispose();
    genderFocus.dispose();
    birthdayFocus.dispose();
    addressFocus.dispose();
    officeAddressFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // CRITICAL: Set to false to improve keyboard performance
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('Page A')),
        body: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              // Use AnimatedContainer for smoother keyboard transitions
              padding: EdgeInsets.fromLTRB(
                15,
                15,
                15,
                35 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Optimized for keyboard performance'),
                  const SizedBox(height: 20),

                  _buildTextField(
                    label: 'Name',
                    controller: nameController,
                    focusNode: nameFocus,
                    nextFocus: genderFocus,
                    textCapitalization: TextCapitalization.words,
                  ),

                  _buildTextField(
                    label: 'Gender',
                    controller: genderController,
                    focusNode: genderFocus,
                    nextFocus: birthdayFocus,
                  ),

                  _buildTextField(
                    label: 'Birthday',
                    controller: birthdayController,
                    focusNode: birthdayFocus,
                    nextFocus: addressFocus,
                  ),

                  _buildTextField(
                    label: 'Address',
                    controller: addressController,
                    focusNode: addressFocus,
                    nextFocus: officeAddressFocus,
                  ),

                  _buildTextField(
                    label: 'Office Address',
                    controller: officeAddressController,
                    focusNode: officeAddressFocus,
                    isLast: true,
                  ),

                  // Add extra space for keyboard clearance
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom + 80,
                  ),
                ],
              ),
            ),

            // Fixed bottom button using AnimatedPositioned for smooth animation
            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  // Add haptic feedback
                  HapticFeedback.lightImpact();
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => const PageB())
                  // );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Open Page B'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (val) => print('$label: $val'),
            textInputAction:
                isLast ? TextInputAction.done : TextInputAction.next,
            textCapitalization: textCapitalization,
            // Performance optimizations
            enableSuggestions: false,
            autocorrect: false,
            onSubmitted: (_) {
              if (nextFocus != null) {
                nextFocus.requestFocus();
              } else {
                focusNode.unfocus();
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              // Disable dense to prevent layout shifts
              isDense: false,
            ),
          ),
        ],
      ),
    );
  }
}
