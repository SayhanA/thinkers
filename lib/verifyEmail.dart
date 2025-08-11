import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_module_1/emailVerificationSuccess.dart';
import 'package:http/http.dart' as http;


class VerifyEmail extends StatefulWidget {
  final String email;

  const VerifyEmail({super.key, required this.email});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  int _secondsLeft = 30;
  Timer? _timer;
  Timer? _verificationCheckTimer;
  bool _isCheckingVerification = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _verificationCheckTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startVerificationCheck() {
    // Check immediately first
    _checkVerificationStatus();
    
    // Then set up periodic checking every 4 seconds
    _verificationCheckTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _checkVerificationStatus();
    });
  }

  Future<void> _checkVerificationStatus() async {
    if (_isCheckingVerification) return;
    
    setState(() {
      _isCheckingVerification = true;
    });

    final url = Uri.parse('https://py-auth.onrender.com/check-verification?email=${widget.email}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['isVerified'] == true) {
          _verificationCheckTimer?.cancel();
          _navigateToLogin();
        }
      }
    } catch (e) {
      // Silently handle errors - we'll try again in 4 seconds
      debugPrint('Verification check error: $e');
    } finally {
      setState(() {
        _isCheckingVerification = false;
      });
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const EmailVerificationSuccess(), 
      ),
    );
    
    // Show success message on the login screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email verified successfully! Please login.')),
    );
  }

  Future<void> _resendEmail() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sending verification email...')),
    );
    _startCountdown();

    final url = Uri.parse('https://py-auth.onrender.com/resend-verification');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email resent!')),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Email Verification"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              const Text(
                "We've sent a verification link to:",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),

              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              const Text(
                "Please check your inbox and click the link to verify your account. "
                "If you don't see the email, check your spam folder.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _secondsLeft == 0 ? _resendEmail : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _secondsLeft == 0
                        ? "Resend Email"
                        : "Resend in ${_secondsLeft}s",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextButton(
                onPressed: _navigateToLogin,
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}