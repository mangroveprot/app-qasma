import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'common/error/global_error_handler.dart';
import 'common/manager/auth_manager.dart';
import 'common/widgets/bloc/connections/connection_cubit.dart';
import 'common/widgets/bloc/form/form_cubit.dart';
import 'common/widgets/connection_banner.dart/connection_banner.dart';
import 'core/_base/_services/storage/shared_preference.dart';
import 'core/_config/app_config.dart';
import 'core/_config/bloc_dispatcher.dart';
import 'core/_config/flavor_config.dart';
import 'infrastructure/injection/service_locator.dart';
import 'infrastructure/routes/app_router.dart';
import 'infrastructure/theme/light_theme.dart';
import 'features/auth/presentation/bloc/auth/auth_cubit.dart';

Future<void> mainCommon(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  final envFileName =
      flavor == Flavor.development ? '.env.development' : '.env.production';

  await dotenv.load(fileName: envFileName);
  FlavorConfig(flavor: flavor);

  final blocDispatcher = BlocDispatcher();
  Bloc.observer = blocDispatcher;

  setupServiceLocator();

  await Future.wait([SharedPrefs().init(), sl<AppConfig>().init()]);

  GlobalErrorHandling();

  if (kDebugMode) {
    debugPaintSizeEnabled = false;
  }

  // DevicePreview(
  //   enabled: kReleaseMode,
  //   builder: (context) => const MyApp(),
  // )

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FormCubit()),
        BlocProvider.value(value: AuthCubit.instance),
        BlocProvider(create: (_) => ConnectionCubit())
      ],
      child: MaterialApp.router(
        title: AppConfig.appTitle,
        theme: lightTheme,
        routerConfig: AppRouter.router,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
        ),
        builder: (context, child) {
          child = BotToastInit()(context, child);

          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (mounted && context.mounted) {
                AuthManager.handleAuthStateChanges(context, state);
              }
            },
            child: ConnectionBanner(child: child),
          );
        },
      ),
    );
  }
}
