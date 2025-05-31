import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchpoint/model/firebase_service.dart';
import 'package:matchpoint/widgets/toast_widget.dart';

void editUsernameDialog({
  required BuildContext context,
  required String currentUsername,
  required void Function(String newUsername) onSave,
}) {
  final TextEditingController controller =
      TextEditingController(text: currentUsername);
  final FirebaseService _auth = FirebaseService();
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: !isLoading,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: const Color(0xFfffffff),
          contentPadding: const EdgeInsets.all(24),
          title: const Text(
            "Edit Username",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else ...[
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: "New Username",
                    ),
                  ),
                ]
              ]),
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
                      "Cancel",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await _auth.editUsername(controller.text);

                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (context.mounted) {
                          toastBool(
                              e.message ?? "Update Username Failed", true);

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //       content: Text('Error: ${e.message}')),
                          // );
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
        );
      });
    },
  );
}
