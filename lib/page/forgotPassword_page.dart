import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchpoint/widgets/loginRegisterField_widget.dart';
import 'package:matchpoint/widgets/toast_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String _emailError = '';

  void _validateAndReset() async {
    setState(() {
      _emailError = _emailController.text.isEmpty
          ? 'Email must be filled'
          : (!_emailController.text.contains('@') ||
                  !_emailController.text.contains('.'))
              ? 'Email must contain "@" and "."'
              : '';
    });

    if (_emailError.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        toastBool("Successfully sent to email", true);
      } on FirebaseAuthException catch (e) {
        toastBool("Internal Server Error", false);
        print(e);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF8FFFE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 32),
              Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF174B7E),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Enter your email and we’ll send you a password reset link.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              buildTextField("Email", _emailController, _emailError),
              const SizedBox(height: 32),
              Center(
                child: loginRegisterButton(
                  _validateAndReset,
                  "Send",
                  _isLoading,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
