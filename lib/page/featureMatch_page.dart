import 'package:flutter/material.dart';
import 'package:matchpoint/data.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/model/match_service.dart';
import 'package:matchpoint/page/viewMatchInfo_page.dart';
import 'package:matchpoint/widgets/carousel_widget.dart';
import 'package:matchpoint/widgets/matchCard_widget.dart';

class FeatureMatchPage extends StatelessWidget {
  final MatchService _matchService = MatchService();

  final MatchInfo dummyMatch = MatchInfo(
    id: 'match001',
    date: DateTime.now(),
    location: 'Lapangan Futsal ABC',
    duration: 90,
    startingTime: const TimeOfDay(hour: 19, minute: 30),
    sportType: 'Futsal',
    createdBy: 'user123',
  );

// Dummy Team Kiri
  final Team dummyTeamLeft = Team(
    nameTeam: 'BNCC United',
    picId: '3',
    listTeam: ['Aldi', 'Budi', 'Citra', 'Dina', 'Eka'],
    score: 3,
  );

// Dummy Team Kanan
  final Team dummyTeamRight = Team(
    nameTeam: 'Komputek FC',
    picId: '2',
    listTeam: ['Faisal', 'Gina', 'Hendra'],
    score: 2,
  );

  FeatureMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF0F8FFFE),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Featured Match",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
              indent: MediaQuery.of(context).size.width * 0.03,
              endIndent: MediaQuery.of(context).size.width * 0.03,
            ),
            SizedBox(height: 10),
            CustomCarousel(
              imageUrls: AppData.innerStyleImages,
              isInnerStyle: true,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Match History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
              indent: MediaQuery.of(context).size.width * 0.03,
              endIndent: MediaQuery.of(context).size.width * 0.03,
            ),
            Expanded(
              child: FutureBuilder<List<MatchWithTeams>>(
                future: _matchService.getMatches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No matches found."));
                  }

                  final matches = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final match = matches[index];
                      return matchCard(
                        match: match.match,
                        teamLeft: match.teamA,
                        teamRight: match.teamB,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
