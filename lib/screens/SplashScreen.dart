import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'entryScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 6),
            ()=>Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_)=> const entryScreen())
        )
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 50, bottom: 0, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff120050),
                  Color(0xff10044B),
                ],
              ),
            ),
            child: Center(
              child: Lottie.asset(
                'assets/book-loading.json',
              ),
            ),
          ),
          Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        'Thread-Talk',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.abyssinicaSil(color: Colors.white, fontSize: 30,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text('Connect, Chat, Disconnect',
                          textAlign: TextAlign.center, style: GoogleFonts.openSans(color: Colors.white70, fontSize: 20)),
                      SizedBox(height: 25),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
