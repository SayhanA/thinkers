import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final void Function(String email, String password) onSubmit;

  const LoginForm({super.key, required this.onSubmit});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14), // smaller font
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined, size: 18),
              border: UnderlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter your email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(fontSize: 14), // smaller font
            decoration: InputDecoration(
              isDense: true,
              // contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline, size: 18),
              border: const UnderlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter your password';
              if (value.length < 6)
                return 'Password must be at least 6 characters';
              return null;
            },
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                print('Forgot Password Tapped.');
                Navigator.pushNamed(
                      context,
                      '/forgot-password',
                    ); 
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: const Color(0xFF6C63FF),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          SizedBox(
            width: double.infinity, // makes button full width
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF), // button color
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ), // taller button if you want
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
