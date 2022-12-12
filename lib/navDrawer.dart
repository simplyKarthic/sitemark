import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/screens/Register.dart';
import 'package:sitemark/screens/login.dart';

import 'database/database.dart';
import 'database/user.dart';

class NavDrawer extends StatelessWidget {
  late UserData user;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width*0.8,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height : MediaQuery.of(context).size.height*0.40,
            child: (FirebaseAuth.instance.currentUser == null) ?
            DrawerHeader(
                decoration: BoxDecoration(
                       color: Colors.blue,
                     ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                          radius: 52,
                          backgroundImage: NetworkImage(
                              'https://mir-s3-cdn-cf.behance.net/project_modules/fs/78c4af118001599.608076cf95739.jpg'),
                        ),
                  SizedBox(height: 10,),
                  Text('Login to access your data across devices',style: TextStyle(fontSize: 12, color: Colors.white)),
                  ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text('Login'),
                        style: ButtonStyle(
                          backgroundColor:MaterialStateProperty.all(Colors.white),
                          foregroundColor:MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>login()));
                        },
                      ),
                      ElevatedButton(
                        child: Text('Register'),
                        style: ButtonStyle(
                          backgroundColor:MaterialStateProperty.all(Colors.white),
                          foregroundColor:MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Register()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ) :
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYxylg_Nb9wzowg40KOGpWCW4BDvII7Bgl9MT3dSGus7sLLy8b'),
                  ),
                  Text(
                    'Bill gates',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    'bill@microsoft.com',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
            child: ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Edit Profile'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
            child: ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ),
          if (FirebaseAuth.instance.currentUser != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => {
                print(FirebaseAuth.instance.currentUser?.phoneNumber),
                print(FirebaseAuth.instance.currentUser?.email),
                FirebaseAuth.instance.signOut(),
                Navigator.of(context).pop()},
            ),
          ),
          TextButton(
            onPressed: () async {
              var urls = await Database(uid: user.uid).getUrls(user.uid);
              print("urls");
              print(urls);
            },
            child: const Text("Throw Test Exception"),
          ),
        ],
      ),
    );
  }

}

