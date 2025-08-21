import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../bloc/user_cubit.dart';
import '../controller/users_controller.dart';
import '../widgets/users_widget/users_form.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage> {
  late final UsersController controller;

  @override
  void initState() {
    super.initState();
    controller = UsersController();
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserCubit, UserCubitState>(
            listener: _handleUserState,
          ),
        ],
        child: Scaffold(
          appBar: const CustomAppBar(title: 'Students'),
          body: LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: UsersForm(
                state: this,
              ),
            );
          }),
        ),
      ),
    );
  }

  void _handleUserState(BuildContext context, UserCubitState state) {
    switch (state.runtimeType) {
      case UserFailureState:
        final failureState = state as UserFailureState;
        AppToast.show(
          message: failureState.primaryError,
          type: ToastType.error,
        );
        break;

      case UserLoadedState:
        final loadedState = state as UserLoadedState;
        if (loadedState.users.isEmpty) {
          AppToast.show(
            message: 'No user yet!',
            type: ToastType.original,
          );
        }
        break;
    }
  }
}
