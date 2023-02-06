import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sitemark/models/user.dart';

import '../main.dart';
import '../screens/login.dart';
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

  Future<Object> RegisterWithGoogle() async {
    try {
      User user = await authenticateWithGoogle();
      if (user == null) return null;
      if (user != null) {
        bool profileres = await Database(uid: user.uid)
            .addUser(user.displayName.toString(), user.email.toString(), user.photoURL.toString(), 'Google');

        return UserData(
            uid: user.uid,
            email: user.email.toString()
        );
      }
    } catch (error) {
      return error;
    }
  }

  registerWithEmailAndPassword(String email, String password) async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = credential.user;
    return user;
  }
}
