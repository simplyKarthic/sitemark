import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/screens/postUI.dart';
import '../navDrawer.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Home"),
        ),
        body: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('generalFeeds').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<DocumentSnapshot> documents = snapshot.data.docs;
                  if (documents.length > 1){
                    return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          DateTime now = DateTime.fromMillisecondsSinceEpoch(documents[index]["postedTime"].millisecondsSinceEpoch);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: PostUI(
                                title: documents[index]["title"],
                                description: documents[index]["description"],
                                viewCount: documents[index]["postCount"],
                                postedTime: "${DateFormat.Hms().format(now)}",
                                profileName: documents[index]["profileName"],
                                imageUrl: documents[index]["imageUrl"],
                                postId: documents[index]["postId"],
                                postedUserId: documents[index]["uid"]
                            ),
                          );
                        });
                  }else{
                    return Container(
                      child:Text("No data in feed"),
                    );
                  }

                })));
  }
}