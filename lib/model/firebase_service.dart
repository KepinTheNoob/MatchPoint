import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchpoint/model/user.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection("users");

  Future<User?> signUp(String username, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      if (credential.user == null) {
        throw Exception("User is Null");
      }
      String uid = credential.user!.uid;
      await _userCollection.doc(uid).set({
        'username': username,
        'email': email,
      });

      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<Users?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _userCollection.doc(uid).get();
      if (doc.exists) {
        return Users.fromFirestore(doc);
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
    return null;
  }

  Future<void> editUsername(String username) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'username': username});
    } catch (e) {
      print("Error updating username: $e");
    }
  }

  Future<void> deleteAccount() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

      await user.delete();
    }
  } catch (e) {
    throw Exception('Failed to delete account: $e');
  }
}

}