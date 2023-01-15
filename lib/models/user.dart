import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String email;

  UserData({ this.uid,  this.email});

  factory UserData.error() {
    return UserData(uid: '', email: '');
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        uid: json['uid'] ?? '',
        email: json['email'] ?? '',
    );
  }

  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['uid'] = uid;
  //   data['email'] = email;
  //   return data;
  // }

  factory UserData.initial(){
    return UserData(
      uid: '',
      email: '',
    );
  }

}
