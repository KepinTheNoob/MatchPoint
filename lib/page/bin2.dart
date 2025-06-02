import 'dart:async';
import 'package:flutter/material.dart';

class LiveScoringPage extends StatefulWidget {
  const LiveScoringPage({Key? key}) : super(key: key);

  @override
  _LiveScoringPageState createState() => _LiveScoringPageState();
}

class _LiveScoringPageState extends State<LiveScoringPage> {
  int scoreRed = 0;
  int scoreBlue = 00;
  Duration matchDuration = const Duration(minutes: 0, seconds: 0);
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
        if (matchDuration.inSeconds >= 0) {
          matchDuration += const Duration(seconds: 1);
        } else {
          timer.cancel();
        }
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

  String _formatDuration(Duration d) {
    return d.toString().split('.').first.substring(2, 7);
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF3FEFD),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Live Scoring",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // final usableHeight = constraints.maxHeight;
          return Stack(
            children: [
              Column(
                children: [
                  buildScorePanel(
                    color: Color(0xffFF6868),
                    teamName: "Apex of Generations",
                    score: scoreRed,
                    onTap: (isRight) => _updateScore(true, isRight),
                    isTop: true,
                  ),
                  buildScorePanel(
                    color: Color(0xff68E8FF),
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
                          icon:
                              Icon(isRunning ? Icons.pause : Icons.play_arrow),
                          onPressed: _toggleTimer,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 26,
                      color: Colors.black,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Match Settings',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'Finish Early',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.sports_score,
                      size: 26,
                      color: Colors.black,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
