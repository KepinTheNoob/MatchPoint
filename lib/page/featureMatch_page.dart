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
      final sportType = matchWithTeams.match.sportType;
      if (matchDate == null) return false;

      final matchIsInFilterRange = switch (filter) {
        FilterType.week =>
          matchDate.isAfter(now.subtract(const Duration(days: 7))),
        FilterType.month =>
          matchDate.month == now.month && matchDate.year == now.year,
        FilterType.year => matchDate.year == now.year,
        FilterType.all => true,
      };

      final matchIsInSelectedSport =
          _selectedSports.isEmpty || _selectedSports.contains(sportType);

      return matchIsInFilterRange && matchIsInSelectedSport;
    }).toList();
  }

  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  Future<List<MatchWithTeams>>? _matchesFuture;
  Set<String> _selectedSports = {};
  final List<String> sportTypes = [
    'Custom',
    'Football',
    'Basketball',
    'Tennis',
    'Badminton',
    'Tennis Table',
    'Volleyball',
    'Boxing'
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _matchesFuture = _matchService.getMatches();

    _scrollController.addListener(() {
      if (!_scrollController.hasClients ||
          !_scrollController.position.hasContentDimensions) {
        return;
      }
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      double progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      setState(() {
        _scrollProgress = progress.isNaN ? 0.0 : progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF0F8FFFE),
      body: SafeArea(
          child: Stack(
        children: [
          Column(
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
              // ),Padding(
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: sportTypes.map((sport) {
                      final isSelected = _selectedSports.contains(sport);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(
                            sport,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xffD7F8FD),
                          backgroundColor: const Color(0xffF3FEFD),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xff40BBC4)
                                  : Colors.grey,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSports.add(sport);
                              } else {
                                _selectedSports.remove(sport);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Match History",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ),
                child: LinearProgressIndicator(
                  value: _scrollProgress,
                  backgroundColor: Colors.grey[300],
                  color: Color(0xff40BBC4),
                  minHeight: 4,
                ),
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
                      backgroundColor: const Color(0xffF3FEFD),
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
                  future: _matchesFuture,
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
                      controller: _scrollController,
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
          if (_scrollProgress > 0.05)
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(14),
                  backgroundColor: Color(0xff40BBC4),
                ),
                child: const Icon(Icons.arrow_upward, color: Colors.black),
              ),
            ),
        ],
      )),
    );
  }
}
