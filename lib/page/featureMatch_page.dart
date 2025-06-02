import 'package:flutter/material.dart';
import 'package:matchpoint/data.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/model/match_service.dart';
import 'package:matchpoint/page/viewMatchInfo_page.dart';
import 'package:matchpoint/widgets/carousel_widget.dart';
import 'package:matchpoint/widgets/matchCard_widget.dart';

enum FilterType {
  week,
  month,
  year,
  all,
}

class FeatureMatchPage extends StatefulWidget {
  const FeatureMatchPage({super.key});

  @override
  State<FeatureMatchPage> createState() => _FeatureMatchPageState();
}

class _FeatureMatchPageState extends State<FeatureMatchPage> {
  final MatchService _matchService = MatchService();

  FilterType _selectedFilter = FilterType.all;

  List<MatchWithTeams> _filterMatches(
      List<MatchWithTeams> matches, FilterType filter) {
    final now = DateTime.now();

    return matches.where((matchWithTeams) {
      final matchDate = matchWithTeams.match.date;
      if (matchDate == null) return false;

      switch (filter) {
        case FilterType.week:
          final oneWeekAgo = now.subtract(const Duration(days: 7));
          return matchDate.isAfter(oneWeekAgo);
        case FilterType.month:
          return matchDate.month == now.month && matchDate.year == now.year;
        case FilterType.year:
          return matchDate.year == now.year;
        case FilterType.all:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF0F8FFFE),
      body: SafeArea(
        child: Column(
          children: [
            // const Padding(
            //   padding: EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Featured Match",
            //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // Divider(
            //   thickness: 0.5,
            //   color: Colors.black,
            //   indent: MediaQuery.of(context).size.width * 0.03,
            //   endIndent: MediaQuery.of(context).size.width * 0.03,
            // ),
            // SizedBox(height: 10),
            // CustomCarousel(
            //   imageUrls: AppData.innerStyleImages,
            //   isInnerStyle: true,
            // ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: FilterType.values.map((filter) {
                  return FilterChip(
                    label: Text(
                      filter.name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: _selectedFilter == filter
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: _selectedFilter == filter,
                    selectedColor: const Color(0xffD7F8FD),
                    backgroundColor: Colors.grey[100]!.withOpacity(0.5),
                    showCheckmark: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _selectedFilter == filter
                            ? Color(0xff40BBC4)
                            : Colors.grey,
                        width: _selectedFilter == filter ? 2 : 1,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  );
                }).toList(),
              ),
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
                  final filteredMatches =
                      _filterMatches(matches, _selectedFilter);

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredMatches.length,
                    itemBuilder: (context, index) {
                      final match = filteredMatches[index];
                      return matchCard(
                        match: match.match,
                        teamLeft: match.teamA,
                        teamRight: match.teamB,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewMatchInfoPage(
                                matchInfo: match.match,
                                teamA: match.teamA,
                                teamB: match.teamB,
                              ),
                            ),
                          );
                        },
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
