import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/models/user.dart';

class ChatBox extends StatefulWidget {
  String chatID;
  UserData user;
  ChatBox({Key key, @required this.chatID, @required this.user}) : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("username"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').doc(widget.chatID).collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> documents = snapshot.data.docs;
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return Text(documents[index]['text']);
              });
        },
      ),
    );
  }
}
