import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:sitemark/models/user.dart';

import '../functions/randomGen.dart';

class Database {
  final String uid;

  Database({@required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('User');
  final CollectionReference feedsCollection = FirebaseFirestore.instance.collection('generalFeeds');
  final CollectionReference chatsCollection = FirebaseFirestore.instance.collection('chats');

  Future<bool> addUser(String name, String email, String profilePic, String authby) async {
    try {
      await userCollection
          .doc(uid)
          .set({'name': name, 'uid': uid, 'postListID': [], 'chattingUsers': [], 'profilepic': profilePic, 'lastSeen': Timestamp.now(), 'authby': authby});

      return true;
    } on FirebaseException catch (err) {
      print(err);
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> editPost({String title, String description, String imageUrl, String profileName, String postId}) async {
    try {
      await feedsCollection
          .doc(postId)
          .update({'description': description, 'imageUrl': imageUrl, 'postedTime': Timestamp.now(), 'profileName': profileName, 'title': title});

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

  Future<bool> addNewPost(
      {String title, String description, String imageUrl, String profileName, Timestamp postedTime, String postId, int commentCount}) async {
    try {
      var addPostResponse = await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(feedsCollection.doc(postId), {
          'title': title,
          'description': description,
          'imageUrl': imageUrl,
          'postedTime': postedTime,
          'profileName': profileName,
          'uid': uid,
          'commentCount': 0,
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

  Future<bool> deletePost({String postId}) async {
    try {
      var sendMessageResponse = await FirebaseFirestore.instance.runTransaction((transaction) async {
        final instance = FirebaseFirestore.instance;
        final batch = instance.batch();
        var collection = instance.collection('generalFeeds').doc(postId).collection('Comments');
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        transaction.delete(feedsCollection.doc(postId));

        transaction.update(userCollection.doc(uid), {
          'postListID': FieldValue.arrayRemove([postId])
        });
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
      var startChatResponse = await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(chatsCollection.doc(chatId), {
          'chatID': chatId,
          'lastMsgTime': Timestamp.now(),
          'lastMessage': '',
          'userIds': [from_uid, to_uid],
          'postTitle': postTitle,
          'postId': postId,
          'fromName': fromName,
          'toName': toName,
        });

        transaction.update(userCollection.doc(from_uid), {
          'chattingUsers': FieldValue.arrayUnion([to_uid])
        });

        transaction.update(userCollection.doc(to_uid), {
          'chattingUsers': FieldValue.arrayUnion([from_uid])
        });
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

  Future<bool> sendMessage({String chatId, String senderID, String text}) async {
    try {
      var sendMessageResponse = await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
            chatsCollection.doc(chatId).collection('messages').doc(getRandomString(15)), {'sender_id': senderID, 'text': text, 'timeStamp': Timestamp.now()});

        transaction.update(chatsCollection.doc(chatId), {
          'lastMessage': text,
          'lastMsgTime': Timestamp.now(),
        });
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

  onlineStatus(bool status) async {
    int userNum = status ? 1 : -1;
    await FirebaseDatabase.instance.ref().child('userStatus').update({'online': ServerValue.increment(userNum)});
  }

  Future<bool> commentFunction({String commentData, String userName, String postID}) async {
    try {
      String commentId = getRandomString(15);
      await feedsCollection
          .doc(postID)
          .collection('Comments')
          .doc(commentId)
          .set({'cmtUserId': uid, 'commentData': commentData, 'likedUsers': [], 'userName': userName, 'commentId': commentId, 'commentTime': Timestamp.now()});

      await feedsCollection.doc(postID).update({'commentCount': FieldValue.increment(1)});

      return true;
    } on FirebaseException catch (err) {
      print(err);
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> likeFunction({String postID, String commentId, bool disLike}) async {
    try {
      if (disLike) {
        await feedsCollection.doc(postID).collection('Comments').doc(commentId).update({
          'likedUsers': FieldValue.arrayRemove([uid]),
        });
      } else {
        await feedsCollection.doc(postID).collection('Comments').doc(commentId).update({
          'likedUsers': FieldValue.arrayUnion([uid]),
        });
      }
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
