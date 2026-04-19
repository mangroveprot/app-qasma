import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../bloc/activity_logs_cubit.dart';
import '../controller/activity_logs_controller.dart';
import '../widgets/activity_logs_widget/activity_logs_form.dart';

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => ActivityLogsPageState();
}

class ActivityLogsPageState extends State<ActivityLogsPage> {
  late final ActivityLogsController controller;

  @override
  void initState() {
    super.initState();
    controller = ActivityLogsController();
    controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ActivityLogsCubit, ActivityLogsCubitState>(
            listener: _handleActivityLogsState,
          ),
        ],
        child: Scaffold(
          appBar: const CustomAppBar(
            title: 'Activity Logs',
            enableBackBtn: true,
          ),
          body: !controller.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: ActivityLogsForm(state: this),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _handleActivityLogsState(
      BuildContext context, ActivityLogsCubitState state) {
    if (state is ActivityLogsFailureState) {
      AppToast.show(
        message: state.errorMessages.isNotEmpty
            ? state.errorMessages.first
            : 'Something went wrong',
        type: ToastType.error,
      );
    }
  }
}
