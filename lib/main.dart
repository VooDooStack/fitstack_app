import 'package:FitStack/app/injection/state_providers.dart';
import 'package:FitStack/app/providers/bloc/app/app_bloc.dart';
import 'package:FitStack/app/routing/app_router.dart';
import 'package:FitStack/app/theme/color_Theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'firebase_options.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getTemporaryDirectory());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kDebugMode) FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return StateProviders(
      child: Builder(builder: (context) {
        final AppRouter router = AppRouter(navigatorKey: navigatorKey, appBloc: context.read<AppBloc>());

        return MaterialApp.router(
          routerConfig: router.router,
          theme: FSColorTheme.Light(context),
          darkTheme: FSColorTheme.Light(context),
        );
      }),
    );
  }
}
