import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:sitemark/models/user.dart';

import '../models/UrlData.dart';

class Database {
  final String uid;

  Database({@required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('User');
  final CollectionReference feedsCollection = FirebaseFirestore.instance.collection('generalFeeds');

  Future<bool> addUser(String name, String email, String profilePic, String authby) async {
    try {
      await userCollection
          .doc(uid)
          .set({'name': name, 'uid': uid, 'postListID': [], 'profilepic': profilePic, 'createdDate': Timestamp.now(), 'authby': authby});

      return true;
    } on FirebaseException catch (err) {
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

  Future<bool> addNewPost({String title, String description, String imageUrl, String profileName, Timestamp postedTime, String postId, int viewCount}) async {
    try {
      var addPostResponse = await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(userCollection.doc(uid).collection('Post').doc(postId), {
          'title': title,
          'description': description,
          'imageUrl': imageUrl,
          'postedTime': postedTime,
          'profileName': profileName,
          'uid': uid,
          'postCount': 0,
          'chatting': false,
          'postId': postId
        });

        transaction.set(feedsCollection.doc(postId), {
          'title': title,
          'description': description,
          'imageUrl': imageUrl,
          'postedTime': postedTime,
          'profileName': profileName,
          'uid': uid,
          'postCount': 0,
          'chatting': false,
          'postId': postId
        });

        transaction.set(
            userCollection.doc(uid),
            {
              'postListID': FieldValue.arrayUnion([postId])
            },
            SetOptions(merge: true));
      });
      return true;
    } on FirebaseException catch (err) {
      print(err);
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> startChat(
      {bool chatting, String chatId, String from_uid, String to_uid, String postId, String postTitle, String fromName, String toName}) async {
    try {
      var addPostResponse = await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(FirebaseFirestore.instance.collection('chats').doc(chatId), {
          'chatID': chatId,
          'fromLastSeen': Timestamp.now(),
          'toLastSeen': Timestamp.now(),
          'userIds': [from_uid, to_uid],
          'postTitle': postTitle,
          'postId': postId,
          'fromName': fromName,
          'toName': toName,
        });

        DocumentSnapshot snapshot = await feedsCollection.doc(postId).get();

        if (snapshot.exists) {
          await transaction.delete(snapshot.reference);
          print("Document Deleted");
        } else {
          print("Document does not exist");
        }
      });

      return true;
    } on FirebaseException catch (err) {
      print(err);
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
