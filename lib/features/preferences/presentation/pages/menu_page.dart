import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/shell_refresh_scope.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../notifications/presentation/bloc/notification_count_cubit.dart';
import '../controller/menu_controller.dart';
import '../widgets/menu_widget/menu_header.dart';
import '../widgets/menu_widget/menu_items_list.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final AppMenuController controller;
  bool _refreshRegistered = false;

  @override
  void initState() {
    super.initState();
    controller = AppMenuController();
    controller.initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_refreshRegistered) {
      _refreshRegistered = true;
      ShellRefreshScope.of(context)?.registerRefresh(
        Routes.menu_path,
        () {
          if (mounted) {
            context.read<NotificationCountCubit>().refresh();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: BlocBuilder(
        bloc: controller.userCubit,
        builder: (context, state) {
          final userProfile = controller.currentUserProfile();
          final userName = userProfile?.fullName ?? '';
          final idNumber = userProfile?.idNumber ?? '';

          return Scaffold(
            body: Column(
              children: [
                MenuHeader(
                  user_name: userName,
                  idNumber: idNumber,
                  showCloseButton: false,
                ),
                Expanded(
                  child: MenuItemsList(
                    onMenuItemTap: (menuKey) =>
                        controller.handleMenuItemTap(context, menuKey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
