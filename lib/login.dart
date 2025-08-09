import 'package:flutter/material.dart';
import 'package:flutter_module_1/LoginForm.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  void _handleLogin(String email, String password) {
    // Handle login logic here, e.g. call backend or show snackbar
    print('Email: $email, Password: $password');
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SvgPicture.asset(
                            'assets/connect.svg',
                            width: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),child: const Text(
              'LogIn',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),),

            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: LoginForm(onSubmit: _handleLogin),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'signup',
                    ); // Update with your signup route
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
