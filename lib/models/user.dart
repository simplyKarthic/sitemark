import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String email;
  bool isUserVerified;
  String phone;
  String profilePic;
  String authby;

  UserData({required this.uid, required this.email, required this.isUserVerified, required this.phone, required this.profilePic, required this.authby});

  factory UserData.error() {
    return UserData(uid: '', email: '', isUserVerified: false, phone: '', profilePic: '', authby: '');
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        uid: json['uid'] ?? '',
        email: json['email'],
        isUserVerified: json['isUserVerified'],
        phone: json['phone'],
        profilePic: json['profilePic'],
        authby: json['authby']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['isUserVerified'] = isUserVerified;
    data['phone'] = phone;
    data['profilePic'] = profilePic;
    data['authby'] = authby;
    return data;
  }
}
