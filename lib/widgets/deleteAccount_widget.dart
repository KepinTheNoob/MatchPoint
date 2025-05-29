import 'package:flutter/material.dart';
import 'package:matchpoint/page/login_page.dart';

void showDeleteDialog(BuildContext context) {
  bool isChecked = false;
  showDialog(
    context: context,
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
                const Center(
                  child: Icon(Icons.person_remove, size: 40),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Delete Account?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Warning: This action is irreversible.',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'I understand, my account and data will be permanently deleted.',
                      ),
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
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Color(0xFf65558F), fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: isChecked
                    ? () {
                        // TODO
                        // Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }
                    : null,
                style: TextButton.styleFrom(
                  foregroundColor: isChecked ? Colors.red : Colors.grey,
                ),
                child: const Text(
                  'Delete',
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
