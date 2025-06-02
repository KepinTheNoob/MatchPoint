import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matchpoint/model/match_model.dart';

Widget matchCard(MatchInfo match, Team teamA, Team teamB) {
  final date = match.date != null
      ? DateFormat('EEEE, dd MMM yyyy').format(match.date!)
      : "No Date";
  final time = match.startingTime != null
      ? "${match.startingTime!.hour.toString().padLeft(2, '0')}:${match.startingTime!.minute.toString().padLeft(2, '0')}"
      : "No Time";
      
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFEFF4FF), Color(0xFFFFE5E5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$date, $time",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            Text(
              match.sportType ?? "Unknown Sport",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Left team
            _buildTeamColumn(teamA.nameTeam.toString() ?? "", teamA.listTeam ?? []),
            Expanded(
              child: Column(
                children: [
                  Text("VS",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(
                    "${teamA.score} - ${teamB.score}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "WIN",
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "LOSE",
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right team
            _buildTeamColumn(teamB.nameTeam.toString() ?? "", teamB.listTeam ?? [], isLeft: false),
          ],
        )
      ],
    ),
  );
}

Widget _buildTeamColumn(String teamName, List<String> teamMembers, {bool isLeft = true}) {
  return Expanded(
    child: Column(
      crossAxisAlignment:
          isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          teamName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
              isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isLeft
              ? [
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...teamMembers.take(4).map((member) => Text(
                              member,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            )),
                        if (teamMembers.length > 4)
                          Text(
                            "+${teamMembers.length - 4} more",
                            style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                  ),
                ]
              : [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ...teamMembers.take(4).map((member) => Text(
                              member,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            )),
                        if (teamMembers.length > 4)
                          Text(
                            "+${teamMembers.length - 4} more",
                            style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                ],
        ),
      ],
    ),
  );
}
