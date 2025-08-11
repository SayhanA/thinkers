import 'package:flutter/material.dart';
import 'package:flutter_module_1/LoginForm.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  bool _isLoading = false;

  void _handleLogin(String email, String password) async {
    setState(() => _isLoading = true);

    final result = await AuthService.login(email, password);

    if (!mounted) return; 

    if (result.success) {
      print('Login data: ${result.data}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${result.message}')));
    }

    setState(() => _isLoading = false);
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
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 230,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SvgPicture.asset(
                  'assets/connect.svg',
                  width: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: LoginForm(onSubmit: _handleLogin, isLoading: _isLoading),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
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
            ),
          ],
        ),
      ),
    );
  }
}
