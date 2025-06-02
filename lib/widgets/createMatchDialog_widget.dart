import 'package:flutter/material.dart';
import 'package:matchpoint/page/HistoryMatch/createHistory_page.dart';
import 'package:matchpoint/page/RealTimeMatch/createRealScoring_page.dart';

void showCreateMatchHistoryDialog(BuildContext context) {
  int selectedOption = 0;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Color(0xFFFBFBFB),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Create Match History',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Choose how’d you like to log your match:',
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => setState(() => selectedOption = 0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.scoreboard_outlined),
                    title: const Text('Track Scores Live',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12)),
                    subtitle: const Text(
                      'Live Scoring',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    trailing: Radio<int>(
                      value: 0,
                      groupValue: selectedOption,
                      onChanged: (value) =>
                          setState(() => selectedOption = value!),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => selectedOption = 1),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.history),
                    title: const Text('Record Full Match',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12)),
                    subtitle: const Text('Historical Record',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    trailing: Radio<int>(
                      value: 1,
                      groupValue: selectedOption,
                      onChanged: (value) =>
                          setState(() => selectedOption = value!),
                    ),
                  ),
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
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedOption == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LiveScoringPage()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateHistory()));
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF65558F),
                ),
                child: const Text(
                  'Continue',
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
