import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../widgets/help_support_widget/contact_section.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Help And Support',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 896),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ContactSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
