import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/model/match_service.dart';
import 'package:matchpoint/page/RealTimeMatch/inputLiveScoring_page.dart';
import 'package:matchpoint/page/RealTimeMatch/settingMatchRealTime_page.dart';
import 'package:matchpoint/page/home_page.dart';
import 'package:matchpoint/page/teamTab_page.dart';
import 'package:matchpoint/widgets/backButtonMatchDialog_widget.dart';
import 'package:matchpoint/widgets/finishMatchDialog_widget.dart';
import 'package:matchpoint/widgets/toast_widget.dart';

class LiveScoringPage extends StatefulWidget {
  const LiveScoringPage({Key? key}) : super(key: key);

  @override
  State<LiveScoringPage> createState() => _LiveScoringPageState();
}

class _LiveScoringPageState extends State<LiveScoringPage>
    with TickerProviderStateMixin {
  MatchInfo matchInfo = MatchInfo();
  MatchService _match = MatchService();
  Team teamA = Team();
  Team teamB = Team();

  late TabController _tabController;
  bool showInputTab = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void updateMatchInfo(MatchInfo newInfo) {
    setState(() {
      matchInfo = newInfo;
    });
  }

  void updateTeamA(Team newTeam) {
    setState(() {
      teamA = newTeam;
    });
  }

  void updateTeamB(Team newTeam) {
    setState(() {
      teamB = newTeam;
    });
  }

  void updateScoreTeamA(int newScore) {
    setState(() {
      teamA.score = newScore;
    });
  }

  void updateScoreTeamB(int newScore) {
    setState(() {
      teamB.score = newScore;
    });
  }

  void updateDuration(int time) {
    setState(() {
      matchInfo.duration = time;
    });
  }

  bool canCreateMatch() {
    return (matchInfo.sportType != null && matchInfo.sportType!.isNotEmpty) &&
        (teamA.listTeam.isNotEmpty) &&
        (teamB.listTeam.isNotEmpty) &&
        (teamA.nameTeam != null) &&
        (teamB.nameTeam != null) &&
        (matchInfo.location != null || matchInfo.location!.trim() != '');
  }

  void createMatch() {
    print('Match Info:');
    print('Sport Type: ${matchInfo.sportType}');
    print('Date: ${matchInfo.date}');
    print('Location: ${matchInfo.location}');
    print('Duration: ${matchInfo.duration}');
    print('Starting Time: ${matchInfo.startingTime}');

    print('Team 1: ${teamA.nameTeam}');
    print('Pic ID: ${teamA.picId}');
    print('Members: ${teamA.listTeam}');
    print('Score: ${teamA.score}');

    print('Team 2: ${teamB.nameTeam}');
    print('Pic ID: ${teamB.picId}');
    print('Members: ${teamB.listTeam}');
    print('Score: ${teamB.score}');
  }

  void startMatch() {
    createMatch();

    setState(() {
      showInputTab = true;
      _tabController.dispose();
      _tabController = TabController(length: 3, vsync: this);
      _tabController.index = 2;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF3FEFD),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => backButtonMatchDialog(context, 'RealTime'),
        ),
        title: const Text(
          "Live Scoring",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Column(
            children: [
              const Divider(height: 1, thickness: 1, color: Colors.grey),
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xff40BBC4),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  const Tab(icon: Icon(Icons.settings_outlined)),
                  const Tab(icon: Icon(Icons.group)),
                  if (showInputTab) const Tab(icon: Icon(Icons.sports_score)),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF3FEFD),
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 7, 12, 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...(showInputTab
                ? [SizedBox(width: 10)]
                : [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            canCreateMatch()
                                ? Icons.check_circle_outline
                                : Icons.warning_amber_outlined,
                            color: canCreateMatch() ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: canCreateMatch()
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: canCreateMatch()
                                    ? [
                                        TextSpan(
                                            text:
                                                '* All requirements fullfilled'),
                                      ]
                                    : [
                                        TextSpan(
                                            text:
                                                '* All Fields Must Be Filled\n'),
                                        TextSpan(
                                            text:
                                                '* Both Teams Must Be Filled With At Least 1 Member'),
                                      ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
            const SizedBox(width: 24),
            showInputTab
                ? ElevatedButton(
                    onPressed: () async {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser == null) {
                        print("User not logged in");
                        return;
                      }

                      final isConfirmed =
                          await showFinishMatchDialog(context, 'RealTime');

                      if (isConfirmed == true) {
                        matchInfo.createdBy = currentUser.uid;

                        await _match.createMatch(matchInfo, teamA, teamB);
                        toastBool("Successfully create real time match", true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff40BBC4),
                    ),
                    child: const Text(
                      'Finish Match',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: canCreateMatch() ? startMatch : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canCreateMatch()
                          ? const Color(0xff40BBC4)
                          : Colors.grey.shade300,
                    ),
                    child: Text(
                      'Start Match',
                      style: TextStyle(
                        color: canCreateMatch() ? Colors.white : Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SettingsMatch(
            matchInfo: matchInfo,
            onMatchInfoChanged: updateMatchInfo,
          ),
          TeamPageWithTab(
            teamA: teamA,
            teamB: teamB,
            onTeamAChanged: updateTeamA,
            onTeamBChanged: updateTeamB,
            matchType: 'RealTime',
          ),
          if (showInputTab)
            InputLiveScoring(
                teamA: teamA,
                teamB: teamB,
                matchType: 'RealTime',
                sportType: matchInfo.sportType ?? "Custom",
                onUpdateScoreTeamA: (newScore) => updateScoreTeamA(newScore),
                onUpdateScoreTeamB: (newScore) => updateScoreTeamB(newScore),
                onUpdateDuration: (timer) => updateDuration(timer)),
        ],
      ),
    );
  }
}
