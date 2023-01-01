import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sitemark/models/user.dart';

import '../models/UrlData.dart';

class Database{
  final String uid;

  Database({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('User');

  Future<bool> addUser(String name, String email, String phone,String profilePic,String authby) async {
    try{
      await userCollection.doc(uid).set({
        'name': name,
        'phone' : phone,
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

  Stream<UrlData> get remoteConfigData {
    var fetchResponse = userCollection.doc(uid).collection('Sites').doc('url').snapshots().map((snap) => UrlData.fromJson(snap.data()));
    print("fetchResponse: ${fetchResponse.length}");
    return fetchResponse;
  }

  Future getUrls() async{
    try{
      var urlData = await userCollection.doc(uid).collection('Sites').doc('url').get();
      print("urlData: $urlData");
      if(!urlData.exists){
        return [];
      }else if(urlData.data() == null){
        return null;
      }else{
        return urlData.data()?.entries.map((e) => UrlData.fromJson(e.value)).toList();
      }
    }catch(err){
      print('while getting url: $err');
      return null;
    }

  }

}