import 'dart:async';
import 'package:flutter/material.dart';
import 'package:matchpoint/model/match_model.dart';

class InputLiveScoring extends StatefulWidget {
  final Team teamA;
  final Team teamB;
  final String sportType;
  final String matchType;

  final Function(int) onUpdateScoreTeamA;
  final Function(int) onUpdateScoreTeamB;
  final Function(int) onUpdateDuration;

  const InputLiveScoring({
    Key? key,
    required this.teamA,
    required this.teamB,
    required this.sportType,
    required this.matchType,
    required this.onUpdateScoreTeamA,
    required this.onUpdateScoreTeamB,
    required this.onUpdateDuration,
  }) : super(key: key);

  @override
  State<InputLiveScoring> createState() => _InputLiveScoringState();
}

class _InputLiveScoringState extends State<InputLiveScoring>
    with AutomaticKeepAliveClientMixin {
  int scoreRed = 0;
  int scoreBlue = 0;
  Duration matchDuration = Duration.zero;
  Timer? _timer;
  int _lastUpdatedMinute = 0;
  bool isRunning = true;

  int? _pressedAreaIndexRed;
  bool? _pressedIsRightRed;

  int? _pressedAreaIndexBlue;
  bool? _pressedIsRightBlue;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  bool get wantKeepAlive => true;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRunning) return;

      setState(() {
        matchDuration += const Duration(seconds: 1);

        // Hitung menit yang sedang berjalan
        int currentMinute = matchDuration.inMinutes;

        if (currentMinute != _lastUpdatedMinute) {
          _lastUpdatedMinute = currentMinute;
          widget.onUpdateDuration(currentMinute);
        }
      });
    });
  }

  void _toggleTimer() {
    setState(() {
      isRunning = !isRunning;
    });
  }

  void _updateScore(bool isRedTeam, int incrementAmount) {
    setState(() {
      if (isRedTeam) {
        scoreRed += incrementAmount;
        if (scoreRed < 0) scoreRed = 0;
        widget.onUpdateScoreTeamA(scoreRed);
      } else {
        scoreBlue += incrementAmount;
        if (scoreBlue < 0) scoreBlue = 0;
        widget.onUpdateScoreTeamB(scoreBlue);
      }
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget buildScorePanel({
    required Color color,
    required String teamName,
    required int score,
    required bool isTop,
    required bool isRedTeam,
    required int? pressedAreaIndex,
    required bool? pressedIsRight,
    required Function(int, bool) onPressArea,
  }) {
    final bool isBasketball = widget.sportType.toLowerCase() == "basketball";

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final localX = details.localPosition.dx;
              final localY = details.localPosition.dy;

              final isRight = localX > width / 2;

              if (isBasketball) {
                final thirdHeight = height / 3;
                int amount = 1;

                if (localY < thirdHeight) {
                  amount = 1;
                } else if (localY < 2 * thirdHeight) {
                  amount = 2;
                } else {
                  amount = 3;
                }

                onPressArea(amount, isRight); // Pemisahan state tiap tim
                _updateScore(isRedTeam, isRight ? amount : -amount);
              } else {
                _updateScore(isRedTeam, isRight ? 1 : -1);
              }
            },
            child: Stack(
              children: [
                Container(
                  color: color,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isTop)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            teamName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      Expanded(
                        child: Center(
                          child: Text(
                            score.toString(),
                            style: const TextStyle(
                                fontSize: 80, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (!isTop)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            teamName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),

                // Left side indicators (-1, -2, -3)
                if (isBasketball) ...[
                  Positioned(
                    top: 16,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: pressedAreaIndex == 1 && pressedIsRight == false
                            ? Colors.black.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text('-1',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 10,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: pressedAreaIndex == 2 && pressedIsRight == false
                            ? Colors.black.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text('-2',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: pressedAreaIndex == 3 && pressedIsRight == false
                            ? Colors.black.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text('-3',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),

                  // Right side indicators (+1, +2, +3)
                  Positioned(
                    top: 16,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: pressedAreaIndex == 1 && pressedIsRight == true
                            ? Colors.black.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text('+1',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight / 2 - 10,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: pressedAreaIndex == 2 && pressedIsRight == true
                            ? Colors.black.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text('+2',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: pressedAreaIndex == 3 && pressedIsRight == true
                            ? Colors.black.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text('+3',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
                if (!isBasketball)
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 40),
                          onPressed: () => _updateScore(isRedTeam, -1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 40),
                          onPressed: () => _updateScore(isRedTeam, 1),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3FEFD),
      body: Stack(
        children: [
          Column(
            children: [
              buildScorePanel(
                color: const Color(0xff68E8FF),
                teamName: widget.teamA.nameTeam ?? "Team A",
                score: scoreRed,
                isTop: true,
                isRedTeam: true,
                pressedAreaIndex: _pressedAreaIndexRed,
                pressedIsRight: _pressedIsRightRed,
                onPressArea: (area, isRight) {
                  setState(() {
                    _pressedAreaIndexRed = area;
                    _pressedIsRightRed = isRight;
                  });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        _pressedAreaIndexRed = null;
                      });
                    }
                  });
                },
              ),
              buildScorePanel(
                color: const Color(0xffFF6868),
                teamName: widget.teamB.nameTeam ?? "Team B",
                score: scoreBlue,
                isTop: false,
                isRedTeam: false,
                pressedAreaIndex: _pressedAreaIndexBlue,
                pressedIsRight: _pressedIsRightBlue,
                onPressArea: (area, isRight) {
                  setState(() {
                    _pressedAreaIndexBlue = area;
                    _pressedIsRightBlue = isRight;
                  });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        _pressedAreaIndexBlue = null;
                      });
                    }
                  });
                },
              ),
            ],
          ),
          // Timer
          Positioned.fill(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.38,
                padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, blurRadius: 4)
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(matchDuration),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                      onPressed: _toggleTimer,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // bottomNavigationBar: Container(
  //   decoration: const BoxDecoration(
  //     color: Color(0xFFF3FEFD),
  //     border: Border(
  //       top: BorderSide(color: Colors.grey, width: 1),
  //     ),
  //   ),
  //   padding: const EdgeInsets.fromLTRB(16, 7, 12, 12),
  //   child: Row(
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       TextButton(
  //         onPressed: () {
  //           // Bisa diarahkan ke pengaturan match
  //         },
  //         child: const Row(
  //           children: [
  //             Icon(Icons.settings_outlined, size: 26, color: Colors.black),
  //             SizedBox(width: 4),
  //             Text(
  //               'Match Settings',
  //               style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //       ),
  //       TextButton(
  //         onPressed: _showFinishConfirmation,
  //         child: const Row(
  //           children: [
  //             Text(
  //               'Finish Early',
  //               style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(width: 4),
  //             Icon(Icons.sports_score, size: 26, color: Colors.black),
  //           ],
  //         ),
  //       ),
  //     ],
  //   ),
  // ),
}
