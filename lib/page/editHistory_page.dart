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

class EditHistory extends StatefulWidget {
  final MatchInfo matchInfo;
  final Team teamA;
  final Team teamB;

  const EditHistory({
    super.key,
    required this.matchInfo,
    required this.teamA,
    required this.teamB,
  });

  @override
  State<EditHistory> createState() => _EditHistoryState();
}

class _EditHistoryState extends State<EditHistory> {
  MatchInfo matchInfo = MatchInfo();
  final MatchService _match = MatchService();
  Team teamA = Team();
  Team teamB = Team();

  // update untuk match info
  void updateMatchInfo(MatchInfo newInfo) {
    setState(() {
      matchInfo = newInfo
        ..id = matchInfo.id
        ..createdBy = matchInfo.createdBy;
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

  @override
  void initState() {
    super.initState();
    matchInfo = widget.matchInfo;
    teamA = widget.teamA;
    teamB = widget.teamB;
  }

  bool canEditMatch() {
    return (matchInfo.sportType != null && matchInfo.sportType!.isNotEmpty) &&
        (teamA.listTeam.isNotEmpty) &&
        (teamB.listTeam.isNotEmpty) &&
        (teamA.nameTeam != null) &&
        (teamB.nameTeam != null) &&
        (matchInfo.location != null && matchInfo.location!.trim() != '') &&
        (teamA != widget.teamA ||
            teamB != widget.teamB ||
            matchInfo != widget.matchInfo);
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
            onPressed: () => backButtonMatchDialog(context, 'Edit'),
          ),
          title: const Text(
            "Edit Match",
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
                  color: Colors.grey,
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
          padding: const EdgeInsets.fromLTRB(16, 7, 12, 7),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Icon(
                    canEditMatch()
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_outlined,
                    color: canEditMatch() ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: canEditMatch() ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        children: canEditMatch()
                            ? [
                                TextSpan(text: '* All requirements fullfilled'),
                              ]
                            : [
                                TextSpan(text: '* All Fields Must Be Filled\n'),
                                TextSpan(
                                    text:
                                        '* There is need something different from before'),
                              ],
                      ),
                    ),
                  )
                ],
              )),
              SizedBox(width: 24),
              ElevatedButton(
                onPressed: canEditMatch()
                    ? () async {
                     try {
                      final isConfirmed = await showFinishMatchDialog(context, 'Edit');

                      if (isConfirmed == true) {
                        await _match.updateMatch(matchInfo.id.toString(), matchInfo, teamA, teamB);

                        // toastBool("Successfully edit match", true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                     } catch (e) {
                       toastBool("Internal Server Error", true);
                     }   
                    }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canEditMatch() ? Color(0xff40BBC4) : Colors.grey.shade300,
                ),
                child: Text(
                  'Edit Match',
                  style: TextStyle(
                      color: canEditMatch() ? Colors.white : Colors.grey,
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
              teamA: teamA,
              teamB: teamB,
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
