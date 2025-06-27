import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/router.dart';
import 'package:tripfin/state_injector.dart';
import 'package:tripfin/utils/Color_Constants.dart';

import 'Services/ApiClient.dart';

Future<void> main() async {
  ApiClient.setupInterceptors();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiBlocProvider(
        providers: StateInjector.blocProviders,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'TripFin',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Color(0xff304546),
            ),
            dialogTheme: DialogThemeData(backgroundColor: Color(0xff304546)),
          ),
          routerConfig: goRouter,
        ),
      ),
    );
  }
}
