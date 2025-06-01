import 'package:flutter/material.dart';

class MatchInfo {
  DateTime? date;
  String? location;
  int? duration; // dalam menit
  TimeOfDay? startingTime;
  String? sportType;

  MatchInfo({
    this.date,
    this.location,
    this.duration,
    this.startingTime,
    this.sportType,
  });
}

class Team {
  String? nameTeam;
  String? picId;
  List<String> listTeam;
  int score;

  Team({
    this.nameTeam,
    this.picId = "1",
    this.listTeam = const [],
    this.score = 0,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      nameTeam: json['nameTeam'] as String?,
      picId: json['picId'] as String?,
      listTeam: List<String>.from(json['listTeam'] ?? []),
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameTeam': nameTeam,
      'picId': picId,
      'listTeam': listTeam,
      'score': score,
    };
  }
}
