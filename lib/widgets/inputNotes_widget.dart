import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<Map<String, String?>?> showMatchNotesDialog(
  BuildContext context, {
  String? teamAName,
  String? teamBName,
  String? initialMatchNote,
  String? initialTeamANote,
  String? initialTeamBNote,
}) async {
  final matchController = TextEditingController(text: initialMatchNote ?? '');
  final teamAController = TextEditingController(text: initialTeamANote ?? '');
  final teamBController = TextEditingController(text: initialTeamBNote ?? '');

  return await showDialog<Map<String, String?>>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: DefaultTabController(
          length: 3,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: const Color(0xff40BBC4),
                    labelColor: const Color(0xff40BBC4),
                    labelStyle: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                    tabs: [
                      const Tab(text: 'Match'),
                      Tab(
                          text: (teamAName ?? '').isNotEmpty
                              ? teamAName
                              : 'Team 1'),
                      Tab(
                          text: (teamBName ?? '').isNotEmpty
                              ? teamBName
                              : 'Team 2'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildNoteInput(matchController),
                        _buildNoteInput(teamAController),
                        _buildNoteInput(teamBController),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, {
                            'matchNotes': matchController.text.trim(),
                            'teamANotes': teamAController.text.trim(),
                            'teamBNotes': teamBController.text.trim(),
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF40BBC4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                          shadowColor: Colors.black26,
                        ),
                        icon: const Icon(
                          Icons.save_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Save & Close',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildNoteInput(TextEditingController controller) {
  return TextField(
    controller: controller,
    minLines: 5,
    maxLines: 5,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      hintText: 'Write your notes here...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(12),
      filled: true,
      fillColor: const Color(0xffF8FFFE),
    ),
  );
}
