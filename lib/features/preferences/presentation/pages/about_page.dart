import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../core/_base/_services/package_info/package_info_service.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../update/presentation/bloc/update_cubit.dart';
import '../../../update/presentation/bloc/update_cubit_helpers.dart';
import '../controller/about_controller.dart';
import '../widgets/about_widget/about_header.dart';
import '../widgets/about_widget/version_text.dart';
import '../widgets/about_widget/update_button.dart';
import '../widgets/about_widget/social_media_row.dart';
import '../widgets/about_widget/footer_links.dart';
import '../widgets/about_widget/copyright_text.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  late final AboutController controller;
  String? _currentVersion;
  String? _currentBuild;

  @override
  void initState() {
    super.initState();
    controller = AboutController();
    controller.initialize();
    _loadPackageInfo();
  }

  void _loadPackageInfo() {
    final packageInfo = sl<PackageInfoService>();
    setState(() {
      _currentVersion = packageInfo.version;
      _currentBuild = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: MultiBlocProvider(
        providers: controller.blocProviders,
        child: MultiBlocListener(
          listeners: [
            BlocListener<ButtonCubit, ButtonState>(
              listener: _handleButtonState,
            ),
            BlocListener<UpdateCubit, UpdateCubitState>(
              listener: _handleUpdateState,
            ),
          ],
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      const AboutHeader(),
                      const SizedBox(height: 20),
                      VersionText(
                        currentVersion: _currentVersion,
                        currentBuild: _currentBuild,
                      ),
                      const SizedBox(height: 6),
                      const SizedBox(height: 24),
                      UpdateButton(
                        state: this,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SocialMediaRow(),
                      const SizedBox(height: 20),
                      const FooterLinks(),
                      const SizedBox(height: 12),
                      const CopyrightText(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleButtonState(
    BuildContext context,
    ButtonState state,
  ) async {
    if (state is ButtonFailureState) {
      Future.microtask(() async {
        for (final message in state.errorMessages) {
          AppToast.show(
            message: message,
            type: ToastType.error,
          );
          await Future.delayed(const Duration(milliseconds: 1500));
        }
      });
    }
  }

  Future<void> _handleUpdateState(
    BuildContext context,
    UpdateCubitState state,
  ) async {
    if (state is UpdateCheckFailed) {
      final errMessage = UpdateErrorHelper.getFriendlyMessage(state.message);
      AppToast.show(
          message: errMessage,
          type: ToastType.error,
          duration: const Duration(seconds: 8));
    }
  }
}
