import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matchpoint/page/register_page.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _usernameError = '';
  String _passwordError = '';

  void _validateAndLogin() {
    setState(() {
      _usernameError =
          _usernameController.text.isEmpty ? 'Username must be filled' : '';

      _passwordError = _passwordController.text.isEmpty
          ? 'Password must be filled'
          : (!_passwordController.text.contains(RegExp(r'[A-Z]')))
              ? 'Password must contain an uppercase letter'
              : '';
    });

    if (_usernameError.isEmpty && _passwordError.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xffD9D9D9),
                child: Text("Logo"),
              ),
              Text(
                "Welcome Back!",
                style: GoogleFonts.quicksand(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF174B7E),
                ),
              ),

              // Username
              _buildTextField("Username", _usernameController, _usernameError),

              // Password
              _buildPasswordField(
                  "Password",
                  _passwordController,
                  _isPasswordVisible,
                  (value) => setState(() => _isPasswordVisible = value),
                  _passwordError),

              // Login Button
              ElevatedButton(
                onPressed: _validateAndLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),

              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("or"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/google-logo.png',
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Sign in with Google",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(
                    color: Color(0xff174B7E),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Terms of Use",
                      style: TextStyle(
                        color: Color(0xff174B7E),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: Color(0xff174B7E),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Color(0XFF17597E),
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool isVisible, Function(bool) onToggle, String errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: !isVisible,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Color(0XFF17597E),
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color.fromARGB(255, 96, 96, 96),
              ),
              onPressed: () {
                onToggle(!isVisible);
              },
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
