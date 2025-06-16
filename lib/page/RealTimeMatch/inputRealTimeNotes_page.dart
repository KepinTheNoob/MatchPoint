import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchNotesTabView extends StatefulWidget {
  final String? teamAName;
  final String? teamBName;
  final TextEditingController matchNotes;
  final TextEditingController teamANotes;
  final TextEditingController teamBNotes;

  const MatchNotesTabView({
    super.key,
    this.teamAName,
    this.teamBName,
    required this.matchNotes,
    required this.teamANotes,
    required this.teamBNotes,
  });

  @override
  State<MatchNotesTabView> createState() => _MatchNotesTabViewState();
}

class _MatchNotesTabViewState extends State<MatchNotesTabView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      FocusScope.of(context).unfocus(); // Close keyboard
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Tutup keyboard
      },
      child: Column(
        children: [
          Container(
            color: const Color(0xFFF3FEFD),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xff40BBC4),
              labelColor: const Color(0xff40BBC4),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.black87,
              unselectedLabelStyle:
                  GoogleFonts.quicksand(fontWeight: FontWeight.w300),
              tabs: [
                const Tab(text: 'Match'),
                Tab(
                    text: widget.teamAName?.isNotEmpty == true
                        ? widget.teamAName
                        : 'Team 1'),
                Tab(
                    text: widget.teamBName?.isNotEmpty == true
                        ? widget.teamBName
                        : 'Team 2'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNoteInput(widget.matchNotes),
                _buildNoteInput(widget.teamANotes),
                _buildNoteInput(widget.teamBNotes),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInput(TextEditingController controller) {
    return Container(
      color: const Color(0xFFF3FEFD),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final currentLength = value.text.characters.length;
              return Text(
                'Current Length: $currentLength / 1024',
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Flexible(
            child: TextField(
              controller: controller,
              maxLength: 1024,
              maxLines: 12,
              textAlign: TextAlign.start,
              style: GoogleFonts.quicksand(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Write your notes here...',
                hintStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xff40BBC4), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                counterText: "", // Hide default counter
              ),
              keyboardType: TextInputType.multiline,
              scrollPhysics: const BouncingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
