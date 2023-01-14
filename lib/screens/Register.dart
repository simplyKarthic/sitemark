import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/auth_service.dart';
import '../main.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String phone = "";
  String otp = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Register"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Register ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Create a account with your credentials"),
            ElevatedButton(
              child: Text('Google'),
              onPressed: () async {
                var result = await AuthService().RegisterWithGoogle();
                print("result : ${result}");
              },
            ),
            ElevatedButton(
              child: Text('Email'),
              onPressed: () => showDialog<String>(context: context, builder: (BuildContext context) => Registerwithemail(context)),
            ),
            ElevatedButton(
              child: Text('Phone'),
              onPressed: () => showDialog<String>(context: context, builder: (BuildContext context) => Registerwithphone(context)),
            ),
          ],
        )));
  }

  Registerwithemail(BuildContext context) {
    return AlertDialog(
      title: const Text('Login with email'),
      scrollable: true,
      content: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'example@gmail.com',
                      labelText: 'Email *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      hintText: 'min 8 char long',
                      labelText: 'Password *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop('Cancel');
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              print("email: $email, password $password");
                              var result = await AuthService().registerWithEmailAndPassword(email, password);
                              print("Result :   $result");
                              Navigator.of(context, rootNavigator: true).pop('Submit');
                            }
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Registerwithphone(BuildContext context) {
    return AlertDialog(
      title: const Text('Login with email'),
      scrollable: true,
      content: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: '+91 ',
                      labelText: 'phone *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      phone = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      hintText: '*** ***',
                      labelText: 'OTP *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      otp = value;
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop('Cancel');
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              phone = '+91$phone';
                              FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: phone,
                                timeout: Duration(seconds: 30),
                                verificationCompleted: (AuthCredential credential) async {
                                  var result = await FirebaseAuth.instance.signInWithCredential(credential);
                                  User user = result.user;
                                  if (user != null) {
                                    print("userData: $user");
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => myApp()));
                                  } else {
                                    print("Error");
                                  }

                                  //This callback would gets called when verification is done auto maticlly
                                },
                                verificationFailed: (authException) {
                                  print(authException.message);
                                },
                                codeSent: (String verificationId, [int forceResendingToken]) async {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          title: Text("Give the code?"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text('wait for the code to autofill'),
                                              TextField(
                                                controller: _codeController,
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: Text("Confirm"),
                                              onPressed: () async {
                                                final code = _codeController.text.trim();
                                                AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
                                                var result = await FirebaseAuth.instance.signInWithCredential(credential);
                                                User user = result.user;

                                                if (user != null) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => myApp()));
                                                } else {
                                                  print("Error");
                                                }
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                                codeAutoRetrievalTimeout: (String verificationId) {
                                  verificationId = verificationId;
                                  print(verificationId);
                                  print("Timout");
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
