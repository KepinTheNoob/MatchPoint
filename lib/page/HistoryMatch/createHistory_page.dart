import 'package:flutter/material.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/page/home_page.dart';
import 'package:matchpoint/page/HistoryMatch/settingMatchHistory_page.dart';
import 'package:matchpoint/page/teamTabHistory_page.dart';

class CreateHistory extends StatefulWidget {
  const CreateHistory({Key? key}) : super(key: key);

  @override
  State<CreateHistory> createState() => _CreateHistoryState();
}

class _CreateHistoryState extends State<CreateHistory> {
  MatchInfo matchInfo = MatchInfo();
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
        (teamB.listTeam.isNotEmpty);
  }

  // Buat mastiin aja
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0, // hilangkan shadow bawaan
          backgroundColor: const Color(0xFFF3FEFD),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Historical Record",
            style: TextStyle(color: Colors.black),
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
                    size: 16, // sesuaikan ukuran icon
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
                          TextSpan(text: '* A Sports Type Must Be Selected\n'),
                          TextSpan(
                              text:
                                  '* Both Teams Must Be Filled With At Least 1 Member'),
                        ],
                      ),
                    ),
                  )
                ],
              )),
              SizedBox(width: 24),
              ElevatedButton(
                onPressed: canCreateMatch()
                    ? () => {
                          createMatch(),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()))
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
