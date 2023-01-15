import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String email;

  UserData({ this.uid,  this.email});

  factory UserData.error() {
    return UserData(uid: '', email: '');
  }
}
