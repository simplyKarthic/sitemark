import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
