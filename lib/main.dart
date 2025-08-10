import 'package:flutter/material.dart';
import 'package:flutter_module_1/forgot.dart';
import 'package:flutter_module_1/home.dart';
import 'package:flutter_module_1/login.dart';
import 'package:flutter_module_1/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/': (context) => const Home(),
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
