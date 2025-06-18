import 'package:flutter/material.dart';
import 'package:matchpoint/page/forgotPassword_page.dart';

// Password Register
Widget buildPasswordField(
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
            width: 40,
            child: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Color.fromARGB(255, 96, 96, 96),
                size: 20,
              ),
              onPressed: () {
                onToggle(!isVisible);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        onChanged: onChanged,
      ),
      if (errorText.isNotEmpty) const SizedBox(height: 4),
      if (errorText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
    ],
  );
}

// Pop up password
Widget buildPasswordRequirements(_passwordController) {
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

// Pembantu buildPasswordRequirements
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

// Field Text biasa
Widget buildTextField(
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

Widget forgotPasswordField(BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForgotPassword()),
            );
          },
          child: Text(
            "Forgot password?",
            style: TextStyle(
              color: Color(0xff174B7E),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget loginRegisterButton(VoidCallback? validate, String text, bool loading) {
  return ElevatedButton(
    onPressed: loading ? null : validate,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      foregroundColor: Colors.white,
      elevation: 3,
      shadowColor: loading ? Colors.transparent : null,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ).copyWith(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (loading) return Colors.orangeAccent.withOpacity(0.5);
        return Colors.orangeAccent;
      }),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading) ...[
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: loading ? Colors.white : Color(0xFF174B7E),
          ),
        ),
      ],
    ),
  );
}
