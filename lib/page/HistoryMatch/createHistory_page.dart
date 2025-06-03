import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/model/match_service.dart';
import 'package:matchpoint/page/home_page.dart';
import 'package:matchpoint/page/HistoryMatch/settingMatchHistory_page.dart';
import 'package:matchpoint/page/teamTab_page.dart';
import 'package:matchpoint/widgets/backButtonMatchDialog_widget.dart';
import 'package:matchpoint/widgets/finishMatchDialog_widget.dart';
import 'package:matchpoint/widgets/toast_widget.dart';

class CreateHistory extends StatefulWidget {
  const CreateHistory({Key? key}) : super(key: key);

  @override
  State<CreateHistory> createState() => _CreateHistoryState();
}

class _CreateHistoryState extends State<CreateHistory> {
  MatchInfo matchInfo = MatchInfo();
  MatchService _match = MatchService();
  Team teamA = Team();
  Team teamB = Team();

  // update untuk match info
  void updateMatchInfo(MatchInfo newInfo) {
    setState(() {
      matchInfo = newInfo;
    });
  }

  // update team A
  void updateTeamA(Team newTeam) {
    setState(() {
      teamA = newTeam;
    });
  }

  // update team B
  void updateTeamB(Team newTeam) {
    setState(() {
      teamB = newTeam;
    });
  }

  bool canCreateMatch() {
    return (matchInfo.sportType != null && matchInfo.sportType!.isNotEmpty) &&
        (teamA.listTeam.isNotEmpty) &&
        (teamB.listTeam.isNotEmpty) &&
        (teamA.nameTeam != null) &&
        (teamB.nameTeam != null) &&
        (matchInfo.location != null);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF3FEFD),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => backButtonMatchDialog(context, 'History'),
          ),
          title: const Text(
            "Historical Record",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          foregroundColor: Colors.black,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey, // warna border bottom
                ),
                const TabBar(
                  indicatorColor: Color(0xff40BBC4),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(icon: Icon(Icons.settings_outlined)),
                    Tab(icon: Icon(Icons.group)),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF3FEFD),
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 7, 12, 12),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(text: '* All Fields Must Be Filled\n'),
                          TextSpan(text: '* At Least 1 Member in Each Team is Required'),
                        ],
                      ),
                    ),
                  )
                ],
              )),
              SizedBox(width: 24),
              ElevatedButton(
                onPressed: canCreateMatch()
                    ? () async {
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser == null) {
                          print("User not logged in");
                          return;
                        }
                        final isConfirmed =
                            await showFinishMatchDialog(context, 'History');

                        if (isConfirmed == true) {
                          matchInfo.createdBy = currentUser.uid;

                          await _match.createMatch(matchInfo, teamA, teamB);

                          toastBool(
                              "Successfully create historical match", true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canCreateMatch()
                      ? Color(0xff40BBC4)
                      : Colors.grey.shade300,
                ),
                child: Text(
                  'Create Match',
                  style: TextStyle(
                      color: canCreateMatch() ? Colors.white : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
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
              matchType: 'history',
            ),
          ],
        ),
      ),
    );
  }
}
