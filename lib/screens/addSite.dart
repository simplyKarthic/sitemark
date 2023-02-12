import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import '../database/database.dart';
import '../functions/getImageForPost.dart';
import '../functions/randomGen.dart';
import '../models/user.dart';

class addSite extends StatefulWidget {
  const addSite(BuildContext context, {Key key}) : super(key: key);

  @override
  State<addSite> createState() => _addSiteState();
}

class _addSiteState extends State<addSite> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  String _title = '';
  File _croppedImage;

  setImage(File imageFile) {
    setState(() {
      _croppedImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    UserProfileData userProfileData = Provider.of<UserProfileData>(context);

    Future<String> uploadFile(File document, UserData user, String documentName) async {
      Reference storageReference = FirebaseStorage.instance.ref().child('${user.uid}/postPictures/${getRandomString(10)}');
      await storageReference.putFile(document);
      String fileUrl = await storageReference.getDownloadURL().then((fileURL) {
        return fileURL;
      }).catchError((onError) {
        return null;
      });
      return fileUrl;
    }

    uploadPostPicture() async {
      if (_croppedImage != null) {
        String profileFileUrl = await uploadFile(_croppedImage, user, 'postPic');
        print("profileFileUrl: $profileFileUrl");

        if (profileFileUrl == null) {
          Fluttertoast.showToast(msg: 'File update failed, Try later', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
          Navigator.pop(context);
          return null;
        }else{
          await Database(uid: user.uid).addNewPost(
            title: _title,
            description: _description,
            imageUrl: profileFileUrl,
            posterTime: Timestamp.now().toString(),
            postId: getRandomString(10),
            profileName: userProfileData.name
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      print("printer tapped");
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
                        (_croppedImage != null)
                            ? Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image: new FileImage(_croppedImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                width: 120.0,
                                height: 120.0,
                                child: Center(
                                  child: Icon(
                                    Icons.folder_copy_outlined,
                                    size: 75,
                                    color: Colors.grey,
                                  ),
                                ),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.drive_file_rename_outline),
                      hintText: 'I have a doubt in....',
                      labelText: 'Title *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _title = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.link),
                      hintText: 'type your detailed description about the post ',
                      labelText: 'Description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop('Cancel');
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          child: Text("Add"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              uploadPostPicture();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
