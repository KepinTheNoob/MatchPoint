import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/widgets/inputTeam_widget.dart';

class TeamPageWithTab extends StatefulWidget {
  final Team teamA;
  final Team teamB;
  final ValueChanged<Team> onTeamAChanged;
  final ValueChanged<Team> onTeamBChanged;
  final String matchType;

  const TeamPageWithTab({
    Key? key,
    required this.teamA,
    required this.teamB,
    required this.onTeamAChanged,
    required this.onTeamBChanged,
    required this.matchType,
  }) : super(key: key);

  @override
  State<TeamPageWithTab> createState() => _TeamPageWithTabState();
}

class _TeamPageWithTabState extends State<TeamPageWithTab> {
  Team team1Data = Team();
  Team team2Data = Team();
  String matchType = 'history';

  @override
  void initState() {
    super.initState();
    team1Data = widget.teamA;
    team2Data = widget.teamB;
    matchType = widget.matchType;
  }

  void updateTeamData(int teamIndex, Team data) {
    setState(() {
      if (teamIndex == 1) {
        team1Data = data;
      } else {
        team2Data = data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Material(
              color: const Color(0xFFF3FEFD),
              child: TabBar(
                indicatorColor: const Color(0xff40BBC4),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: "Team 1"),
                  Tab(text: "Team 2"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TeamInputSection(
                    initialData: widget.teamA,
                    onChanged: widget.onTeamAChanged,
                    matchType: matchType,
                  ),
                  TeamInputSection(
                    initialData: widget.teamB,
                    onChanged: widget.onTeamBChanged,
                    matchType: matchType,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
