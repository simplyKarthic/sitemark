import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/myApp.dart';
import 'package:sitemark/screens/addSite.dart';
import 'navDrawer.dart';
import 'package:firebase_core/firebase_core.dart';

bool gridView = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class myApp extends StatefulWidget {
  const myApp({Key key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("sitemark"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(title: const Text('Add your website'), scrollable: true, content: addSite(context)));
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text("welcome to my app")
          ],
        ),
      ),
    );
  }
}
