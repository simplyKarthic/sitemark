import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/database.dart';
import '../models/UrlData.dart';
import '../models/user.dart';
import 'addSite.dart';


class MySites extends StatefulWidget {
  const MySites(UserData user, {Key key}) : super(key: key);

  @override
  State<MySites> createState() => _MySitesState();
}

class _MySitesState extends State<MySites> {
  bool gridView = true;
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text("My Post's"),
          actions: <Widget>[

        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => addSite(context),
              ),
            );
          },
        ),

        (gridView == true)
            ? IconButton(
                icon: Icon(
                  Icons.list_alt_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    gridView = false;
                  });
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.grid_view,
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    gridView = true;
                  });
                },
              ),
      ]),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('User').doc(user.uid).collection('Post').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            }
            List<DocumentSnapshot> documents = snapshot.data.docs;
            if (gridView == true){
              return GridView.builder(
                itemCount: documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0
                  ),
                  itemBuilder: (context, index){
                    return Container(
                      padding: EdgeInsets.all(15),
                      child: siteGridContainer(context, documents[index]),
                    );
                  }
              );
            }
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(15),
                    child: siteListContainer(context, documents[index])
                  );
               });
          },
        ),
      ),
    );
  }
}

siteGridContainer(BuildContext context, documents) {
  return GestureDetector(
    onTap: () {
      _showFullScreenImage(context, documents);
    },
    child: Material(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      elevation: 10,
      shadowColor: Color(0xFFFFB583),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAA86E),
              Color(0xFFFD9495),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.27,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: NetworkImage(
                documents["imageUrl"],
              ),
              height: 50,
              width: 50,
            ),
            Text(
              documents["title"],
              style: TextStyle(
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

siteListContainer(BuildContext context, documents) {
  return GestureDetector(
    onTap: () {
      _showFullScreenImage(context, documents);
    },
    child: Material(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      elevation: 10,
      shadowColor: Color(0xFF3BBAFF),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(72, 159, 180, 1.0), Color.fromRGBO(133, 206, 225, 1.0)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        height: 80,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image(
              image: NetworkImage(
                documents["imageUrl"],
              ),
              height: 50,
              width: 50,
            ),
            Text(
              documents["title"],
              style: TextStyle(
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

_showFullScreenImage(BuildContext context, documents) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: (documents["viewCount"] > 10)
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
          height: MediaQuery.of(context).size.height * 0.77,
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
                    tag: documents["imageUrl"],
                    child: Image.network(
                      documents["imageUrl"],
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

                Container(padding: EdgeInsets.all(8), height: 130, color: Colors.grey[350], child: SingleChildScrollView(child: Text(documents["description"]))),

                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Delete'), // <-- Text
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
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Repost'), // <-- Text
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.loop,
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

