import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/postUI.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/database.dart';
import '../functions/timeConverter.dart';
import '../models/UrlData.dart';
import '../models/user.dart';
import 'addSite.dart';

class MySites extends StatefulWidget {
  const MySites(UserData user, {Key key}) : super(key: key);

  @override
  State<MySites> createState() => _MySitesState();
}

class _MySitesState extends State<MySites> {
  bool gridView = true;
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    UserProfileData userProfileData = Provider.of<UserProfileData>(context);
    List<dynamic> postIDs = userProfileData.postListID.reversed.toList();
    return Scaffold(
      appBar: AppBar(title: Text("My Post's"), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => addSite(context),
              ),
            );
          },
        ),
      ]),
      body: Center(
        child: ListView.builder(
          itemCount: userProfileData.postListID.length,
          itemBuilder: (context, index) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('generalFeeds').doc(postIDs[index]).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var documents = snapshot.data;
                String timer = getTimeElapsed(documents["postedTime"]);
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  reverse: true,
                  child: PostUI(
                    title: documents['title'],
                    description: documents['description'],
                    commentCount: documents['commentCount'],
                    postedTime: timer,
                    profileName: documents['profileName'],
                    imageUrl: documents['imageUrl'],
                    postId: documents['postId'],
                    routedFrom: 'editPost',
                    postedUserId: documents['uid'],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

_showFullScreenImage(BuildContext context, documents) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: (documents["commentCount"] > 10)
                ? LinearGradient(
                    colors: [
                      Color(0xFFFAA86E),
                      Color(0xFFFD9495),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : LinearGradient(
                    colors: [Color.fromRGBO(133, 206, 225, 1.0), Color.fromRGBO(72, 159, 180, 1.0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
          ),
          height: MediaQuery.of(context).size.height * 0.77,
          width: MediaQuery.of(context).size.width * 0.90,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InteractiveViewer(
                  panEnabled: false, // Set it to false
                  constrained: true,
                  minScale: 1,
                  maxScale: 2,
                  child: Hero(
                    tag: documents["imageUrl"],
                    child: Image.network(
                      documents["imageUrl"],
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(8), height: 130, color: Colors.grey[350], child: SingleChildScrollView(child: Text(documents["description"]))),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Delete'), // <-- Text
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.delete,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Repost'), // <-- Text
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.loop,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
