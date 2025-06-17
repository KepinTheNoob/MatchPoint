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
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          // ⬅️ Ini memungkinkan konten tetap bisa geser jika overflow saat keyboard muncul
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          indicatorColor: const Color(0xff40BBC4),
                          labelColor: const Color(0xff40BBC4),
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold),
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
                        const SizedBox(height: 12),
                        Flexible(
                          fit: FlexFit.loose,
                          child: SizedBox(
                            height: 200,
                            child: TabBarView(
                              children: [
                                _buildNoteInput(matchController),
                                _buildNoteInput(teamAController),
                                _buildNoteInput(teamBController),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
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
                      ),
                      icon: const Icon(Icons.save_outlined,
                          size: 18, color: Colors.white),
                      label: const Text(
                        'Save & Close',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
  final maxLength = 1024;
  final ValueNotifier<int> charCount = ValueNotifier(controller.text.length);

  controller.addListener(() {
    charCount.value = controller.text.length;
  });

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: charCount,
          builder: (context, value, _) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Current length: $value / $maxLength characters',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
        TextField(
          controller: controller,
          minLines: 6,
          maxLines: 6,
          maxLength: maxLength,
          keyboardType: TextInputType.multiline,
          buildCounter: (_,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          decoration: InputDecoration(
            hintText: 'Write your notes here...',
            hintStyle: const TextStyle(
              color: Colors.grey, // ⬅️ ini mengatur warna hint menjadi abu-abu
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.all(12),
            filled: true,
            fillColor: const Color(0xffF8FFFE),
          ),
        ),
      ],
    ),
  );
}
