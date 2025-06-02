import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchpoint/model/match_model.dart';

class TeamService {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserUid() {
    return _auth.currentUser?.uid;
  }

  Future<void> createTeam(String matchId, Team team) async {
    final uid = getCurrentUserUid();
    if (uid == null) throw Exception("User not logged in");

    final teamData = {
      ...team.toJson(),
      'createdBy': uid,
    };

    await _firestore.collection('team').doc(matchId).set(teamData);
  }

  Future<Team?> getTeam(String matchId) async {
    final doc = await _firestore.collection('team').doc(matchId).get();
    if (!doc.exists) return null;

    return Team.fromJson(doc.data()!);
  }

  Future<void> updateTeam(String matchId, Team team) async {
    await _firestore.collection('team').doc(matchId).update(team.toJson());
  }

  Future<void> deleteTeam(String matchId) async {
    await _firestore.collection('team').doc(matchId).delete();
  }
}
