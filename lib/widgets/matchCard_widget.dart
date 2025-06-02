import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matchpoint/model/match_model.dart';

Widget matchCard({
  required MatchInfo match,
  required Team teamLeft,
  required Team teamRight,
  VoidCallback? onTap,
}) {
  final date = match.date != null
      ? DateFormat('EEEE, dd MMM yyyy').format(match.date!)
      : "No Date";
  final time = match.startingTime != null
      ? "${match.startingTime!.hour.toString().padLeft(2, '0')}:${match.startingTime!.minute.toString().padLeft(2, '0')}"
      : "No Time";

  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
          // Tanggal dan Jenis Olahraga
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$date, $time",
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              Text(
                match.sportType ?? "?? Sport",
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTeamColumn(teamLeft, isLeft: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTeamColumn(teamRight, isLeft: false)),
                ],
              ),
              // Informasi tengah
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("VS",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    "${teamLeft.score} - ${teamRight.score}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        teamLeft.score > teamRight.score
                            ? "WIN"
                            : teamLeft.score < teamRight.score
                                ? "LOSE"
                                : "DRAW",
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            color: teamLeft.score > teamRight.score
                                ? Colors.green
                                : teamLeft.score < teamRight.score
                                    ? Colors.red
                                    : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        teamRight.score > teamLeft.score
                            ? "WIN"
                            : teamRight.score < teamLeft.score
                                ? "LOSE"
                                : "DRAW",
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            color: teamRight.score > teamLeft.score
                                ? Colors.green
                                : teamRight.score < teamLeft.score
                                    ? Colors.red
                                    : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildTeamColumn(Team team, {bool isLeft = true}) {
  final displayedMembers = team.listTeam.length > 4
      ? [...team.listTeam.take(4), "..."]
      : team.listTeam.isNotEmpty
          ? team.listTeam
          : ["??"];

  return Expanded(
    child: Column(
      crossAxisAlignment:
          isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          (team.nameTeam ?? "?? Team").length > 14
              ? '${team.nameTeam!.substring(0, 10)}...'
              : team.nameTeam ?? "?? Team",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
              isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isLeft
              ? [
                  buildTeamProfileImage(team.picId),
                  const SizedBox(width: 8),
                  _buildMembersColumn(displayedMembers,
                      align: CrossAxisAlignment.start),
                ]
              : [
                  _buildMembersColumn(displayedMembers,
                      align: CrossAxisAlignment.end),
                  const SizedBox(width: 8),
                  buildTeamProfileImage(team.picId),
                ],
        ),
      ],
    ),
  );
}

Widget buildTeamProfileImage(String? picId, {double size = 60}) {
  final path =
      'assets/profile/${(picId?.isNotEmpty ?? false) ? picId : '1'}.png';

  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.grey.shade400,
        width: 1,
      ),
    ),
    padding: const EdgeInsets.all(4),
    child: CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(path),
    ),
  );
}

Widget _buildMembersColumn(List<String> members,
    {CrossAxisAlignment align = CrossAxisAlignment.start}) {
  return Column(
    crossAxisAlignment: align,
    mainAxisSize: MainAxisSize.min,
    children: members
        .map(
          (member) => Text(
            member.length > 7 ? '${member.substring(0, 7)}...' : member,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        .toList(),
  );
}
