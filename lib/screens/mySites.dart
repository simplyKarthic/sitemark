import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/database.dart';
import '../models/user.dart';
import '../models/UrlData.dart';

class MySites extends StatelessWidget {

  final bool gridView;

  const MySites(this.gridView, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UrlData>(
        stream: Database(uid:'n0cI5ulmrHWUAa7a8I4jKgZMM3l1').remoteConfigData,
        builder: (context, snapshot){
          print("snapshot");
          if (snapshot.data == null){
            return const SizedBox();
          }
          return Container(
            child: (gridView == true) ? siteGridContainer(context, snapshot.data) : siteListContainer(context, snapshot.data),
          );
        }
    );
  }
}

siteGridContainer(BuildContext context, UrlData? data){
  if (data == null){
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
        height: MediaQuery.of(context).size.height *0.15,
        width: MediaQuery.of(context).size.width *0.27,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: NetworkImage(
              data.image,
            ),
              height: 50,
              width: 50,
            ),
            Text(data.name, style: TextStyle(
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

siteListContainer(BuildContext context, UrlData? data){
  if (data == null){
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
            colors: [
              Color.fromRGBO(72, 159, 180, 1.0),
              Color.fromRGBO(133, 206, 225, 1.0)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),

          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        height: 80,
        width: MediaQuery.of(context).size.width*0.95,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image(image: NetworkImage(
              data.image,
            ),
              height: 50,
              width: 50,
            ),
            Text(data.name,
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