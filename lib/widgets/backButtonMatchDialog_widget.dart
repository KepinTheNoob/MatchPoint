import 'package:flutter/material.dart';
import 'package:matchpoint/page/home_page.dart';

void backButtonMatchDialog(BuildContext context, String type) {
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
                const Center(
                  child: Icon(Icons.backspace_outlined, size: 40),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    (type == 'RealTime')
                        ? 'End Match'
                        : (type == 'History')
                            ? 'Delete Match'
                            : 'Delete Edit',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'This action cannot be undone. All match data, including team names and scores, will be permanently lost.',
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    : null, // Disable if not checked
                style: TextButton.styleFrom(
                  foregroundColor: isChecked ? Colors.red : Colors.grey,
                ),
                child: const Text(
                  'Confirm',
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
