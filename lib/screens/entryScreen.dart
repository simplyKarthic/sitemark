import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'Register.dart';
import 'login.dart';

class entryScreen extends StatefulWidget {
  const entryScreen({Key key}) : super(key: key);

  @override
  State<entryScreen> createState() => new _entryScreenState();
}

class _entryScreenState extends State<entryScreen> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage('https://mir-s3-cdn-cf.behance.net/project_modules/fs/78c4af118001599.608076cf95739.jpg'),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Login to access your data across devices', style: TextStyle(fontSize: 12, color: Colors.white)),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  child: Text('Login'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => login(),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Register'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return myApp();
    }
  }
}
