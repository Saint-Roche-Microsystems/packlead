import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/config/env_config.dart';
import 'package:packlead/core/themes/index.dart';
import 'package:packlead/firebase_options.dart';
import 'package:packlead/navigation/app_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: getGeneralTheme(Brightness.light),
      darkTheme: getGeneralTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('Página no encontrada')),
        ),
      ),
    );
  }
}
