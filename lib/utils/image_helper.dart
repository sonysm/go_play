import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

Future<File?> _getCameraImage(
    {bool isCropped = true, bool isRectangle = false}) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      if (isCropped) {
        File? croppedFile = await ImageCropper().cropImage(
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
        File? croppedFile = await ImageCropper().cropImage(
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
  showKSBottomSheet(context, children: [
    Container(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
      child: Text(
        'Choose Photo',
        style: Theme.of(context).textTheme.headline6,
      ),
    ),
    TextButton(
      style: ButtonStyle(
        padding:
            MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 0.0)),
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
                color: isLight(context)
                    ? Colors.blueGrey[700]
                    : Colors.blueGrey[100],
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
        padding:
            MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 0.0)),
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
                color: isLight(context)
                    ? Colors.blueGrey[700]
                    : Colors.blueGrey[100],
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
  ]);
}
