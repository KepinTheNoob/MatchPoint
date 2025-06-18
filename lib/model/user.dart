import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? username;
  String? email;
  String? dateCreated;
  Users({
    this.id,
    this.username,
    this.email,
    this.dateCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "email": email,
      "dateCreated": dateCreated,
    };
  }

  factory Users.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Users(
      id: doc.id,
      username: data["username"],
      email: data["email"],
      dateCreated: data["dateCreated"],
    );
  }
}