import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String email;
  final bool isUserVerified;
  final String phone;
  final String profilePic;
  final String authby;

  UserData({required this.uid, required this.email, required this.isUserVerified, required this.phone, required this.profilePic, required this.authby});

  // factory UserData.fromFirestore(DocumentSnapshot doc) {
  //   Object data = doc.data();
  //   return UserData(
  //       uid: data!['uid'] ?? '',
  //       email: data['email'] ?? '',
  //       isUserVerified: data['isUserVerified'] ?? false,
  //       phone: data['phone'] ?? '',
  //       profilePic: data['profilePic'] ?? '',
  //       authby: data['authby'] ?? ''
  //   );
  // }

  factory UserData.error() {
    return UserData(
        uid: '',
        email: '',
        isUserVerified: false,
        phone: '',
        profilePic: '',
        authby: ''
    );
  }
}

