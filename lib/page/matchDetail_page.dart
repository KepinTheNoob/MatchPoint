import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/page/editHistory_page.dart';
import 'package:matchpoint/page/home_page.dart';
import 'package:matchpoint/widgets/deleteMatchDialog_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollControllerTeam1 = ScrollController();
    _scrollControllerTeam2 = ScrollController();
  }

  @override
  void dispose() {
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
    final int highestScore = max(teamA.score, teamB.score);

    final timeFormatted = matchInfo.startingTime != null
        ? matchInfo.startingTime!.format(context)
        : "N/A";
    final dateFormatted = matchInfo.date != null
        ? DateFormat('EEEE, dd MMM yyyy').format(matchInfo.date!)
        : "N/A";

    bool isExpanded = false;

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
                final isConfirmed = await deleteMatchDialog(context, matchInfo);
                if (isConfirmed == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditHistory(
                              matchInfo: matchInfo,
                              teamA: teamA,
                              teamB: teamB,
                            )));
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
      body: Column(
        children: [
          // Winner Section
          Expanded(
            child: ListView(padding: EdgeInsets.zero, children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                child: isDraw
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(teamA.nameTeam ?? '-',
                                      style: TextStyle(
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color = Colors.black,
                                          fontSize: 17)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  _buildTeamCircle(teamA),
                                ],
                              ),
                              Text(
                                "DRAW",
                                style: TextStyle(
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 1
                                      ..color = Colors.orange,
                                    fontSize: 20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(teamB.nameTeam ?? '-',
                                      style: TextStyle(
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color = Colors.black,
                                          fontSize: 17)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  _buildTeamCircle(teamB),
                                ],
                              ),
                            ],
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
                  children: [
                    _buildMatchInfo("Sport", matchInfo.sportType ?? "-"),
                    _buildMatchInfo("Date", dateFormatted),
                    _buildMatchInfo("Starting Time", timeFormatted),
                    _buildMatchInfo("Match Duration",
                        "${matchInfo.duration ?? '-'} Minutes"),
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
                                        duration:
                                            const Duration(milliseconds: 200),
                                        turns: isExpanded ? 0.5 : 0,
                                        child: const Icon(
                                            Icons.keyboard_arrow_down,
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
                                    padding: const EdgeInsets.fromLTRB(
                                        14, 8, 14, 12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF9FFFF),
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(10)),
                                    ),
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
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Tabs
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1)),
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
              SizedBox(
                height: 370,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTeamDetail(matchInfo, teamA, teamA.nameTeam ?? '',
                        teamB.score, _scrollControllerTeam1),
                    _buildTeamDetail(matchInfo, teamB, teamA.nameTeam ?? '',
                        teamA.score, _scrollControllerTeam2),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamDetail(MatchInfo matchInfo, Team team, String nameTeamA,
      int rivalScore, ScrollController controller) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
          const SizedBox(height: 12),

          // Label
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

          // Scrollable List Member
          Column(
            children: [
              // List member scrollable
              Container(
                height: 130, // Atur sesuai kebutuhan
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                child: Scrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: controller,
                    itemCount: team.listTeam.length,
                    itemBuilder: (context, index) {
                      final member = team.listTeam[index];
                      return Container(
                        // margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                              color: Colors.black26, // warna border
                              width: 1.0,
                            ))
                            // borderRadius: BorderRadius.circular(6),
                            ),
                        child: Text(
                          member,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
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
                  backgroundColor: matchInfo.matchNotes?.isNotEmpty == true
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
                    matchInfo.matchNotes?.isNotEmpty == true
                        ? matchInfo.matchNotes!
                        : '',
                  );
                },
                icon: const Icon(Icons.visibility),
                label: Text(
                  matchInfo.matchNotes?.isNotEmpty == true
                      ? "View Notes"
                      : "No Notes",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFFAFEFD),
        child: FractionallySizedBox(
          heightFactor: 0.6,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(14),
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

              // Content
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
                    : Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            content,
                            style: const TextStyle(fontSize: 15, height: 1.4),
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
