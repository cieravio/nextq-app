import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nextq_app/ui/pages/daily_test_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nextq_app/firebase_options.dart';
import 'package:nextq_app/providers/firebase_auth_provider.dart';
import 'package:nextq_app/providers/shared_preference_provider.dart';
import 'package:nextq_app/services/firebase_auth_service.dart';
import 'package:nextq_app/services/shared_preferences_service.dart';
import 'package:nextq_app/ui/pages/home_page.dart';
import 'package:nextq_app/ui/pages/login_page.dart';
import 'package:nextq_app/ui/pages/register_page.dart';
import 'package:nextq_app/ui/static/navigation_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;

  runApp(MultiProvider(providers: [
    Provider(
      create: (context) => SharedPreferencesService(pref),
    ),
    ChangeNotifierProvider(
      create: (context) => SharedPreferenceProvider(
        context.read<SharedPreferencesService>(),
      ),
    ),
    Provider(
      create: (context) => FirebaseAuthService(firebaseAuth),
    ),
    ChangeNotifierProvider(
      create: (context) => FirebaseAuthProvider(
        context.read<FirebaseAuthService>(),
      ),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'IBMPlexSansCondensed'),
      initialRoute: NavigationRoute.login.name,
      routes: {
        NavigationRoute.login.name: (context) => const LoginPage(),
        NavigationRoute.register.name: (context) => const RegisterPage(),
        NavigationRoute.home.name: (context) => const HomePage(),
        NavigationRoute.dailyTest.name: (context) => const DailyTestPage(),
        // NavigationRoute.starterTest.name: (context) => StarterTestPage(),
      },
    );
  }
}
