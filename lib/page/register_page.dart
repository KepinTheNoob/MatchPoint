import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matchpoint/page/login_page.dart';
import 'package:matchpoint/widgets/matchPoint_logo_widget.dart';
import 'package:matchpoint/widgets/loginRegisterField_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchpoint/widgets/toast_widget.dart';
import '../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Password validation flags
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasDigit = false;
  bool hasSpecialChar = false;
  bool atLeast8 = false;
  bool _isLoading = false; // Optional mau pake gak

  final FocusNode _passwordFocusNode = FocusNode();
  final GlobalKey _passwordFieldKey = GlobalKey();

  bool _showPasswordRequirements = false;
  double _popupTopPosition = 100;

  String _usernameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';

  // Animation
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _updatePasswordFlags(String password) {
    hasUppercase = password.contains(RegExp(r'[A-Z]'));
    hasLowercase = password.contains(RegExp(r'[a-z]'));
    hasDigit = password.contains(RegExp(r'\d'));
    hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    atLeast8 = password.length >= 8;
  }

  // Backend Fokus kesini
  void _validateAndRegister() async {
    setState(() {
      _updatePasswordFlags(_passwordController.text);

      _usernameError =
          _usernameController.text.isEmpty ? 'Username must be filled' : '';

      _emailError = _emailController.text.isEmpty
          ? 'Email must be filled'
          : (!_emailController.text.contains('@') ||
                  !_emailController.text.contains('.'))
              ? 'Email must contain "@" and "."'
              : '';

      _passwordError = _passwordController.text.isEmpty
          ? 'Password must be filled'
          : (!hasUppercase ||
                  !hasLowercase ||
                  !hasDigit ||
                  !hasSpecialChar ||
                  !atLeast8)
              ? 'Password does not meet requirements'
              : '';

      _confirmPasswordError = _confirmPasswordController.text.isEmpty
          ? 'Confirm Password must be filled'
          : _confirmPasswordController.text != _passwordController.text
              ? 'Passwords do not match'
              : '';
    });

    if (_usernameError.isEmpty &&
        _emailError.isEmpty &&
        _passwordError.isEmpty &&
        _confirmPasswordError.isEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        if (context.mounted) {
          toastBool("Register Success", true);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          toastBool("Register Failed", false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'An error occurred')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Back End Hiraukan
  void _updatePopupPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _passwordFieldKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        setState(() {
          _popupTopPosition = position.dy - renderBox.size.height - 175;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _passwordFocusNode.addListener(() {
      final hasFocus = _passwordFocusNode.hasFocus;

      if (hasFocus) {
        _animationController.forward();
        _updatePopupPosition();
      } else {
        _animationController.reverse();
      }

      setState(() {
        _showPasswordRequirements = hasFocus;
      });
    });

    _passwordController.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF8FFFE),
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Logo
                MatchPointLogoName(),

                Text(
                  "Welcome!",
                  style: GoogleFonts.quicksand(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF174B7E),
                  ),
                ),

                // Username
                buildTextField("Username", _usernameController, _usernameError),

                // Email
                buildTextField("Email", _emailController, _emailError),

                // Password
                buildPasswordField(
                  "Password",
                  _passwordController,
                  _isPasswordVisible,
                  (value) => setState(() => _isPasswordVisible = value),
                  _passwordError,
                  focusNode: _passwordFocusNode,
                  key: _passwordFieldKey,
                ),

                // Confirm Password Field
                buildPasswordField(
                  "Confirm Password",
                  _confirmPasswordController,
                  _isConfirmPasswordVisible,
                  (value) => setState(() => _isConfirmPasswordVisible = value),
                  _confirmPasswordError,
                ),

                // Register Button
                loginRegisterButton(
                    _validateAndRegister, "Register", _isLoading),

                // Desain or doang
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

                // Tombol Google
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey, width: 1),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // Pindah ke Login page
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Color(0xff174B7E),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                // Jujur ini gak tahu buat apa, pajangan aja
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

          // Password popup positioned (muncul hanya saat fokus password)
          if (_showPasswordRequirements)
            Positioned(
              left: 32,
              right: 32,
              top: _popupTopPosition,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _animationController,
                  child: buildPasswordRequirements(_passwordController),
                ),
              ),
            ),
        ],
      )),
    );
  }
}
