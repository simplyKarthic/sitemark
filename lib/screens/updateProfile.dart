import 'package:flutter/material.dart';

class updateProfile extends StatefulWidget {
  const updateProfile({Key? key}) : super(key: key);

  @override
  State<updateProfile> createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Container(

      ),
    );
  }
}
