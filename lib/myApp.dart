import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:sitemark/routes.dart';
import 'package:provider/provider.dart';
import 'package:sitemark/screens/constantData.dart';
import 'database/auth_service.dart';
import 'database/database.dart';
import 'models/ProxyData.dart';
import 'models/user.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    return StreamBuilder<UserData>(
        stream: AuthService().user,
        builder: (context, userSnapshot) {
          return StreamBuilder<UserProfileData>(
              stream: Database(uid: userSnapshot.hasData ? userSnapshot.data.uid: null).getUserProfileData,
              builder: (context, profSnapshot) {
                return MultiProvider(
                    providers: [
                      StreamProvider<UserData>.value(
                        initialData: null,
                        value: AuthService().user,
                        catchError: (_, err) {
                          print("$err -  get UserData StreamProvider");
                          return null;
                        },
                      ),
                      StreamProvider<UserProfileData>.value(
                        initialData: null,
                        value: Database(uid: userSnapshot.hasData ? userSnapshot.data.uid: null).getUserProfileData,
                        catchError: (_, err) {
                          print("$err -  get UserProfileData StreamProvider");
                          return null;
                        },
                      ),
                      ProxyProvider2<UserData,UserProfileData, ProxyData>(
                        update: (context, userData, userProfData, _) {
                          return ProxyData(
                            userData: userData,
                            userProfileData: userProfData,
                          );
                        },
                      )
                    ],
                    child: MaterialApp(
                      title: "my app",
                      theme: ThemeData(
                        scaffoldBackgroundColor: primaryColor,
                        colorScheme: ColorScheme(
                          brightness: Brightness.light,
                          primary: primaryColor,
                          onPrimary: lightBlue,
                          secondary: Colors.grey,
                          secondaryVariant: Colors.grey,
                          onSecondary: Colors.grey,
                          background: Colors.grey,
                          onBackground: Colors.grey,
                          surface: Colors.grey,
                          onSurface: Colors.grey,
                          error: Colors.grey,
                          onError: Colors.grey,
                        ),
                      ),
                      debugShowCheckedModeBanner: false,
                      initialRoute: '/entry',
                      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
                    ));
              });
        });
  }
}
