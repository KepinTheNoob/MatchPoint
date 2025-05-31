import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? username;
  String? email;
  Users({
    this.id,
    this.username,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "email": email
    };
  }

  factory Users.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Users(
      id: doc.id,
      username: data["username"],
      email: data["email"],
    );
  }
}