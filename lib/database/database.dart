import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sitemark/database/user.dart';

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

  // Stream<UserData> get vendorDetailsStream {
  //   return userCollection.doc(uid).snapshots().map((snap) => UserData.fromFirestore(snap));
  // }

  Future getUrls(String uid) async{
    try{
      var urlData = await userCollection.doc(uid).collection('Sites').doc('url').get();
      print(" $urlData");
      return urlData;
    }catch(err){
      print('while getting url: $err');
      return null;
    }

  }

}