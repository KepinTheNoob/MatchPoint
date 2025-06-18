import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchpoint/model/match_model.dart';
import 'package:matchpoint/widgets/toast_widget.dart';

class MatchWithTeams {
  final MatchInfo match;
  final Team teamA;
  final Team teamB;

  MatchWithTeams({required this.match, required this.teamA, required this.teamB});
}

class MatchService {
  final _firestore = FirebaseFirestore.instance.collection("match");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserUid() {
    return _auth.currentUser?.uid;
  }

  Future<void> createMatch(MatchInfo match, Team teamA, Team teamB) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    match.createdBy = uid;

    final combinedData = {
      ...match.toJson(),
      'teamA': teamA.toJson(),
      'teamB': teamB.toJson(),
    };

    final docRef = await _firestore.add(combinedData);

    await docRef.update({'id': docRef.id});
  }

  Future<List<MatchWithTeams>> getMatches() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final snapshot = await _firestore.where('createdBy', isEqualTo: uid).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      if (data['teamA'] == null || data['teamB'] == null) {
        throw Exception("Match data is missing teamA or teamB");
      }

      final match = MatchInfo.fromJson(data, id: doc.id);
      final teamA = Team.fromJson(data['teamA']);
      final teamB = Team.fromJson(data['teamB']);
      return MatchWithTeams(match: match, teamA: teamA, teamB: teamB);
    }).toList();
  }

  Future<void> updateMatch(String id, MatchInfo match, Team teamA, Team teamB) async {
    try {
      final combinedData = {
      ...match.toJson(),
      'teamA': teamA.toJson(),
      'teamB': teamB.toJson(),
    };

    await _firestore.doc(id).update(combinedData);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteMatch(String id) async {
    await _firestore.doc(id).delete();
  }
}