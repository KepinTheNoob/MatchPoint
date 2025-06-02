import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchInfo {
  String? id;
  DateTime? date;
  String? location;
  int? duration; // dalam menit
  TimeOfDay? startingTime;
  String? sportType;
  String? createdBy;

  MatchInfo({
    this.id,
    this.date,
    this.location,
    this.duration,
    this.startingTime,
    this.sportType,
    this.createdBy,
  });

  factory MatchInfo.fromJson(Map<String, dynamic> json, {String? id}) {
    final timeString = json['startingTime'] as String?;
    final time = timeString != null
        ? TimeOfDay(
            hour: int.parse(timeString.split(":")[0]),
            minute: int.parse(timeString.split(":")[1]),
          )
        : null;

    return MatchInfo(
      id: id,
      date: (json['date'] as Timestamp?)?.toDate(),
      location: json['location'],
      duration: json['duration'],
      startingTime: time,
      sportType: json['sportType'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'location': location,
      'duration': duration,
      'startingTime': startingTime != null
          ? '${startingTime!.hour}:${startingTime!.minute}'
          : null,
      'sportType': sportType,
      'createdBy': createdBy,
    };
  }
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
