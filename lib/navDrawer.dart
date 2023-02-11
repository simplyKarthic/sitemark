import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/QuotesData.dart';
import 'package:sitemark/screens/entryScreen.dart';
import 'package:sitemark/screens/mySites.dart';
import 'models/user.dart';

class NavDrawer extends StatelessWidget {
  UserData user;
  UserProfileData userProfileData;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserData>(context);
    userProfileData = Provider.of<UserProfileData>(context);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundImage: NetworkImage(userProfileData.profilePic),
                  ),
                  Text(
                    userProfileData.name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    user.email,
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
              leading: Icon(Icons.post_add),
              title: const Text('My Post'),
              onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MySites(user)))},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
            child: ListTile(
              leading: Icon(Icons.format_quote_sharp),
              title: const Text('philosophy'),
              onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => QuotesData()))},
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
