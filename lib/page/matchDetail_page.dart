import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/model/match_service.dart';
import 'package:matchpoint/page/editHistory_page.dart';
import 'package:matchpoint/page/home_page.dart';
import 'package:matchpoint/widgets/deleteMatchDialog_widget.dart';
import 'package:matchpoint/widgets/toast_widget.dart';

class MatchDetail extends StatefulWidget {
  final MatchInfo matchInfo;
  final Team teamA;
  final Team teamB;

  const MatchDetail({
    super.key,
    required this.matchInfo,
    required this.teamA,
    required this.teamB,
  });

  @override
  State<MatchDetail> createState() => _MatchDetailState();
}

class _MatchDetailState extends State<MatchDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollControllerTeam1;
  late ScrollController _scrollControllerTeam2;

  void _handleTabSelection() {
    setState(() {
      // Biarkan kosong, tujuannya hanya untuk memicu build ulang
      // agar widget yang benar ditampilkan di bawah TabBar.
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _scrollControllerTeam1 = ScrollController();
    _scrollControllerTeam2 = ScrollController();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _scrollControllerTeam1.dispose();
    _scrollControllerTeam2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamA = widget.teamA;
    final teamB = widget.teamB;
    final matchInfo = widget.matchInfo;
    final bool isDraw = teamA.score == teamB.score;
    final bool isTeamAWinner = teamA.score > teamB.score;

    final timeFormatted = matchInfo.startingTime != null
        ? matchInfo.startingTime!.format(context)
        : "N/A";
    final dateFormatted = matchInfo.date != null
        ? DateFormat('EEEE, dd MMM yyyy').format(matchInfo.date!)
        : "N/A";

    bool isExpanded = false;

    final List<Widget> tabContents = [
      _buildTeamDetail(matchInfo, teamA, teamA.nameTeam ?? '', teamB.score,
          _scrollControllerTeam1),
      _buildTeamDetail(matchInfo, teamB, teamA.nameTeam ?? '', teamA.score,
          _scrollControllerTeam2),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF8FFFE),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: const Color(0xFFF3FEFD),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Match Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, thickness: 1, color: Colors.black12),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF3FEFD),
          border: Border(top: BorderSide(color: Colors.grey, width: 1)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 7, 12, 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                try {
                  final isConfirmed =
                      await deleteMatchDialog(context, matchInfo);

                  if (isConfirmed == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  }
                } catch (e) {
                  toastBool("Internal Server Error", true);
                  print(e);
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.delete_forever_outlined,
                      size: 26, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    'Delete Match',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                try {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditHistory(
                                matchInfo: matchInfo,
                                teamA: teamA,
                                teamB: teamB,
                              )));
                } catch (e) {
                  toastBool("Internal Server Error", true);
                }
              },
              child: const Row(
                children: [
                  Text(
                    'Edit Match',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.edit, size: 24, color: Colors.black),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // Menggunakan SingleChildScrollView sebagai parent
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            child: isDraw
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              truncateWithEllipsis(teamA.nameTeam ?? '-'),
                              style: TextStyle(
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = Colors.black,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            _buildTeamCircle(teamA),
                          ],
                        ),
                      ),
                      // DRAW Text di tengah layar
                      Container(
                        width: 80, // atur lebar sesuai kebutuhan
                        alignment: Alignment.center,
                        child: Text(
                          "DRAW",
                          style: TextStyle(
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1
                              ..color = Colors.orange,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              truncateWithEllipsis(teamB.nameTeam ?? '-'),
                              style: TextStyle(
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = Colors.black,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            _buildTeamCircle(teamB),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      _buildTeamCircle(isTeamAWinner ? teamA : teamB),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "WINNER ",
                                style: TextStyle(
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 1
                                      ..color = Colors.green,
                                    fontSize: 20),
                              ),
                              Icon(Icons.celebration, color: Colors.green),
                            ],
                          ),
                          Text(
                            isTeamAWinner
                                ? teamA.nameTeam ?? "-"
                                : teamB.nameTeam ?? "-",
                            style: TextStyle(
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.2
                                  ..color = Colors.green,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),

          const Divider(),

          // Match Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMatchInfo("Sport", matchInfo.sportType ?? "-"),
                _buildMatchInfo("Date", dateFormatted),
                _buildMatchInfo("Starting Time", timeFormatted),
                _buildMatchInfo(
                    "Match Duration", "${matchInfo.duration ?? '-'} Minutes"),
                _buildMatchInfo("Location", matchInfo.location ?? "-"),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () =>
                                setState(() => isExpanded = !isExpanded),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                color: isExpanded
                                    ? const Color(0xFFE0F7F7)
                                    : const Color(0xFFF3FEFD),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.note_alt_outlined,
                                      color: Colors.black54),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Match Notes',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const Spacer(),
                                  AnimatedRotation(
                                    duration: const Duration(milliseconds: 200),
                                    turns: isExpanded ? 0.5 : 0,
                                    child: const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Animated content with AnimatedSize
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: Visibility(
                              visible: isExpanded,
                              maintainState: true,
                              maintainAnimation: true,
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.fromLTRB(14, 8, 14, 12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF9FFFF),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10),
                                  ),
                                ),
                                // 1. Batasi tinggi maksimal container.
                                // Nilai 250.0 ini adalah perkiraan untuk 12-14 baris teks.
                                // Anda bisa menyesuaikannya sesuai kebutuhan.
                                constraints: const BoxConstraints(
                                  maxHeight: 250.0,
                                ),
                                child: Scrollbar(
                                  // 2. (Opsional) Tambahkan Scrollbar untuk UX yang lebih baik
                                  child: SingleChildScrollView(
                                    // 3. Bungkus Text dengan ini agar bisa di-scroll
                                    child: Text(
                                      matchInfo.matchNotes?.isNotEmpty == true
                                          ? matchInfo.matchNotes!
                                          : 'No notes available.',
                                      style: const TextStyle(
                                          fontSize: 14, height: 1.4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black12, width: 1)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xff40BBC4),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: "Team 1"),
                Tab(text: "Team 2"),
              ],
            ),
          ),

          // Team Details
          tabContents[_tabController.index],
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  String truncateWithEllipsis(String text, {int maxLength = 14}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  Widget _buildMatchInfo(String label, String value) {
    final bool isLongText = value.length > 26;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: isLongText
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTeamDetail(MatchInfo matchInfo, Team team, String nameTeamA,
      int rivalScore, ScrollController controller) {
    final members = team.listTeam;
    final itemHeight = 43.0;
    final visibleCount = members.length >= 4 ? 4 : members.length;
    final listHeight = itemHeight * visibleCount;

    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage:
                      AssetImage("assets/profile/${team.picId}.png"),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.nameTeam ?? "Team",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "${team.score} Points",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: team.score < rivalScore
                          ? Colors.red
                          : team.score > rivalScore
                              ? Colors.green
                              : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Team Members:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.keyboard_arrow_up, size: 20),
                      onPressed: () {
                        controller.animateTo(
                          controller.offset - 50,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                      onPressed: () {
                        controller.animateTo(
                          controller.offset + 50,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: listHeight,
              child: Scrollbar(
                controller: controller,
                thumbVisibility: members.length > 4,
                child: ListView.separated(
                  controller: controller,
                  physics: members.length > 4
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                const Color(0xFF40BBC4).withOpacity(0.2),
                            radius: 14,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF40BBC4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              member,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.note_alt_outlined, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text(
                    '${(team.nameTeam != null && team.nameTeam!.length > 14) ? team.nameTeam!.substring(0, 14) + '...' : team.nameTeam ?? '-'} Notes',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: (team.nameTeam == nameTeamA
                          ? (matchInfo.teamANotes?.isNotEmpty == true)
                          : (matchInfo.teamBNotes?.isNotEmpty == true))
                      ? const Color(0xFF40BBC4)
                      : Colors.grey[400],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  showNotesDialog(
                    context,
                    '${team.nameTeam ?? '-'} Notes',
                    team.nameTeam == nameTeamA
                        ? (matchInfo.teamANotes?.isNotEmpty == true
                            ? matchInfo.teamANotes!
                            : '')
                        : (matchInfo.teamBNotes?.isNotEmpty == true
                            ? matchInfo.teamBNotes!
                            : ''),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: Text(
                  (team.nameTeam == nameTeamA
                          ? (matchInfo.teamANotes?.isNotEmpty == true)
                          : (matchInfo.teamBNotes?.isNotEmpty == true))
                      ? "View Notes"
                      : "No Notes",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCircle(Team team) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: CircleAvatar(
        radius: 42,
        backgroundImage: AssetImage("assets/profile/${team.picId}.png"),
      ),
    );
  }

  void showNotesDialog(BuildContext context, String title, String content) {
    bool isEmpty = content.trim().isEmpty;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFFAFEFD),
        child: FractionallySizedBox(
          heightFactor: 0.6,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: const BoxDecoration(
                  color: Color(0xFF40BBC4),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    const Icon(Icons.notes, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.info_outline,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              "No notes available.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Scrollbar(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              content,
                              style: const TextStyle(fontSize: 15, height: 1.4),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
