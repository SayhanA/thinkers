import 'package:flutter/material.dart';
import 'package:flutter_module_1/forgot.dart';
import 'package:flutter_module_1/home.dart';
import 'package:flutter_module_1/login.dart';
import 'package:flutter_module_1/signup.dart';
import 'package:flutter_module_1/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final user = await AuthService.getUser();

  runApp(MyApp(initialRoute: user != null ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => const Home(), // added this
        '/login': (context) => const MyLogin(),
        '/signup': (context) => const Signup(),
        '/forgot-password': (context) => const ForgotPassword(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
