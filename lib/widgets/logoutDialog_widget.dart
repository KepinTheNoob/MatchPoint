import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchpoint/page/login_page.dart';
import 'package:matchpoint/widgets/toast_widget.dart';

void showLogOutDialog(BuildContext context) {
  bool isChecked = false;
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: !isLoading,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            backgroundColor: const Color(0xFfffffff),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else ...[
                  const Center(
                    child: Icon(Icons.logout, size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Logout Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Are you sure want to logout? Once you logout you need to login again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Text('Are you sure?'),
                      ),
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(
                    height: 0.1,
                    color: Colors.black54,
                  )
                ],
              ],
            ),
            actions: isLoading
                ? [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Please wait',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Color(0xFf65558F),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: isChecked
                          ? () async {
                              setState(() {
                                isLoading = true;
                              });
                              await FirebaseAuth.instance.signOut();
                              if (context.mounted) {
                                toastBool("Logout Success", true);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              }
                            }
                          : null,
                      style: TextButton.styleFrom(
                        foregroundColor: isChecked ? Colors.red : Colors.grey,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
          );
        },
      );
    },
  );
}
