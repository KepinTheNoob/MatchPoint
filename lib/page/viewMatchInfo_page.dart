import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/page/home_page.dart';
import 'package:matchpoint/widgets/deleteMatchDialog_widget.dart';

class ViewMatchInfoPage extends StatelessWidget {
  final MatchInfo matchInfo;
  final Team teamA;
  final Team teamB;

  const ViewMatchInfoPage({
    super.key,
    required this.matchInfo,
    required this.teamA,
    required this.teamB,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDraw = teamA.score == teamB.score;
    final bool isTeamAWinner = teamA.score > teamB.score;
    final timeFormatted = matchInfo.startingTime != null
        ? matchInfo.startingTime!.format(context)
        : "N/A";
    final dateFormatted = matchInfo.date != null
        ? DateFormat('EEEE, dd MMM yyyy').format(matchInfo.date!)
        : "N/A";

    return Scaffold(
      backgroundColor: Color(0xffF8FFFE),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.black12,
            height: 1,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF3FEFD),
          border: Border(
            top: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 7, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () async {
                final isConfirmed = await deleteMatchDialog(context, matchInfo);

                if (isConfirmed == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
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
            // TextButton(
            //   onPressed: () {},
            //   child: const Row(
            //     children: [
            //       Text(
            //         'Edit Match',
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold),
            //       ),
            //       SizedBox(width: 6),
            //       Icon(Icons.edit, size: 24, color: Colors.black),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team section
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: _buildScoreColumn(
                      teamA.score, teamB.score, isTeamAWinner, isDraw),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTeamColumn(
                      teamA.nameTeam ?? "Team A",
                      "assets/profile/${teamA.picId}.png",
                      isTeamAWinner ? "WIN" : "LOSE",
                      teamA.score,
                      isTeamAWinner ? Colors.green : Colors.red,
                      teamA.listTeam,
                    ),
                    const SizedBox(width: 120),
                    _buildTeamColumn(
                      teamB.nameTeam ?? "Team B",
                      "assets/profile/${teamB.picId}.png",
                      !isTeamAWinner ? "WIN" : "LOSE",
                      teamB.score,
                      !isTeamAWinner ? Colors.green : Colors.red,
                      teamB.listTeam,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Divider(
              thickness: 0.5,
              color: Colors.black,
              indent: MediaQuery.of(context).size.width * 0.001,
              endIndent: MediaQuery.of(context).size.width * 0.001,
            ),

            // Info section
            _buildMatchInfo("Sport", matchInfo.sportType ?? "-"),
            _buildMatchInfo("Date", dateFormatted),
            _buildMatchInfo("Starting Time", timeFormatted),
            _buildMatchInfo(
                "Match Duration", "${matchInfo.duration ?? '-'} Minutes"),
            _buildMatchInfo("Location", matchInfo.location ?? "-",
                highlight: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn(
    String name,
    String imageAsset,
    String result,
    int score,
    Color color,
    List<String> members,
  ) {
    return Column(
      children: [
        Text(
            (name ?? "?? Team").length > 14
                ? '${name!.substring(0, 10)}...'
                : name ?? "?? Team",
            style: TextStyle(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = Colors.black,
                fontSize: 18)),
        const SizedBox(height: 8),
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
            radius: 40,
            backgroundImage: AssetImage(imageAsset),
          ),
        ),
        const SizedBox(height: 8),
        for (var member in members) ...[
          Text(
            member.length > 10 ? '${member.substring(0, 10)}...' : member,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8)
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildScoreColumn(
      int scoreA, int scoreB, bool isTeamAWinner, bool isDraw) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isDraw ? "DRAW" : (isTeamAWinner ? "WIN" : "LOSE"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDraw
                    ? Colors.orange
                    : (isTeamAWinner ? Colors.green : Colors.red),
              ),
            ),
            Text(
              scoreA.toString(),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDraw
                    ? Colors.orange
                    : (isTeamAWinner ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        const Text(
          ":",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isDraw ? "DRAW" : (!isTeamAWinner ? "WIN" : "LOSE"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDraw
                    ? Colors.orange
                    : (!isTeamAWinner ? Colors.green : Colors.red),
              ),
            ),
            Text(
              scoreB.toString(),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDraw
                    ? Colors.orange
                    : (!isTeamAWinner ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMatchInfo(String label, String value, {bool? highlight}) {
    final bool isHighlight = highlight ?? (value.length > 30);

    if (isHighlight) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                )),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ),
            Expanded(
              flex: 4,
              child: Text(
                value,
                textAlign: TextAlign.right,
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
  }
}
