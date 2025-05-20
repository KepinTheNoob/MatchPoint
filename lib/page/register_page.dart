import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matchpoint/page/login_page.dart';
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

  // Password validation flags
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasDigit = false;
  bool hasSpecialChar = false;
  bool atLeast8 = false;

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
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validatePassword(String password) {
    setState(() {
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasDigit = password.contains(RegExp(r'\d'));
      hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*()\-\_\+=.]'));
      atLeast8 = password.length >= 8;
    });
  }

  void _validateAndRegister() {
    setState(() {
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }

  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=]'));
    bool atLeast8 = password.length >= 8;

    return Material(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _requirementText(
                'Must Contains uppercase letter (A-Z)', hasUppercase),
            _requirementText(
                'Must Contains lowercase letter (a-z)', hasLowercase),
            _requirementText(
              'Must have at least 8 characters',
              atLeast8,
            ),
            _requirementText('Must Contains number (0-9)', hasDigit),
            _requirementText(
              'Must Contains special character (!@#\$%^&*()-_+=.)',
              hasSpecialChar,
            ),
          ],
        ),
      ),
    );
  }

  Widget _requirementText(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            met ? Icons.check_circle : Icons.cancel,
            color: met ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: met ? Colors.green : Colors.red,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isVisible,
    Function(bool) onToggle,
    String errorText, {
    Function(String)? onChanged,
    FocusNode? focusNode,
    Key? key,
  }) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
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
            suffixIcon: SizedBox(
              width: 40, // batas maksimum agar tidak overflow
              child: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Color.fromARGB(255, 96, 96, 96),
                  size: 20, // bisa kecilin ukurannya juga jika perlu
                ),
                onPressed: () {
                  onToggle(!isVisible);
                },
                padding: EdgeInsets.zero, // hilangkan padding default
                constraints: BoxConstraints(), // hilangkan constraint default
              ),
            ),
          ),
          onChanged: onChanged,
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
        setState(() {}); // update isi popup
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 10),
                    Baseline(
                      baseline: 5,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        "Match Point",
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                Text(
                  "Welcome!",
                  style: GoogleFonts.quicksand(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF174B7E),
                  ),
                ),

                // Username
                _buildTextField(
                    "Username", _usernameController, _usernameError),

                // Email
                _buildTextField("Email", _emailController, _emailError),

                // Password
                _buildPasswordField(
                  "Password",
                  _passwordController,
                  _isPasswordVisible,
                  (value) => setState(() => _isPasswordVisible = value),
                  _passwordError,
                  focusNode: _passwordFocusNode,
                  key: _passwordFieldKey,
                  onChanged: _validatePassword,
                ),

                // Confirm Password Field
                _buildPasswordField(
                  "Confirm Password",
                  _confirmPasswordController,
                  _isConfirmPasswordVisible,
                  (value) => setState(() => _isConfirmPasswordVisible = value),
                  _confirmPasswordError,
                  onChanged: null,
                ),

                // Register Button
                ElevatedButton(
                  onPressed: _validateAndRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Register",
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
          ), // Password popup positioned (muncul hanya saat fokus password)
          if (_showPasswordRequirements)
            Positioned(
              left: 32,
              right: 32,
              top: _popupTopPosition,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _animationController,
                  child: _buildPasswordRequirements(),
                ),
              ),
            ),
        ],
      )),
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
}
