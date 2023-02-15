import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import 'chatbox.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({Key key}) : super(key: key);

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    UserProfileData userProfileData = Provider.of<UserProfileData>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat Room"),
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('chats').where('userIds', arrayContains: user.uid).orderBy('fromLastSeen', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            List<DocumentSnapshot> documents = snapshot.data.docs;

            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  bool myPost = userProfileData.postListID.contains(documents[index]['postId']);
                  return Container(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        child: ElevatedButton(
                            child: Text(myPost ? documents[index]['fromName'] : documents[index]['toName']),
                            onPressed: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatBox(chatID: documents[index]['chatID'], user: user),
                                ),
                              );
                            }),
                      ));
                });
          },
        ));
  }
}