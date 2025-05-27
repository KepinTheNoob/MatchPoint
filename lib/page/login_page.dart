import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matchpoint/page/register_page.dart';
import 'package:matchpoint/widgets/matchPoint_logo_widget.dart';
import 'package:matchpoint/widgets/loginRegisterField_widget.dart';
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
      // Harusnya backend bagian sini fokusnya
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
              // Logo
              MatchPointLogoName(),

              Text(
                "Welcome Back!",
                style: GoogleFonts.quicksand(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF174B7E),
                ),
              ),

              // Username Field
              buildTextField("Username", _usernameController, _usernameError),

              // Password Field
              buildPasswordField(
                "Password",
                _passwordController,
                _isPasswordVisible,
                (value) => setState(() => _isPasswordVisible = value),
                _passwordError,
              ),

              // Login Button
              loginRegisterButton(_validateAndLogin, "Login"),

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
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
}
