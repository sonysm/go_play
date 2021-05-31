import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kroma_sport/utils/tools.dart';

Future<File?> _getCameraImage(
    {bool isCropped = true, bool isRectangle = false}) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.camera);
    if (pickedFile != null) {
      if (isCropped) {
        File? croppedFile = await ImageCropper.cropImage(
            sourcePath: pickedFile.path,
            cropStyle: isRectangle ? CropStyle.rectangle : CropStyle.circle,
            aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
        if (croppedFile != null) {
          return croppedFile;
        }
      }
      return File(pickedFile.path);
    }
  } catch (e) {}

  return null;
}

Future<File?> _getLibraryImage(
    {bool isCropped = true, bool isRectangle = false}) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isCropped) {
        File? croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          cropStyle: isRectangle ? CropStyle.rectangle : CropStyle.circle,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        );
        if (croppedFile != null) {
          return croppedFile;
        } else {
          return null;
        }
      }
      return File(pickedFile.path);
    }
  } catch (e) {}

  return null;
}

selectImage(BuildContext context, Function(File?) image,
    {bool isCropped = true, bool isRectangle = false}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) {
      return SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 16.0),
                child: Text(
                  'Choose Photo',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 0.0)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  image(await _getCameraImage(
                      isCropped: isCropped, isRectangle: isRectangle));
                },
                child: Container(
                  height: 54.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Icon(
                          Feather.camera,
                          color: isLight(context) ? Colors.blueGrey[700] : Colors.blueGrey[100],
                        ),
                      ),
                      Text(
                        'Take Photo',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 0.0)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  image(await _getLibraryImage(
                      isCropped: isCropped, isRectangle: isRectangle));
                },
                child: Container(
                  height: 54.0,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Icon(
                          Feather.image,
                          color: isLight(context) ? Colors.blueGrey[700] : Colors.blueGrey[100],
                        ),
                      ),
                      Text(
                        'Choose from gallery',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
