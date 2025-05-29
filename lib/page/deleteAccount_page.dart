import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matchpoint/widgets/deleteAccount_widget.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: const Color(0xFFF3FEFD),
        title: const Text(
          "Delete Account",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.black12, // Warna border
            height: 1, // Ketebalan border
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deleting your account will result in:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.quicksand(
                          fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(text: '• '),
                        TextSpan(
                          text: 'Permanent lost of your access',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' to your account'),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.quicksand(
                          fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(text: '• '),
                        TextSpan(
                          text: 'Complete removal of all your match histories',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              ', including any saved stats, scores, and match details.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.quicksand(
                          fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(text: '• '),
                        TextSpan(
                          text: 'No possible way to recover',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' this information once deleted.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'This action is irreversible.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'If you’re sure you want to proceed, please confirm by tapping the button below. If you’d like to keep your history, simply cancel this action.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black, // Warna border top
              width: 0.3, // Ketebalan border
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
            20, 0, 20, 20), // padding agar tidak mentok ke pinggir dan bawah
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: () => showDeleteDialog(context),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              splashFactory: NoSplash.splashFactory, // tanpa splash
            ),
            child: const Text(
              'Delete Account',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
