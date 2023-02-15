import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../functions/randomGen.dart';
import '../models/user.dart';

class PostUI extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final int viewCount;
  final String postedTime;
  final String profileName;
  final String postId;
  final String postedUserId;

  PostUI({
    Key key,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.viewCount,
    @required this.postedTime,
    @required this.profileName,
    @required this.postId,
    @required this.postedUserId,
  }) : super(key: key);

  @override
  State<PostUI> createState() => _PostUIState();
}

class _PostUIState extends State<PostUI> {
  String firstHalf;
  String secondHalf;
  bool _showFullText = false;

  @override
  Widget build(BuildContext context) {
    int desLen = (widget.description.length < 210) ? widget.description.length : 210;
    UserData user = Provider.of<UserData>(context);
    UserProfileData userProfileData = Provider.of<UserProfileData>(context);

    return Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          gradient: (widget.viewCount > 10)
              ? LinearGradient(
                  colors: [Color(0xFFFAA86E), Color(0xFFFD9495)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [Color.fromRGBO(133, 206, 225, 1.0), Color.fromRGBO(72, 159, 180, 1.0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: MediaQuery.of(context).size.height * 0.37,
        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ]),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () => _showFullScreenImage(context),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 110,
                      width: MediaQuery.of(context).size.width * 0.57,
                      child: RawScrollbar(
                          thumbColor: (widget.viewCount > 10) ? Color.fromRGBO(72, 159, 180, 1.0).withOpacity(0.5) : Color(0xFFFD9495).withOpacity(0.5),
                          thumbVisibility: false,
                          thickness: 2,
                          radius: const Radius.circular(10),
                          child: SingleChildScrollView(
                              child: Padding(
                            padding: const EdgeInsets.only(right: 1.0),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showFullText = true;
                                  });
                                },
                                child: Text((_showFullText || widget.description.length < 210)
                                    ? widget.description
                                    : "${widget.description.substring(0, desLen)}.....")),
                          ))),
                    ),
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
                style: Theme.of(context).textTheme.caption,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "${widget.viewCount}",
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.loop,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Database(uid: user.uid).startChat(
                          chatting: true,
                          chatId: getRandomString(10),
                          from_uid: user.uid,
                          to_uid: widget.postedUserId,
                          postId: widget.postId,
                          postTitle: widget.title,
                          fromName: userProfileData.name,
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
                  ),
                ],
              ),
            ])
          ],
        ));
  }

  _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: (widget.viewCount > 10)
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
            height: MediaQuery.of(context).size.height * 0.75,
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
                      tag: widget.imageUrl,
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(padding: EdgeInsets.all(8), height: 130, color: Colors.grey[350], child: SingleChildScrollView(child: Text(widget.description))),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Report'), // <-- Text
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.report_gmailerrorred,
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
                            Text('chat'), // <-- Text
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.send,
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
}
