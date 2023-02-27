import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/viewPost.dart';

import '../database/database.dart';
import '../functions/randomGen.dart';
import '../models/ProxyData.dart';
import '../models/user.dart';
import 'constantData.dart';

class PostUI extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final int commentCount;
  final String postedTime;
  final String profileName;
  final String postId;
  final String postedUserId;
  final String routedFrom;
  final String currentUserUid;

  PostUI({
    Key key,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.commentCount,
    @required this.postedTime,
    @required this.profileName,
    @required this.postId,
    @required this.postedUserId,
    @required this.routedFrom,
    @required this.currentUserUid
  }) : super(key: key);

  @override
  State<PostUI> createState() => _PostUIState();
}

class _PostUIState extends State<PostUI> {
  String firstHalf;
  String secondHalf;
  bool _showFullText = false;
  int onlineUsers = 0;


  @override
  Widget build(BuildContext context) {
    int desLen = (widget.description.length < 210) ? widget.description.length : 210;
    return Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          border: Border.all(color: lightBlue),
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                widget.title,
                style: GoogleFonts.openSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ]),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewPost(
                            title: widget.title,
                            description: widget.description,
                            imageUrl: widget.imageUrl,
                            userName: widget.profileName,
                            time: widget.postedTime,
                            views: widget.commentCount,
                            postId: widget.postId,
                        posterUserUid: widget.postedUserId,
                          ))),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //_textExpand(context,isExpanded, widget.description ),
                    Container(
                      width: (widget.imageUrl == '') ? MediaQuery.of(context).size.width * 0.85 : MediaQuery.of(context).size.width * 0.57,
                      child: RawScrollbar(
                          thumbColor: const Color.fromRGBO(72, 159, 180, 1.0).withOpacity(0.5),
                          thumbVisibility: false,
                          thickness: 2,
                          radius: const Radius.circular(10),
                          child: SingleChildScrollView(
                              child: Text(
                            widget.description,
                            style: GoogleFonts.openSans(
                              color: Color(0xffDCECFF),
                              fontSize: 14,
                            ),
                          ))),
                    ),
                    if (widget.imageUrl != '')
                      Container(
                        height: 110.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                "${widget.postedTime} • ${widget.profileName}",
                style: GoogleFonts.openSans(color: lightBlue, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  (widget.routedFrom == 'viewPost')?
                  GestureDetector(
                    onTap: (){
                      //todo: add report feature
                    },
                    child: Icon(
                      Icons.report,
                      color: lightRed,
                      size: 20,
                    ),
                  ):
                  Wrap(
                    children: [
                      Text(
                        "${widget.commentCount}",
                        style: TextStyle(color: lightBlue, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.mode_comment_outlined,
                        color: lightBlue,
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  (widget.currentUserUid != widget.postedUserId)?
                  ElevatedButton(
                    onPressed: () async {
                      await Database(uid: widget.currentUserUid).startChat(
                          chatting: true,
                          chatId: getRandomString(10),
                          from_uid: widget.currentUserUid,
                          to_uid: widget.postedUserId,
                          postId: widget.postId,
                          postTitle: widget.title,
                          fromName: 'userProfileData.name',
                          toName: widget.profileName);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Chat'),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.send,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ):
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('generalFeeds').doc(widget.postId).delete();
                      if(widget.routedFrom == "viewPost"){
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Delete'),
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
                ],
              ),
            ])
          ],
        ));
  }
}
