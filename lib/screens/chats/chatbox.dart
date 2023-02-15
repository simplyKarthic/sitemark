import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/models/user.dart';

import '../../database/database.dart';

class ChatBox extends StatefulWidget {
  String chatID;
  UserData user;
  ChatBox({Key key, @required this.chatID, @required this.user}) : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

//todo: add ui and database setting for chat
class _ChatBoxState extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController myMessage = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("username"),
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
                              Container(
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
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
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
                          hintStyle: TextStyle(color: Colors.black54),
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
                      print("widget.chatID: ${widget.chatID}");
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
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
