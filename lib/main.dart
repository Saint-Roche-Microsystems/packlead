import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/config/env_config.dart';
import 'package:packlead/core/themes/index.dart';
import 'package:packlead/core/widgets/screen_not_found.dart';
import 'package:packlead/features/auth/presentation/providers/auth_provider.dart';
import 'package:packlead/firebase_options.dart';
import 'package:packlead/home_builder.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Packlead App',
      debugShowCheckedModeBanner: false,
      theme: getGeneralTheme(Brightness.light),
      darkTheme: getGeneralTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: HomeBuilder(authState: authState),
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings, ref),
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => ScreenNotFound(),
      ),
    );
  }
}
