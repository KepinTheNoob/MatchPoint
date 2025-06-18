import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matchpoint/page/home_page.dart';
import 'package:matchpoint/page/register_page.dart';
import 'package:matchpoint/page/signInWithGoogle.dart';
import 'package:matchpoint/widgets/matchPoint_logo_widget.dart';
import 'package:matchpoint/widgets/loginRegisterField_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchpoint/widgets/toast_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  String _emailError = '';
  String _passwordError = '';

  void _validateAndLogin() async {
    setState(() {
      _emailError = _emailController.text.isEmpty
          ? 'Email must be filled'
          : (!_emailController.text.contains('@') ||
                  !_emailController.text.contains('.'))
              ? 'Email must contain "@" and "."'
              : '';

      _passwordError = _passwordController.text.isEmpty
          ? 'Password must be filled'
          : (!_passwordController.text.contains(RegExp(r'[A-Z]')))
              ? 'Password must contain an uppercase letter'
              : '';
    });

    if (_emailError.isEmpty && _passwordError.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (context.mounted) {
          toastBool("Login Success", true);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          toastBool(e.message ?? "Login Failed", false);

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(e.message ?? 'An error occurred')),
          // );
        }
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

              // Email Field
              buildTextField("Email", _emailController, _emailError),

              // Password Field
              Column(children: [
                buildPasswordField(
                  "Password",
                  _passwordController,
                  _isPasswordVisible,
                  (value) => setState(() => _isPasswordVisible = value),
                  _passwordError,
                ),
                forgotPasswordField(context),
              ]),

              // Login Button
              loginRegisterButton(_validateAndLogin, "Login", _isLoading),

              // const Row(
              //   children: [
              //     Expanded(child: Divider()),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 10),
              //       child: Text("or"),
              //     ),
              //     Expanded(child: Divider()),
              //   ],
              // ),

              // ElevatedButton(
              //   onPressed: () async {
              //     setState(() => _isLoading = true);
              //     try {
              //       final result = await _authService.signInWithGoogle();
              //       if (result != null) {
              //         if (context.mounted) {
              //           toastBool("Google Sign-in Success", true);
              //           Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(builder: (context) => const Home()),
              //           );
              //         }
              //       } else {
              //         if (context.mounted) {
              //           toastBool("Google Sign-in Failed", false);
              //         }
              //       }
              //     } catch (e) {
              //       if (context.mounted) {
              //         toastBool("Error: $e", false);
              //       }
              //     } finally {
              //       if (mounted) {
              //         setState(() => _isLoading = false);
              //       }
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     minimumSize: const Size(double.infinity, 50),
              //     elevation: 3,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       side: const BorderSide(color: Colors.grey, width: 1),
              //     ),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Image.asset(
              //         'assets/google-logo.png',
              //         height: 24,
              //       ),
              //       const SizedBox(width: 10),
              //       const Text(
              //         "Sign in with Google",
              //         style:
              //             TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              //       ),
              //     ],
              //   ),
              // ),

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

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Flexible(
                      child: Text(
                        "Note: The email must be linked to a registered device for future features.",
                        style: TextStyle(
                          color: Color(0xff174B7E),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),

              // Gak kepake, tapi simpen aja
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     TextButton(
              //       onPressed: () {},
              //       child: const Text(
              //         "Terms of Use",
              //         style: TextStyle(
              //           color: Color(0xff174B7E),
              //           decoration: TextDecoration.underline,
              //         ),
              //       ),
              //     ),
              //     TextButton(
              //       onPressed: () {},
              //       child: const Text(
              //         "Privacy Policy",
              //         style: TextStyle(
              //           color: Color(0xff174B7E),
              //           decoration: TextDecoration.underline,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
