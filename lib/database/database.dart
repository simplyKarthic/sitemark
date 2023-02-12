import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:sitemark/models/user.dart';

import '../models/UrlData.dart';

class Database{
  final String uid;

  Database({ @required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('User');

  Future<bool> addUser(String name, String email, String profilePic,String authby) async {
    try{
      await userCollection.doc(uid).set({
        'name': name,
        'uid' : uid,
        'postListID': [],
        'profilepic': profilePic,
        'createdDate': Timestamp.now(),
        'authby': authby
      });

      return true;
    }on FirebaseException catch (err) {
      print(err);
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Stream<UserProfileData> get getUserProfileData {
    if (uid == null) return null;
    return userCollection.doc(uid).snapshots().map((snap) => UserProfileData.fromFirebase(snap.data()));
  }

  Future<bool> addNewPost({String title, String description, String imageUrl, String profileName, String posterTime, String postId, int viewCount}) async {
    try{

      await userCollection.doc(uid).collection('Post').doc(postId).set({
        'title': title,
        'description' : description,
        'imageUrl': imageUrl,
        'posterTime': posterTime,
        'profileName': profileName,
        'viewCount': 0,
      });

      await userCollection.doc(uid).set({
        'postListID' : FieldValue.arrayUnion([postId])
      }, SetOptions(merge: true));

      return true;
    }on FirebaseException catch (err) {
      print(err);
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }


  Future<List<UrlData>> get getAccountPostData async {
    try{
      List<UrlData> accountPost = [];
      var fetchResponse = await FirebaseFirestore.instance.collection('User').doc(uid).collection('Post').snapshots();

      return accountPost;
    }catch(err){
      print("getAccountPostData error: $err");
      return null;
    }

  }

}