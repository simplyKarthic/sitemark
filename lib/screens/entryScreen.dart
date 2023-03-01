import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/auth_service.dart';
import 'Home.dart';
import 'constantData.dart';

class entryScreen extends StatefulWidget {
  const entryScreen({Key key}) : super(key: key);

  @override
  State<entryScreen> createState() => new _entryScreenState();
}

class _entryScreenState extends State<entryScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _passwordVisible = false;
  bool _obsecureTextState = true;
  bool errorMessageTime = true;

  String errorData = '';
  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void initiateFirebaseMessaging() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        print("Local message: ${message.notification.title}");
      }
    });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    _passwordVisible = false;
    _obsecureTextState = true;
    initiateFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: primaryColor,
          body: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(30, 70, 30, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to ThreadTalk!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(color: Colors.white, fontSize: 25),
                ),
                SizedBox(height: 20),
                Text(
                  'To begin chatting and discovering new connections, please login or register.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                ),
                SizedBox(
                  height: 50,
                ),
                _buildTextField(emailController, Icons.email, 'Email'),
                SizedBox(height: 20),
                _buildTextField(passwordController, Icons.lock, 'Password'),
                SizedBox(height: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(visible: errorMessageTime, child: Text(errorData, style: TextStyle(color: Colors.red, fontSize: 16))),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    MaterialButton(
                      elevation: 0,
                      minWidth: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      onPressed: () async {
                        errorData = '';
                        errorMessageTime = true;
                        if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                          if (emailController.text.contains('@') && emailController.text.contains('.')) {
                            if (passwordController.text.length > 6) {
                              final credential = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailController.text);
                              if (!credential.contains('password')) {
                                if (!credential.contains('google.com')) {
                                  String name = emailController.text.split('@')[0];
                                  var result = await AuthService().registerWithEmailAndPassword(name, emailController.text, passwordController.text);
                                  print("Register Result :$result");
                                  if (result != null) {
                                    Fluttertoast.showToast(msg: 'Account registered Successfully', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                                    Navigator.of(context).pushReplacementNamed('/home');
                                  } else {
                                    Fluttertoast.showToast(msg: 'Something Went wrong', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                                  }
                                } else {
                                  setState(() {
                                    setState(() => errorData = 'Account already Exists, Please use Google Access');
                                  });
                                }
                              } else {
                                setState(() => errorData = 'Account already Exists, Please Login');
                              }
                            } else {
                              setState(() => errorData = 'Password should contain atleast 8 characters');
                            }
                          } else {
                            setState(() => errorData = 'Please enter a valid email Id!');
                          }
                        } else {
                          setState(() => errorData = 'Please enter Something!');
                        }
                        Future.delayed(const Duration(seconds: 4), () {
                          if (mounted) {
                            setState(() {
                              errorMessageTime = false;
                            });
                          }
                        });
                      },
                      color: logoGreen,
                      textColor: Colors.white,
                      child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    SizedBox(width: 10),
                    MaterialButton(
                      elevation: 0,
                      minWidth: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      onPressed: () async {
                        errorData = '';
                        errorMessageTime = true;
                        if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                          if (emailController.text.contains('@') && emailController.text.contains('.')) {
                            if (passwordController.text.length > 6) {
                              final credential = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailController.text);
                              if (credential.isNotEmpty) {
                                if (credential.contains('password')) {
                                  var result = await AuthService().loginWithEmailAndPassword(emailController.text, passwordController.text);
                                  print("Login Result :$result");
                                  if (result != null) {
                                    Fluttertoast.showToast(msg: 'Login Successfully', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                                    Navigator.of(context).pushReplacementNamed('/home');
                                  } else {
                                    Fluttertoast.showToast(msg: 'Something Went wrong', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                                  }
                                } else {
                                  setState(() => errorData = 'Account Exist, Please Login using Google');
                                }
                              } else {
                                setState(() => errorData = 'Account Does not Exist, Please Register');
                              }
                            } else {
                              setState(() => errorData = 'Password should contain atleast 8 characters');
                            }
                          } else {
                            setState(() => errorData = 'Please enter a valid email Id!');
                          }
                        } else {
                          setState(() => errorData = 'Please enter Something!');
                        }
                        Future.delayed(Duration(seconds: 4), () {
                          if (mounted)
                            setState(() {
                              errorMessageTime = false;
                            });
                        });
                      },
                      color: logoGreen,
                      child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 16)),
                      textColor: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () async {
                    var result = await AuthService().accessWithGoogle();
                    print("Login Result :$result");
                    if (result != null) {
                      Fluttertoast.showToast(msg: 'Access using Google successful', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                      Navigator.of(context).pushReplacementNamed('/home');
                    } else {
                      Fluttertoast.showToast(msg: 'Something Went wrong', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                    }
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('G',
                          style: GoogleFonts.albertSans(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                          )),
                      SizedBox(width: 10),
                      Text('Access using Google', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                  textColor: Colors.white,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFooterLogo(),
                )
              ],
            ),
          )),
    );
  }else{
      return const HomePage();
    }
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [
            Text('Connect, Chat, Disconnect',
                textAlign: TextAlign.center, style: GoogleFonts.openSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('- No Trace Left Behind -',
                textAlign: TextAlign.center, style: GoogleFonts.openSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  _buildTextField(TextEditingController controller, IconData icon, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: secondaryColor, border: Border.all(color: Colors.blue)),
      child: TextField(
        obscureText: (labelText == 'Password') ? _obsecureTextState : false,
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          border: InputBorder.none,
          suffixIcon: (labelText == 'Password')
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    print("pressed");
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                      _obsecureTextState = !_obsecureTextState;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
