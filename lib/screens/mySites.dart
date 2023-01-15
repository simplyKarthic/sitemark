import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/database.dart';
import '../models/UrlData.dart';
import '../models/user.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


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
    print("userdata: ${user.uid}");
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
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
        child: FutureBuilder(
          future: Database(uid: user.uid).getAccountPostData,
          builder: (BuildContext context, AsyncSnapshot<List<UrlData>> snapshot) {
            List<UrlData> postData = snapshot.data;
            if (postData == null || !snapshot.hasData){
              return Center(
                child: Container(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.blueAccent,
                    size: 200,
                  ),
                ),
              );
            }
            if (gridView == true){
              return GridView.builder(
                itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0
                  ),
                  itemBuilder: (context, index){
                    return Container(
                      padding: EdgeInsets.all(15),
                      child: siteGridContainer(context, postData[index]),
                    );
                  }
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(15),
                    child: siteListContainer(context, postData[index])
                  );
               });
          },
        ),
      ),
    );
  }
}

siteGridContainer(BuildContext context, UrlData data) {
  if (data == null) {
    return const SizedBox();
  }
  return GestureDetector(
    onTap: () {
      _launchURL(data.link);
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
                data.image,
              ),
              height: 50,
              width: 50,
            ),
            Text(
              data.name,
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

siteListContainer(BuildContext context, UrlData data) {
  if (data == null) {
    return const SizedBox();
  }
  return GestureDetector(
    onTap: () {
      //_launchURL(data.link);
      print("data");
      print(data);
      print(data.link);
      print(data.image);
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
                data.image,
              ),
              height: 50,
              width: 50,
            ),
            Text(
              data.name,
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

_launchURL(url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
