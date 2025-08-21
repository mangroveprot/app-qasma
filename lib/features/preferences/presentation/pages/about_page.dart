// about_page.dart
import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../widgets/about_widget/about_footer.dart';
import '../widgets/about_widget/about_header.dart';
import '../widgets/about_widget/contact_section.dart';
import '../widgets/about_widget/mission_section.dart';
import '../widgets/about_widget/team_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 896),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const AboutHeader(),
                const SizedBox(height: 24),
                const MissionSection(),
                const SizedBox(height: 20),
                const TeamSection(),
                const SizedBox(height: 20),
                const ContactSection(),
                const SizedBox(height: 20),
                const AboutFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
