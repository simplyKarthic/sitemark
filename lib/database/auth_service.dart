import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sitemark/models/user.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserData _userFromFirebaseUser(User user) {
    return user != null ? UserData(uid: user.uid, email: user.email) : null;
  }

  Stream<UserData> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<User> authenticateWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn(scopes: <String>["email"]).signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<Object> accessWithGoogle() async {
    try {
      User user = await authenticateWithGoogle();
      if (user == null) return null;
      if (user != null) {
        final DocumentReference userRef = FirebaseFirestore.instance.collection('User').doc(user.uid);
        final DocumentSnapshot userSnapshot = await userRef.get();
        if (!userSnapshot.exists) {
          await Database(uid: user.uid)
              .addUser(user.displayName.toString(), user.email.toString(), user.photoURL.toString(), 'Google');
        }
        return UserData(
            uid: user.uid,
            email: user.email.toString()
        );
      }else{
        return null;
      }
    } catch (error) {
      return error;
    }
  }


  registerWithEmailAndPassword(String name, String email, String password) async {
    try{
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = credential.user;
      if (user == null) return null;
      if (user != null) {
        await Database(uid: user.uid).addUser(name, email, '', 'password');
      }
      return UserData(uid: user.uid, email: user.email.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User user = credential.user;
      if (user == null) return null;
      return UserData(uid: user.uid, email: user.email.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

}
