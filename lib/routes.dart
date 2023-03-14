import 'package:flutter/material.dart';
import 'package:sitemark/screens/Home.dart';
import 'package:sitemark/screens/entryScreen.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    //todo:configure routes for main page
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>CircularProgressIndicator());
      case '/home':
        return MaterialPageRoute(builder: (_)=> HomePage());
      case '/entry':
        return MaterialPageRoute(builder: (_)=> entryScreen());
    }
  }
}