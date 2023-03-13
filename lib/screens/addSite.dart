import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sitemark/screens/constantData.dart';
import '../database/database.dart';
import '../functions/getImageForPost.dart';
import '../functions/randomGen.dart';
import '../models/user.dart';

class addSite extends StatefulWidget {

  String title;
  String description;
  String imageUrl;
  String postId;

  addSite(BuildContext context, {Key key, @required this.title, @required this.description, @required this.imageUrl, @required this.postId}) : super(key: key);
  @override
  State<addSite> createState() => _addSiteState();
}

class _addSiteState extends State<addSite> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  String _title = '';
  File _croppedImage;
  String profileFileUrl = '';

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


    return Scaffold(
      appBar: AppBar(
        title: (widget.title == null) ? Text('Add New Post'): Text('Edit Post'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 5,right: 5,top: 50,bottom: 50),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
                        (_croppedImage == null && (widget.imageUrl == null || widget.imageUrl == ''))?
                        Container(
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
                            color: secondaryColor,
                            borderRadius: new BorderRadius.all(Radius.circular(8)),
                          ),
                        ):
                        (widget.imageUrl != null && widget.imageUrl != '' && _croppedImage == null)?
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              image: new NetworkImage(widget.imageUrl),
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
                    )),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: TextFormField(
                      initialValue: widget.title,
                    maxLines: 2,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.white24,
                      icon: Icon(Icons.drive_file_rename_outline, color: Colors.white),
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
                  padding: EdgeInsets.all(2.0),
                  child: TextFormField(
                    initialValue: widget.description,
                    maxLines: 5,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.white24,
                      icon: Icon(Icons.abc, color: Colors.white),
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
                          child: (widget.title == null)?Text("Add"):Text("Save"),
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
                              if(widget.title == null){
                                await Database(uid: user.uid).addNewPost(
                                    title: _title,
                                    description: _description,
                                    imageUrl: profileFileUrl,
                                    postedTime: Timestamp.now(),
                                    postId: getRandomString(10),
                                    profileName: userProfileData.name
                                );
                              }else{
                                await Database(uid: user.uid).editPost(
                                  title: (_title != '')?_title:widget.title,
                                  description: (_description != '')?_description:widget.description,
                                  imageUrl: (widget.imageUrl != null && widget.imageUrl != '' && _croppedImage == null)?widget.imageUrl:profileFileUrl,
                                  postId: widget.postId,
                                  profileName: userProfileData.name
                                );
                              }
                                Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
