import 'dart:async';
import 'package:flutter/material.dart';

class InputLiveScoring extends StatefulWidget {
  const InputLiveScoring({Key? key}) : super(key: key);

  @override
  _InputLiveScoringState createState() => _InputLiveScoringState();
}

class _InputLiveScoringState extends State<InputLiveScoring> {
  int scoreRed = 0;
  int scoreBlue = 0;
  Duration matchDuration = Duration.zero;
  Timer? _timer;
  bool isRunning = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRunning) return;
      setState(() {
        matchDuration += const Duration(seconds: 1);
      });
    });
  }

  void _toggleTimer() {
    setState(() {
      isRunning = !isRunning;
    });
  }

  void _updateScore(bool isRedTeam, bool isIncrement) {
    setState(() {
      if (isRedTeam) {
        scoreRed += isIncrement ? 1 : -1;
        if (scoreRed < 0) scoreRed = 0;
      } else {
        scoreBlue += isIncrement ? 1 : -1;
        if (scoreBlue < 0) scoreBlue = 0;
      }
    });
  }

  void _showFinishConfirmation() {
    setState(() {
      isRunning = false;
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Finish Match"),
        content: const Text("Are you sure you want to finish the match early?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Match finished")),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
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
    required Function(bool) onTap,
    required bool isTop,
  }) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final width = constraints.maxWidth;
              final isRight = details.localPosition.dx > width / 2;
              onTap(isRight);
            },
            child: Container(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.remove,
                            size: 40, color: Colors.black54),
                        Text(
                          score.toString(),
                          style: const TextStyle(
                              fontSize: 80, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.add, size: 40, color: Colors.black54),
                      ],
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FEFD),
      body: Stack(
        children: [
          Column(
            children: [
              buildScorePanel(
                color: const Color(0xffFF6868),
                teamName: "Apex of Generations",
                score: scoreRed,
                onTap: (isRight) => _updateScore(true, isRight),
                isTop: true,
              ),
              buildScorePanel(
                color: const Color(0xff68E8FF),
                teamName: "T1 Sports",
                score: scoreBlue,
                onTap: (isRight) => _updateScore(false, isRight),
                isTop: false,
              ),
            ],
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.38,
                padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
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
    );
  }
}
