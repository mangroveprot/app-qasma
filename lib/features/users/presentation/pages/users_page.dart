import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/helpers/helpers.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/routes/app_route_extractor.dart';
import '../bloc/user_cubit.dart';
import '../controller/users_controller.dart';
import '../widgets/users_widget/users_form.dart';
import '../widgets/users_widget/user_fab.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage> {
  late final UsersController controller;
  Map<String, dynamic>? _routeData;

  @override
  void initState() {
    super.initState();
    controller = UsersController();
    controller.initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!controller.isInitialized) {
      //  final rawExtra = GoRouterState.of(context).extra;

      controller.initialize();
    }
    _extractRouteData();
  }

  void _extractRouteData() {
    if (_routeData != null) return;

    final rawExtra = GoRouterState.of(context).extra;

    _routeData = rawExtra as Map<String, dynamic>?;

    if (_routeData == null) {
      _routeData = AppRouteExtractor.extractRaw<Map<String, dynamic>>(rawExtra);
    }
  }

  String? get role => _routeData?['role'] as String?;

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
          appBar: CustomAppBar(
            title: role == null ? '' : capitalizeWords('${role}s'),
          ),
          body: Stack(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: UsersForm(
                    state: this,
                  ),
                );
              }),
              if (role != null) ...[
                Positioned(
                  right: 16,
                  bottom: 30,
                  child: UserFab(
                    role: role!,
                    onRefresh: controller.loadAllUsers,
                  ),
                ),
              ]
            ],
          ),
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
