import 'package:flutter/material.dart';

class MatchData {
  MatchDetail detail = MatchDetail();
  Team teamA = Team();
  Team teamB = Team();
  Score score = Score();
}

class MatchDetail {
  DateTime? date;
  int? minute;
  String? location;
  TimeOfDay? startingTime;
  String? sportType;
}

class Team {
  String name = '';
  String picId = '1';
  List<String> members = [];
}

class Score {
  int teamA = 0;
  int teamB = 0;
}

class MatchProvider extends ChangeNotifier {
  final MatchData _match = MatchData();

  MatchData get match => _match;

  void setTeamA(String name, String picId, List<String> members) {
    _match.teamA
      ..name = name
      ..picId = picId
      ..members = members;
    notifyListeners();
  }

  void setTeamB(String name, String picId, List<String> members) {
    _match.teamB
      ..name = name
      ..picId = picId
      ..members = members;
    notifyListeners();
  }

  void setMatchDetail({
    required DateTime date,
    required int minute,
    required String location,
    required TimeOfDay startingTime,
    required String sportType,
  }) {
    _match.detail
      ..date = date
      ..minute = minute
      ..location = location
      ..startingTime = startingTime
      ..sportType = sportType;
    notifyListeners();
  }

  void setScore(int scoreA, int scoreB) {
    _match.score.teamA = scoreA;
    _match.score.teamB = scoreB;
    notifyListeners();
  }
}
