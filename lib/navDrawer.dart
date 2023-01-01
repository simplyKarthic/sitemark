import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/screens/Register.dart';
import 'package:sitemark/screens/entryScreen.dart';
import 'package:sitemark/screens/login.dart';

import 'database/database.dart';
import 'models/user.dart';

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
            child: DrawerHeader(
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
              title: Text('Chat room'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('My Topics'),
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
              title: Text('Settings'),
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
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => entryScreen(),
              ),
              )
              },
            ),
          ),
        ],
      ),
    );
  }

}

