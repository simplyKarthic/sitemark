import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/screens/addSite.dart';
import 'database/auth_service.dart';
import 'database/database.dart';
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
      body:myApp(),
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
            (gridView == true) ? siteGridContainer(context) : siteListContainer(context),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () async {
              var profileres = await Database(uid: 'n0cI5ulmrHWUAa7a8I4jKgZMM3l1').getUrls('n0cI5ulmrHWUAa7a8I4jKgZMM3l1');
              print('bool ${profileres['Name']}');
              print('bool ${profileres['images']}');
              print('bool ${profileres['link']}');
            }
                , child: Text('onclick'))
          ],
        ),

      ),
    );
  }
}

siteGridContainer(BuildContext context){
  return GestureDetector(
    onTap: () {
      _launchURL('https://stackoverflow.com/');
    },
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(109, 215, 253, 100),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      height: 100,
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: NetworkImage(
            'https://icon.horse/icon/stackoverflow.com',
          ),
            height: 50,
            width: 50,
          ),
          Text("Stack Overflow", style: TextStyle(
              fontSize: 17,
          ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

siteListContainer(BuildContext context){
  return GestureDetector(
    onTap: () {
      _launchURL('https://stackoverflow.com/');
    },
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(109, 215, 253, 100),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      height: 80,
      width: MediaQuery.of(context).size.width*0.95,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image(image: NetworkImage(
            'https://icon.horse/icon/stackoverflow.com',
          ),
            height: 50,
            width: 50,
          ),
          Text("Stack Overflow", style: TextStyle(
            fontSize: 17,
          ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}


_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
