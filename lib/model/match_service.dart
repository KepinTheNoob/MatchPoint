import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchpoint/model/match_model.dart';

class MatchService {
  final _firestore = FirebaseFirestore.instance.collection("match");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserUid() {
    return _auth.currentUser?.uid;
  }

  Future<void> createMatch(MatchInfo match) async {
    await _firestore.add(match.toJson());
  }

  Future<List<MatchInfo>> getMatches() async {
    final user = FirebaseAuth.instance.currentUser;
    final getUserMatch = await FirebaseFirestore.instance
      .collection("match")
      .where("createdBy", isEqualTo: user?.uid)
      .get();

    return getUserMatch.docs.map((doc) {
      return MatchInfo.fromJson(doc.data(), id: doc.id);
    }).toList();
  }

  Future<void> updateMatch(String id, MatchInfo match) async {
    await _firestore.doc(id).update(match.toJson());
  }

  Future<void> deleteMatch(String id) async {
    await _firestore.doc(id).delete();
  }
}