import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/screens/postUI.dart';
import '../navDrawer.dart';

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
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: PostUI(
          title: 'ClipRRect',
          description: 'A widget that clips its child using a rounded rectangle. By default, ClipRRect uses its own bouA widget that clips its child using a rounded rectangle. By default, ClipRRect uses its own bouA widget that clips its child using a rounded rectangle. By default, ClipRRect uses its own bounds as the bA widget that clips its child using a rounded rectangle. By default, ClipRRect uses its own bounds as the base rectangle for the clip, but the size and location of the clip can be customized using a custom clipper.',
          viewCount: 10,
          posterTime: '19 min ago',
          profileName: 'karthic',
          imageUrl: 'https://mir-s3-cdn-cf.behance.net/project_modules/fs/78c4af118001599.608076cf95739.jpg',
        ),
      )
    );
  }
}
