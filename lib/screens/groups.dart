import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class MyGroups extends StatefulWidget {
  const MyGroups({Key key}) : super(key: key);

  @override
  State<MyGroups> createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  bool gridView = true;
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text("My Group's"),
          actions: <Widget>[

            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                print("Search group");
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
          ]
      ),
      body: (gridView == true)?
      GridView.builder(
          itemCount: 2,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0
          ),
          itemBuilder: (context, index){
            return Container(
              padding: EdgeInsets.all(15),
              child: siteGridContainer(context, 'title', ""),
            );
          }
      ):

     ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.all(15),
              child: siteListContainer(context, 'title', "")
          );
        }),
    );
  }
}


siteGridContainer(BuildContext context, String title, String imgUrl) {
  return GestureDetector(
    onTap: () {
      print("group tapped");
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
            if(imgUrl.length>5)
            Image(
              image: NetworkImage(
                imgUrl,
              ),
              height: 50,
              width: 50,
            ),
            Text(
              title,
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

siteListContainer(BuildContext context, String title, String imgUrl) {
  return GestureDetector(
    onTap: () {
      print("group tapped");
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
            if(imgUrl.length>5)
            Image(
              image: NetworkImage(
                imgUrl,
              ),
              height: 50,
              width: 50,
            ),
            Text(
              title,
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
