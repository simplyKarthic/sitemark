import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';

import '../screens/constantData.dart';

Future<File> imageCrop(File imageFile) async {
  CroppedFile croppedFile = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    aspectRatioPresets: [CropAspectRatioPreset.square,],
    compressQuality: 50,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop your image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        title: 'Edit your image',
      )],
  );
  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    Fluttertoast.showToast(msg:'Image selection failed', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
    return null;
  }
}


Future<File> pickImage(bool camera, String option) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: camera ? ImageSource.camera : ImageSource.gallery);

  if (pickedFile != null) {
    File tempImage = await imageCrop(File(pickedFile.path));
    return tempImage;
  } else {
    return null;
  }
}

selectImageOptions(context, Function setImage, String option) {
  File tempImage;
  return Container(
    color: secondaryColor,
    height: 300,
    width: MediaQuery.of(context).size.width * 0.8,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Upload a image',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10,),
        Text(
          'Choose a image from Gallery or Camera',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(color: Colors.white, fontSize: 18),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                tempImage = await pickImage(false, option);
                if (tempImage != null) {
                  setImage(tempImage);
                  Fluttertoast.showToast(msg:'image selected successfully', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(msg:'Image selection failed, Try Again!', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                  return 0;
                }
              },
              icon: Icon(Icons.image),
              label: Text('Gallery'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                tempImage = await pickImage(true, option);
                if (tempImage != null) {
                  Fluttertoast.showToast(msg:'image selected successfully', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                  setImage(tempImage);
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(msg:'Image selection failed, Try Again!', toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3);
                  return 0;
                }
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Camera'),
            ),
          ],
        ),
      ],
    ),
  );
}