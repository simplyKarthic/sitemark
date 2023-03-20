import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/database.dart';
import '../../functions/chatGpt.dart';
import '../../models/user.dart';
import '../constantData.dart';

class ChatWithGpt extends StatefulWidget {
  const ChatWithGpt({Key key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChatWithGpt> {
  String _response = "";
  bool showTime = false;
  int tappedIndex = 0;

  void _getResponseFromAPI(String message, String gptId, String userId) async {
    final response = await OpenAI.getResponse(message, gptId, userId);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController myMessage = TextEditingController();
    UserData user = Provider.of<UserData>(context);
    UserProfileData userProfileData = Provider.of<UserProfileData>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with GPT-3.5"),
      ),

      body: Stack(
          children:[

            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('chats').doc(userProfileData.chatGptId).collection('gptMessages').orderBy('timeStamp', descending: false).snapshots(),
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
                        mainAxisAlignment: user.uid == documents[index]['sender_id'] ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: (user.uid == documents[index]['sender_id'] ? Colors.blue[200] : Colors.grey.shade200),
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        documents[index]['text'].toString(),
                                        style: TextStyle(fontSize: 15),
                                        softWrap: true,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        print("myMessage: ${myMessage.text}");
                      },
                      controller: myMessage,
                      style: TextStyle(color: Colors.white),
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
                      await Database(uid: user.uid).sendChatGpt(
                          senderID:user.uid,
                          chatId: userProfileData.chatGptId,
                          text: myMessage.text
                      );
                      _getResponseFromAPI(myMessage.text, userProfileData.chatGptId, user.uid);
                      myMessage.clear();
                    },
                    child: Icon(Icons.send,color: Colors.white70,size: 18,),
                    backgroundColor: color1,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),]
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
