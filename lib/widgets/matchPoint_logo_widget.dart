import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchPointLogoName extends StatelessWidget {
  const MatchPointLogoName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logos/logo.png',
          height: 55,
          width: 50,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 5),
        Text(
          "MatchPoint",
          style: GoogleFonts.quicksand(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
