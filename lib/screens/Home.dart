import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/constantData.dart';
import 'package:sitemark/screens/postUI.dart';
import '../functions/timeConverter.dart';
import '../models/ProxyData.dart';
import '../models/user.dart';
import '../navDrawer.dart';
import '../database/database.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with WidgetsBindingObserver {
  int onlineUsers = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _onPresenceUpdate();
    Database().onlineStatus(true);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Database().onlineStatus(true);
        break;
      case AppLifecycleState.paused:
        Database().onlineStatus(false);
        break;
      default:
        break;
    }
  }


  Future<void> _onPresenceUpdate() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('userStatus/online').get();
    if (snapshot.exists) {
      setState(() {
        onlineUsers = snapshot.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProxyData proxyData = Provider.of<ProxyData>(context);
    UserData user = proxyData.userData;
    UserProfileData userProfileData = proxyData.userProfileData;
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(centerTitle: true, title: const Text("- Thread Talk -"), actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: lightGreen,
                child: Text(
                  '$onlineUsers',
                  style: GoogleFonts.openSans(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Online',
                style: GoogleFonts.openSans(color: lightGreen, fontSize: 12, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          )
        ]),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('generalFeeds').orderBy('postedTime', descending: true).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(color: Colors.white,));
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: Colors.white,));
              }
              List<DocumentSnapshot> documents = snapshot.data.docs;
              if (documents.length > 0 && user != null) {
                return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      String timer = getTimeElapsed(documents[index]["postedTime"]);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: PostUI(
                            title: documents[index]["title"],
                            description: documents[index]["description"],
                            commentCount: documents[index]["commentCount"],
                            postedTime: timer,
                            profileName: documents[index]["profileName"],
                            imageUrl: documents[index]["imageUrl"],
                            postId: documents[index]["postId"],
                            postedUserId: documents[index]["uid"],
                            routedFrom: 'home',
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.newspaper, size: 60,color: Colors.white70,),
                      SizedBox(height: 20,),
                      Text('No data in feed',
                          textAlign: TextAlign.center, style: GoogleFonts.openSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('- You can Start Posting -',
                          textAlign: TextAlign.center, style: GoogleFonts.openSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              }
            }
            ),
    );
  }

}
