import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/myApp.dart';
import 'firebase_options.dart';
import 'navDrawer.dart';
import 'package:firebase_core/firebase_core.dart';

bool gridView = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
