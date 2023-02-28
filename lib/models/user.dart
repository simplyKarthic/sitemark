import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String email;

  UserData({ this.uid,  this.email});

  factory UserData.error() {
    return UserData(uid: '', email: '');
  }
}

class UserProfileData{
  String name;
  String authBy;
  List<dynamic> postListID;
  String profilePic;
  Timestamp lastSeen;
  List<dynamic> chattingUsers;

  UserProfileData({this.name, this.profilePic, this.postListID, this.authBy, this.lastSeen, this.chattingUsers});

  factory UserProfileData.error(){
    return UserProfileData(name: '',profilePic: '', postListID: [], authBy: '', lastSeen: Timestamp.now(), chattingUsers:[]);
  }

  factory UserProfileData.fromFirebase(Map data){
    return UserProfileData(
      name: data['name'] ?? '',
      authBy: data['authby'] ?? '',
      postListID: data['postListID'] ?? [],
      profilePic: data['profilepic'] ?? '',
      lastSeen: data['lastSeen'] ?? Timestamp.now(),
        chattingUsers: data['chattingUsers']?? [],
    );
  }


}
