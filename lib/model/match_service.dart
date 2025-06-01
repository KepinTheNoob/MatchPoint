import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MatchService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _matchCollection = FirebaseFirestore.instance.collection("match");

  Future<void> createMatch({
    required String location,
    required Map<String, dynamic> teamA, 
    required Map<String, dynamic> teamB,
    required int scoreTeamA,
    required int scoreTeamB,
  }) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("No user is currently signed in.");
      }

      final String uid = user.uid;

      final matchData = {
        "createdBy": uid,
        "date": Timestamp.now(),
        "location": location,
        "teamA": {
          "name": teamA["name"],
          "members": teamA["members"],
        },
        "teamB": {
          "name": teamB["name"],
          "members": teamB["members"],
        },
        "score": {
          "teamA": scoreTeamA,
          "teamB": scoreTeamB,
        }
      };

      await _matchCollection.add(matchData);
    } catch (e) {
      print("Error creating match: $e");
    }
  }
}