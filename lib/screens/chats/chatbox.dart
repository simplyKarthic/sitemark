import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/models/user.dart';
import '../../database/database.dart';
import '../constantData.dart';

class ChatBox extends StatefulWidget {
  String chatID;
  UserData user;
  String appBarName;
  String profilePic;
  ChatBox({Key key, @required this.chatID, @required this.user, @required  this.appBarName, @required this.profilePic}) : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  bool showTime = false;
  int tappedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final TextEditingController myMessage = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.profilePic),
            ),
            SizedBox(width: 10,),
            Text(widget.appBarName),
          ],
        ),
      ),
      body: Stack(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('chats').doc(widget.chatID).collection('messages').orderBy('timeStamp', descending: false).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<DocumentSnapshot> documents = snapshot.data.docs;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: widget.user.uid == documents[index]['sender_id'] ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              //todo: send images in chat
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (widget.user.uid == documents[index]['sender_id'] ? Colors.blue[200] : Colors.grey.shade200),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      documents[index]['text'],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  setState(() {
                                    tappedIndex = index;
                                    showTime = !showTime;
                                  });
                                },
                              ),
                              Visibility(
                                visible: showTime && tappedIndex == index,
                                child: Row(
                                  children: [
                                    Icon(Icons.timer, color: Colors.white30,size: 12,),
                                    Text(formatTimestamp(documents[index]['timeStamp']),style: TextStyle(color: Colors.white30, fontSize: 12),),
                                  ],
                                ),
                              ),
                              (documents.length == index+1)?SizedBox(height: 70,):Container()
                            ],
                          ),
                        ),
                        //Text(documents[index]['text']),
                      ],
                    );
                  }
                  );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: secondaryColor,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: color1,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.camera_alt, color: Colors.white70, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        print("myMessage: ${myMessage.text}");
                      },
                      controller: myMessage,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: () async {
                      await Database(uid: widget.user.uid).sendMessage(
                          senderID:widget.user.uid,
                          chatId:widget.chatID,
                          text: myMessage.text
                      );
                    },
                    child: Icon(Icons.send,color: Colors.white70,size: 18,),
                    backgroundColor: color1,
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

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String hour = (dateTime.hour % 12).toString().padLeft(2, '0');
    if (hour == '00') {
      hour = '12';
    }
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }


}
