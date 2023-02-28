import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/postUI.dart';
import '../database/database.dart';
import '../functions/timeConverter.dart';
import '../models/ProxyData.dart';
import '../models/user.dart';
import 'constantData.dart';

class ViewPost extends StatefulWidget {
  String title;
  String description;
  String imageUrl;
  String time;
  int views;
  String userName;
  String postId;
  String posterUserUid;

  ViewPost({
    Key key,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.time,
    @required this.views,
    @required this.userName,
    @required this.postId,
    @required this.posterUserUid,
  }) : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  @override
  Widget build(BuildContext context) {
    ProxyData proxyData = Provider.of<ProxyData>(context);
    UserData user = proxyData.userData;
    UserProfileData userProfileData = proxyData.userProfileData;
    final TextEditingController comment = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: PostUI(
                      title: widget.title,
                      description: widget.description,
                      commentCount: widget.views,
                      postedTime: widget.time,
                      profileName: widget.userName,
                      imageUrl: widget.imageUrl,
                      postId: widget.postId,
                      routedFrom: 'viewPost',
                      postedUserId: widget.posterUserUid,
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('generalFeeds').doc(widget.postId).collection('Comments').orderBy('commentTime', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      List<DocumentSnapshot> documents = snapshot.data.docs;
                      if(documents.isEmpty){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Icon(
                              Icons.pets,
                              color: Colors.white54,
                              size: 70,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'No Comments Yet ...!',
                              style: GoogleFonts.openSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                            )
                          ],
                        );
                      }
                      return ListView.builder(
                          itemCount: documents.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            List<dynamic> likeLen = documents[index]['likedUsers'];
                            String timer = getTimeElapsed(documents[index]["commentTime"]);
                            bool disLiker = false;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 25.0),
                                    Container(
                                      width: 2.0,
                                      height: 30.0,
                                      color: lightBlue,
                                      margin: EdgeInsets.only(right: 8.0),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.95,
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  padding: EdgeInsets.all(10),
                                  decoration: new BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(color: lightBlue),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        documents[index]['userName'],
                                        style: TextStyle(fontWeight: FontWeight.bold, color: lightBlue),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.85,
                                        decoration: new BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Text(documents[index]['commentData'], style: TextStyle(color: Colors.white)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (documents[index]['likedUsers'].contains(user.uid)) {
                                            setState(() {
                                              disLiker = true;
                                            });
                                          }
                                          await Database(uid: user.uid)
                                              .likeFunction(postID: widget.postId, commentId: documents[index]['commentId'], disLike: disLiker);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              timer,
                                              style: TextStyle(color: lightBlue, fontSize: 12),
                                            ),
                                            Wrap(
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              children: [
                                                (documents[index]['likedUsers'].contains(user.uid))
                                                    ? Icon(
                                                        Icons.favorite,
                                                        color: lightBlue,
                                                      )
                                                    : Icon(
                                                        Icons.favorite_border,
                                                        color: lightBlue,
                                                      ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  "${likeLen.length}",
                                                  style: TextStyle(color: lightBlue, fontWeight: FontWeight.w800, fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    }),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: secondaryColor,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) async {

                      },
                      controller: comment,
                      decoration: InputDecoration(hintText: "Add a comment...", hintStyle: TextStyle(color: Colors.white), border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      if(comment.text.length>1){
                        await Database(uid: user.uid).commentFunction(userName: userProfileData.name, commentData: comment.text, postID: widget.postId);
                        comment.clear();
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
