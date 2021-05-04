import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class CreatPostScreen extends StatefulWidget {
  static const String tag = '/createPostScreen';
  CreatPostScreen({Key? key}) : super(key: key);

  @override
  _CreatPostScreenState createState() => _CreatPostScreenState();
}

class _CreatPostScreenState extends State<CreatPostScreen> {
  File? imageFile;
  File? reuseImage;

  final picker = ImagePicker();

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Create Post'),
      elevation: 0.5,
      forceElevated: true,
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            'Share',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: mainColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget buildPostHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
        color: Theme.of(context).primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Avatar(
              radius: 24.0,
              imageUrl: KS.shared.user.photo,
            ),
            8.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    KS.shared.user.getFullname(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    'Only followers can see your post.',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPostCaption() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                maxLines: null,
                minLines: 1,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: 'What\'s going on?',
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Divider(),
          ],
        ),
      ),
    );
  }

  Widget addPhotoButton() {
    return imageFile == null
        ? Container(
            height: 54.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border(top: BorderSide(width: 0.2, color: Colors.grey)),
            ),
            child: TextButton(
              onPressed: getImage,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.grey[200]),
                foregroundColor: MaterialStateProperty.all(mainColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FeatherIcons.camera),
                  8.width,
                  Text(
                    'Add Photo',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.w600, color: mainColor),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  Widget buildPhoto() {
    return SliverToBoxAdapter(
      child: imageFile != null
          ? Container(
              child: Stack(
                children: [
                  Image.file(imageFile!),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      child: CupertinoButton(
                        borderRadius: BorderRadius.zero,
                        padding: EdgeInsets.zero,
                        minSize: 24.0,
                        child: Stack(
                          children: [
                            Positioned(
                              //left: 1.0,
                              //top: 1.0,
                              child: Icon(
                                FeatherIcons.x,
                                size: 24.0,
                                color: Colors.black54,
                              ),
                            ),
                            Icon(
                              FeatherIcons.x,
                              size: 22.0,
                              color: whiteColor,
                            ),
                          ],
                        ),
                        onPressed: () {
                          imageFile = null;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    left: 8.0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 32.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: blackColor.withOpacity(0.5),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          File? croppedFile = await ImageCropper.cropImage(
                              sourcePath: reuseImage!.path,
                              androidUiSettings: AndroidUiSettings(
                                toolbarWidgetColor: whiteColor,
                                toolbarColor: mainColor,
                                lockAspectRatio: false,
                                activeControlsWidgetColor: mainColor,
                              ));
                          if (croppedFile != null) {
                            imageFile = croppedFile;
                            setState(() {});
                          }
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 16.0)),
                          minimumSize: MaterialStateProperty.all(Size(0, 0)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              color: whiteColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  buildNavbar(),
                  buildPostHeader(),
                  buildPostCaption(),
                  buildPhoto(),
                ],
              ),
              Positioned(bottom: 0, left: 0, right: 0, child: addPhotoButton()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        reuseImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
