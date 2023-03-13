import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/constantData.dart';
import '../../functions/timeConverter.dart';
import '../../models/user.dart';
import 'conversationTile.dart';

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
          stream: FirebaseFirestore.instance.collection('chats').where('userIds', arrayContains: user.uid).orderBy('lastMsgTime', descending: true).snapshots(),
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
            if (snapshot.hasData && snapshot.data.docs.isNotEmpty){
              List<DocumentSnapshot> documents = snapshot.data.docs;
              return ListView.builder(
                itemCount: documents.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  bool myPost = userProfileData.postListID.contains(documents[index]['postId']);
                  String timer = getTimeElapsed(documents[index]['lastMsgTime']);
                  String toProfilePicUrl = (user.uid == documents[index]['userIds'][0]) ? documents[index]['userIds'][1]: documents[index]['userIds'][0];
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('User').doc(toProfilePicUrl).snapshots(),
                    builder: (context, profileSnapshot) {
                      if(profileSnapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
                      var documentFields = profileSnapshot.data;
                      return ConversationTile(
                        name: myPost ? documents[index]['fromName'] : documents[index]['toName'],
                        messageText: documents[index]['lastMessage'],
                        imageUrl: documentFields['profilepic']??'',
                        time: timer,
                        isMessageRead: (index == 0 || index == 3) ? true : false,
                        chatID: documents[index]['chatID'],
                        user: user,
                      );
                    }
                  );
                },
              );
            }else{
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_outlined,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'No chats Yet ...!',
                        style: GoogleFonts.openSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ));
            }
          },
        ));
  }
}
