import 'package:flutter/material.dart';
import 'package:sitemark/screens/Home.dart';
import 'package:sitemark/screens/SplashScreen.dart';
import 'package:sitemark/screens/entryScreen.dart';
import 'package:sitemark/screens/loading.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    //todo:configure routes for main page
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>const SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_)=> const HomePage());
      case '/entry':
        return MaterialPageRoute(builder: (_)=> const entryScreen());
    }
  }
}