import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/constantData.dart';
import 'package:sitemark/screens/postUI.dart';
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
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<DocumentSnapshot> documents = snapshot.data.docs;
              if (documents.length > 0) {
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
                            currentUserUid :user.uid,
                        ),
                      );
                    });
              } else {
                return Container(
                  child: Text("No data in feed"),
                );
              }
            }
            ),
    );
  }

  getTimeElapsed(Timestamp timestamp){
    final DateTime now = DateTime.now();
    final DateTime dateTime = timestamp.toDate();
    final Duration difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      final int days = difference.inDays;
      final int hours = difference.inHours.remainder(24);
      return '${days}d, ${hours}hr ago';
    } else if (difference.inHours > 0) {
      final int hours = difference.inHours;
      final int minutes = difference.inMinutes.remainder(60);
      return '${hours}hr, $minutes min ago';
    } else {
      final int minutes = difference.inMinutes;
      if(minutes == 0){
        return 'just now';
      }
      return '$minutes minutes ago';
    }
  }

}
