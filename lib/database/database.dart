import 'package:cloud_firestore/cloud_firestore.dart';
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



  Future<List<UrlData>> get getAccountPostData async {
    try{
      List<UrlData> accountPost = [];
      var fetchResponse = await userCollection.doc(uid).collection('Sites').doc('url').get();
      if(fetchResponse.data() == null){
        accountPost = [];
      }else{
        accountPost = fetchResponse.data().entries.map((e) => UrlData.fromJson(e.value)).toList();
      }
      return accountPost;
    }catch(err){
      print("getAccountPostData error: $err");
      return null;
    }

  }


}