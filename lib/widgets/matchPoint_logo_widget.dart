import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchPointLogoName extends StatelessWidget {
  const MatchPointLogoName({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logos/icon.png',
          height: 65,
          width: 80,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
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
    );
  }
}
