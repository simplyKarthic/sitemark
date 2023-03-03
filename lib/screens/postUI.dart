import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/viewPost.dart';
import '../database/database.dart';
import '../functions/randomGen.dart';
import '../models/user.dart';
import 'addSite.dart';
import 'chats/chatMain.dart';
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
  }) : super(key: key);

  @override
  State<PostUI> createState() => _PostUIState();
}

class _PostUIState extends State<PostUI> {
  String firstHalf;
  String secondHalf;
  int onlineUsers = 0;


  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    UserProfileData userProfileData = Provider.of<UserProfileData>(context);

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
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                widget.title,
                style: GoogleFonts.openSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ]),
            SizedBox(
              height: 9,
            ),
            GestureDetector(
              onTap: () {
                print("ee");
                print(widget.routedFrom);
                if(widget.routedFrom == 'editPost'){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addSite(context, title: widget.title, description: widget.description, imageUrl:widget.imageUrl, postId: widget.postId)
                      )
                  );
                }else{
                  Navigator.push(
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
                          )));
                }
              },
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
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "${widget.postedTime} • ${widget.profileName}",
                  style: GoogleFonts.openSans(color: lightBlue, fontSize: 12, fontWeight: FontWeight.w600),
                ),
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
                  (user.uid != widget.postedUserId)?
                  ElevatedButton(
                    onPressed: () async {
                        if(userProfileData.chattingUsers.contains(widget.postedUserId)){
                          Fluttertoast.showToast(msg: 'you are already chatting', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                        }else{
                          await Database(uid: user.uid).startChat(
                              chatting: true,
                              chatId: getRandomString(10),
                              from_uid: user.uid,
                              to_uid: widget.postedUserId,
                              postId: widget.postId,
                              postTitle: widget.title,
                              fromName: userProfileData.name,
                              toName: widget.profileName);
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMain()));
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
                      Database(uid: user.uid).deletePost(postId: widget.postId);
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
