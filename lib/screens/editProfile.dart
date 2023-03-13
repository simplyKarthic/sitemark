import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../functions/getImageForPost.dart';
import '../functions/randomGen.dart';
import '../models/user.dart';
import 'constantData.dart';
import 'entryScreen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  File _croppedImage;
  String profileFileUrl = '';
  String _name = '';

  setImage(File imageFile) {
    setState(() {
      _croppedImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProfileData userProfileData = Provider.of<UserProfileData>(context);
    UserData user = Provider.of<UserData>(context);
    _name = userProfileData.name;
    profileFileUrl = userProfileData.profilePic;
    Future<String> uploadFile(File document, UserData user, String documentName) async {
      Reference storageReference = FirebaseStorage.instance.ref().child('${user.uid}/profilePic/${getRandomString(10)}');
      await storageReference.putFile(document);
      String fileUrl = await storageReference.getDownloadURL().then((fileURL) {
        return fileURL;
      }).catchError((onError) {
        return null;
      });
      return fileUrl;
    }

    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile"),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 5,right: 5,top: 50,bottom: 50),
          //height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    child: selectImageOptions(context, setImage, 'photo'),
                                  ),
                                );
                              },
                            );
                          },
                          child: Wrap(
                            children: [
                              (userProfileData.profilePic == '' && _croppedImage ==  null)?
                              Container(
                                width: 120.0,
                                height: 120.0,
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 75,
                                    color: Colors.grey,
                                  ),
                                ),
                                decoration: new BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: new BorderRadius.all(Radius.circular(8)),
                                ),
                              ):
                              ( _croppedImage == null)?
                              Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image: new NetworkImage(userProfileData.profilePic),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ):
                              Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image: new FileImage(_croppedImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                        SizedBox(width:15,),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Container(
                            padding: EdgeInsets.only(top: 25),
                            width: 210,
                            child: TextFormField(
                              initialValue: userProfileData.name,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: Colors.white24,
                                hintText: 'Sample Name',
                                labelText: 'Name *',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _name = value;
                              },
                            ),
                          ),
                        ),
                      ]
                    ),

                  ],
                ),
                SizedBox(height: 40,),

                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: secondaryColor,),
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop('Cancel');
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: secondaryColor,),
                          child: const Text("Update"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (_croppedImage != null) {
                                profileFileUrl = await uploadFile(_croppedImage, user, 'postPic');
                                if (profileFileUrl == null) {
                                  Fluttertoast.showToast(msg: 'File update failed, Try later', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                                  Navigator.pop(context);
                                  return null;
                                }
                              }
                              if(_name.length>2){
                                await Database(uid: user.uid).editProfile(
                                    name: _name,
                                    imageUrl: profileFileUrl
                                );
                              }
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    )),
                SizedBox(height: 20,),

                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlue,
                      foregroundColor: Colors.black
                      ),
                    child: Text("Delete All Post"),
                    onPressed: () async {
                      var response = await Database(uid: user.uid).deleteAllPost(postIds: userProfileData.postListID);
                      print("res: $response");
                      Navigator.of(context).pop();
                    },
                  )
                ),
                SizedBox(height: 20,),
                Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: lightGreen,
                          foregroundColor: Colors.black),
                      child: Text("Delete All Chats"),
                      onPressed: () async {
                        var snapshots = await FirebaseFirestore.instance.collection('chats').where('userIds', arrayContains: user.uid).get();
                        var document = snapshots.docs;
                        List chatIDs = [];
                        for(var data in document){
                          chatIDs.add(data['chatID']);
                        }
                        var response = await Database(uid: user.uid).deleteAllChats(chatIds: chatIDs, userIDS: userProfileData.chattingUsers);
                        print("res: $response");
                        Navigator.of(context).pop();
                      },
                    )
                ),
                SizedBox(height: 20,),

                Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: lightRed,
                          foregroundColor: Colors.black),
                      child: Text("Delete Account"),
                      onPressed: () async {
                        await FirebaseAuth.instance.currentUser.delete();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => entryScreen(),
                          ),
                        );
                      },
                    )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
