import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'common/widgets/bloc/button/button_cubit.dart';
import 'common/widgets/bloc/form/form_cubit.dart';
import 'core/_base/_services/storage/shared_preference.dart';
import 'core/_config/app_config.dart';
import 'core/_config/bloc_dispatcher.dart';
import 'core/_config/flavor_config.dart';
import 'infrastructure/injection/service_locator.dart';
import 'infrastructure/routes/app_router.dart';
import 'theme/light_theme.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder:
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => FormCubit()),
              BlocProvider(create: (_) => ButtonCubit()),
            ],
            child: MaterialApp.router(
              title: AppConfig.appTitle,
              theme: lightTheme,
              routerConfig: AppRouter.router,
            ),
          ),
    );
  }
}
