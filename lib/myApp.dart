import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/screens/entryScreen.dart';
import 'package:provider/provider.dart';
import 'database/auth_service.dart';
import 'models/ProxyData.dart';
import 'models/user.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    return  StreamBuilder<UserData>(
      stream: AuthService().user,
      builder: (context, profSnapshot){
        return MultiProvider(
          providers: [
            StreamProvider<UserData>.value(
                initialData: null,
                value: AuthService().user,
              catchError: (_, err){
                print(err.toString() + " -  get UserData StreamProvider");
                return UserData.initial();
              },
            ),
            ProxyProvider<UserData, ProxyData>(
              update: (context, userData, _) {
                return ProxyData(
                  userData: userData,
                );
              },
            )
          ],
          child : const MaterialApp(
          title: "my app",
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: entryScreen(),
          ),
        )
        );
      }
    );
  }
}
