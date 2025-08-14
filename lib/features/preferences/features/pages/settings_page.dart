import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_chevron_button.dart';
import '../../../../infrastructure/routes/app_routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    CustomChevronButton(
                      title: 'Change Password',
                      icon: Icons.lock_outline,
                      onTap: () {
                        context.push(Routes.buildPath(
                          Routes.aut_path,
                          Routes.change_password,
                        ));
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
