import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/helpers/helpers.dart';
import '../../../../common/helpers/spacing.dart';
import '../../../../common/utils/constant.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_chevron_button.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../bloc/user_cubit.dart';
import '../controller/user_types_controller.dart';

class UserTypesPage extends StatefulWidget {
  const UserTypesPage({super.key});

  @override
  State<UserTypesPage> createState() => _UserTypesPageState();
}

class _UserTypesPageState extends State<UserTypesPage> {
  late final UserTypesController controller;
  bool _hasInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = UserTypesController();

    // delay to load the user data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasInitialized) {
      controller.initialize();
      _hasInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ButtonCubit, ButtonState>(
            listener: _handleButtonState,
          ),
        ],
        child: Scaffold(
          appBar: const CustomAppBar(title: 'Users'),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Builder(builder: (context) {
                  final userCubit = context.read<UserCubit>();

                  return LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              _Chevron(
                                roleType: RoleType.student.field,
                                icons: Icons.school_outlined,
                                onPressed: () {},
                                userLength: userCubit
                                    .filterUsers(
                                      predicate: (user) =>
                                          user.role == RoleType.student.field,
                                    )
                                    .length,
                              ),
                              Spacing.verticalMedium,
                              _Chevron(
                                roleType: RoleType.staff.field,
                                icons: Icons.work_outline,
                                onPressed: () {},
                                userLength: userCubit
                                    .filterUsers(
                                      predicate: (user) =>
                                          user.role == RoleType.staff.field,
                                    )
                                    .length,
                              ),
                              Spacing.verticalMedium,
                              _Chevron(
                                roleType: RoleType.counselor.field,
                                icons: Icons.admin_panel_settings_outlined,
                                onPressed: () {},
                                userLength: userCubit
                                    .filterUsers(
                                      predicate: (user) =>
                                          user.role == RoleType.counselor.field,
                                    )
                                    .length,
                              ),
                            ],
                          ),
                        ));
                  });
                }),
        ),
      ),
    );
  }

  Future<void> _handleButtonState(
      BuildContext context, ButtonState state) async {
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

      for (final suggestion in state.suggestions) {
        AppToast.show(
          message: suggestion,
          type: ToastType.original,
        );
        await Future.delayed(const Duration(milliseconds: 2000));
      }
    }
    if (state is ButtonSuccessState) {}
  }
}

class _Chevron extends StatelessWidget {
  final String roleType;
  final IconData icons;
  final int userLength;
  final VoidCallback onPressed;
  const _Chevron({
    required this.roleType,
    required this.icons,
    required this.userLength,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomChevronButton(
      title: capitalizeWords(roleType + 's'),
      onTap: () {
        context.push(
          Routes.buildPath(Routes.user_path, Routes.user_page),
          extra: {
            'role': roleType,
          },
        );
      },
      icon: icons,
      count: userLength,
    );
  }
}
