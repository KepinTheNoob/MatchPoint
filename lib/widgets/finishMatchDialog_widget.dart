import 'package:flutter/material.dart';

Future<bool?> showFinishMatchDialog(BuildContext context, String type) {
  bool isChecked = false;
  bool isLoading = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: !isLoading,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            backgroundColor: const Color(0xFFFFFFFF),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  const Center(child: Icon(Icons.sports_score, size: 40)),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      (type == 'History')
                          ? 'Create Match'
                          : (type == 'Edit')
                              ? 'Edit Match'
                              : 'Finish Match',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'The score added to each team will be based on the current points',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: Text('Are you sure?')),
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
                  const Divider(height: 0.1, color: Colors.black54),
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
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Color(0xFF65558F),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: isChecked
                          ? () {
                              Navigator.pop(context, true);
                            }
                          : null,
                      style: TextButton.styleFrom(
                        foregroundColor:
                            isChecked ? const Color(0xff40BBC4) : Colors.grey,
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
