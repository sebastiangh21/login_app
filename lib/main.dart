import 'package:flutter/material.dart';
import 'package:login_app/pages/login_page.dart';
import 'package:login_app/pages/map_page.dart';
import 'package:login_app/pages/otp_page.dart';
import 'package:login_app/pages/sigin_page.dart';
import 'package:login_app/user_preferences/user_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: "login",
      routes: {
        "login": (context) => const LoginPage(),
        "register": (context) => const SiginPage(),
        "otp": (context) => const OtpPage(),
        "map": (context) => const MapPage()
      },
    );
  }
}
