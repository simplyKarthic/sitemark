import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../constantData.dart';
import 'chatbox.dart';

class ConversationTile extends StatefulWidget{
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  String chatID;
  UserData user;
  ConversationTile({@required this.user, @required this.chatID, @required this.name, @required this.messageText,@required this.imageUrl,@required this.time,@required this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatBox(chatID: widget.chatID, user: widget.user, appBarName:widget.name, profilePic: widget.imageUrl),
          ),
        );
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            border: Border.all(color: lightBlue),
          ),
        margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  (widget.imageUrl.length>5) ?
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(widget.imageUrl),
                  ):
                  Container(
                    width: 52,
                    height: 52,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                    decoration: new BoxDecoration(
                      color: lightBlue,
                      borderRadius: new BorderRadius.all(new Radius.circular(60.0)),
                    ),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: TextStyle(color: lightBlue, fontSize: 16, fontWeight: FontWeight.w600),),
                          SizedBox(height: 6,),
                          Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.white, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal, color: Colors.white70),),
          ],
        ),
      ),
    );
  }

}