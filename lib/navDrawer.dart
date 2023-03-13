import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/QuotesData.dart';
import 'package:sitemark/screens/chats/chatMain.dart';
import 'package:sitemark/screens/chats/chatWithGpt.dart';
import 'package:sitemark/screens/constantData.dart';
import 'package:sitemark/screens/editProfile.dart';
import 'package:sitemark/screens/entryScreen.dart';
import 'package:sitemark/screens/groups.dart';
import 'package:sitemark/screens/mySites.dart';
import 'database/database.dart';
import 'functions/randomGen.dart';
import 'models/user.dart';

class NavDrawer extends StatelessWidget {
  UserData user;
  UserProfileData userProfileData;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserData>(context);
    userProfileData = Provider.of<UserProfileData>(context);

    if(userProfileData != null){
      String profilePic = (userProfileData.profilePic == null) ? '' : userProfileData.profilePic;
      return Drawer(
        backgroundColor: secondaryColor,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: lightBlue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (profilePic != '') ?
                    Container(
                      height: 110.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(profilePic),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ],
                      ),
                    ):
                    Container(
                      width: 120.0,
                      height: 120.0,
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(new Radius.circular(60.0)),
                      ),
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
                selectedTileColor: color3,
                iconColor: lightBlue,
                textColor: Colors.white,
                leading: const Icon(Icons.smart_toy),
                title: const Text('Ask Chat Gpt'),
                onTap: () => {
                  if(userProfileData.chatGptId == '') FirebaseFirestore.instance.collection('User').doc(user.uid).update({'chatGptId':getRandomString(15)}),
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWithGpt()))
                },
                //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
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
              child: ListTile(
                selectedTileColor: color3,
                iconColor: lightBlue,
                textColor: Colors.white,
                leading: Icon(Icons.sms),
                title: Text('Chat room'),
                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMain()))},
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
              child: ListTile(
                selectedTileColor: color3,
                iconColor: lightBlue,
                textColor: Colors.white,
                leading: Icon(Icons.post_add),
                title: const Text('My Post'),
                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MySites(user)))},
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
              child: ListTile(
                selectedTileColor: color3,
                iconColor: lightBlue,
                textColor: Colors.white,
                leading: Icon(Icons.format_quote_sharp),
                title: const Text('philosophy'),
                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => const QuotesData()))},
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
              child: ListTile(
                selectedTileColor: color3,
                iconColor: lightBlue,
                textColor: Colors.white,
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () => {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfile(),
                  ),
                )
                },
              ),
            ),
            if (FirebaseAuth.instance.currentUser != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 1, 10, 1),
                child: ListTile(
                  selectedTileColor: color3,
                  iconColor: lightBlue,
                  textColor: Colors.white,
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () => {
                    Database().onlineStatus(false),
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
    }else{
      return Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[CircularProgressIndicator(),],
        ),
      );
    }

  }
}
