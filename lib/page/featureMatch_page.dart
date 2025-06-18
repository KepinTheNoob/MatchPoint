import 'package:flutter/material.dart';
import 'package:matchpoint/model/match_service.dart';
import 'package:matchpoint/page/matchDetail_page.dart';
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

  DateTime? _startDate;
  DateTime? _endDate;

  List<MatchWithTeams> _filterMatches(List<MatchWithTeams> matches) {
    return matches.where((matchWithTeams) {
      final matchDate = matchWithTeams.match.date;
      final sportType = matchWithTeams.match.sportType;

      if (matchDate == null) return false;

      final inDateRange = (_startDate == null ||
              matchDate
                  .isAfter(_startDate!.subtract(const Duration(days: 1)))) &&
          (_endDate == null ||
              matchDate.isBefore(_endDate!.add(const Duration(days: 1))));

      final matchIsInSelectedSport =
          _selectedSports.isEmpty || _selectedSports.contains(sportType);

      return inDateRange && matchIsInSelectedSport;
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
    'Table Tennis',
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

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate({
    required bool isStart,
  }) async {
    final onlyToday = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? (_startDate ?? onlyToday) : (_endDate ?? onlyToday),
      firstDate: DateTime(2000),
      lastDate: onlyToday,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
            dialogBackgroundColor: const Color(0xFFE0E9E9),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          _selectDate(isStart: true);
                        },
                        icon:
                            const Icon(Icons.calendar_today_outlined, size: 18),
                        label: Text(
                          _startDate != null
                              ? "From: ${_formatDate(_startDate!)}"
                              : "Start Date",
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 1,
                          side: const BorderSide(color: Color(0xff40BBC4)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          _selectDate(isStart: false);
                        },
                        icon:
                            const Icon(Icons.calendar_today_outlined, size: 18),
                        label: Text(
                          _endDate != null
                              ? "To: ${_formatDate(_endDate!)}"
                              : "End Date",
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 1,
                          side: const BorderSide(color: Color(0xff40BBC4)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 42,
                      width: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _startDate = null;
                            _endDate = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffE0F7FA),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.refresh,
                                size: 16, color: Color(0xff40BBC4)),
                            SizedBox(height: 2),
                            Text(
                              'Reset',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff40BBC4),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return FutureBuilder<List<MatchWithTeams>>(
                        future: _matchesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.error_outline,
                                      color: Colors.redAccent, size: 60),
                                  SizedBox(height: 12),
                                  Text(
                                    "Oops! Something went wrong.",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Please try again later.",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.inbox_rounded,
                                      color: Colors.grey, size: 60),
                                  SizedBox(height: 12),
                                  Text(
                                    "No matches found.",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Try creating a match to get started.",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          final matches = snapshot.data!;
                          final filteredMatches = _filterMatches(matches);

                          filteredMatches.sort((a, b) {
                            final dateA = a.match.date;
                            final dateB = b.match.date;

                            if (dateA == null && dateB == null) return 0;
                            if (dateA == null) return 1;
                            if (dateB == null) return -1;
                            return dateB.compareTo(dateA);
                          });

                          if (filteredMatches.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.search_off_rounded,
                                      size: 60, color: Colors.grey),
                                  SizedBox(height: 12),
                                  Text(
                                    "No matches found",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Try using different filters.",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            key: ValueKey(_selectedFilter),
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
                                      builder: (context) => MatchDetail(
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
                        });
                  },
                ),
              ),
            ],
          ),
          if (_scrollProgress > 0.05) ...[
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                    backgroundColor: const Color(0xff40BBC4),
                  ),
                  child: const Icon(Icons.arrow_upward, color: Colors.black),
                ),
              ),
            )
          ],
        ],
      )),
    );
  }
}
