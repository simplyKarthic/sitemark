import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/screens/addSite.dart';
import 'package:sitemark/screens/entryScreen.dart';
import 'package:sitemark/screens/login.dart';
import 'package:sitemark/screens/mySites.dart';
import 'database/auth_service.dart';
import 'database/database.dart';
import 'models/UrlData.dart';
import 'navDrawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

bool gridView = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(
      const MaterialApp(
      title: "my app",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      body: entryScreen(),
      )
      )
  );
}

class myApp extends StatefulWidget {
  const myApp( {Key? key}) : super(key: key);

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
            onPressed: ()  {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      title: const Text('Add your website'),
                      scrollable: true,
                      content: addSite(context)
                  )
              );
            },
          ),
          //onPressed: ()  => _scaffoldKey.currentState?.openDrawer(),
          (gridView == true) ?
          IconButton(
            icon: Icon(
              Icons.list_alt_outlined,
              color: Colors.white,
            ),
            onPressed: ()  {
              setState(() { gridView = false; });
            },
          ) :
          IconButton(
            icon: Icon(
              Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: ()  async {
              setState(() { gridView = true; });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text("welcome to my app")
          ],
        ),

      ),
    );
  }
}
