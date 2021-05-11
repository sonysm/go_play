import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
  late TextEditingController descController;

  List<Asset> images = <Asset>[];
  List<MultipartFile> files = [];

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Create Post'),
      elevation: 0.5,
      forceElevated: true,
      actions: [
        TextButton(
          onPressed: availablePost() ? onPost : null,
          child: Text(
            'Post',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: availablePost() ? mainColor : Colors.green[200],
                fontWeight: FontWeight.w600),
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
              user: KS.shared.user,
              isSelectable: false,
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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextField(
          controller: descController,
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
          onChanged: (text) {
            setState(() {});
          },
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

  Widget buildPhotoList() {
    return images.isNotEmpty
        ? SliverPadding(
            padding: const EdgeInsets.only(bottom: 62.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                Asset asset = images.elementAt(index);
                return KeepAlive(
                  keepAlive: true,
                  child: IndexedSemantics(
                    index: index,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: Stack(
                        children: [
                          AssetThumb(
                            asset: asset,
                            width: asset.originalWidth!,
                            height: asset.originalHeight!,
                          ),
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
                                  images.removeAt(index);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
                  childCount: images.length,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  addSemanticIndexes: false),
            ),
          )
        : SliverToBoxAdapter();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (availablePost()) {
          FocusScope.of(context).unfocus();
          showKSConfirmDialog(context, 'Are you sure you want to discard post?',
              () {
            dismissScreen(context);
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
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
                    //buildPhoto(),
                    buildPhotoList(),
                  ],
                ),
                Positioned(
                    bottom: 0, left: 0, right: 0, child: addPhotoButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getImage();
    descController = TextEditingController();
  }

  Future getImage() async {
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);

    //setState(() {
    //  if (pickedFile != null) {
    //    imageFile = File(pickedFile.path);
    //    reuseImage = File(pickedFile.path);
    //  } else {
    //    print('No image selected.');
    //  }
    //});

    List<Asset>? assetList;
    String imageKey = 'images';
    try {
      assetList = await MultiImagePicker.pickImages(
        maxImages: 10,
        selectedAssets: images,
      );
    } on Exception catch (_) {}

    if (!mounted) return;

    if (assetList != null) {
      images = assetList;
      setState(() {});
    }

    if (assetList != null) {
      Future.forEach(assetList, (element) async {
        {
          ByteData byteData = await (element as Asset).getByteData();
          List<int> imageData = byteData.buffer.asUint8List();

          files.add(MultipartFile.fromBytes(
            imageKey,
            imageData,
            filename: 'FD' +
                DateTime.now().millisecondsSinceEpoch.toString() +
                '.jpg',
          ));
        }
      }).then((value) {
        //showKSLoading(context);
        //TmsService().uploadPhotoGallery(files: files).then((user) {
        //  if (user != null) {
        //    widget.userDetails.user = user;
        //    TMS.shared.user = user;
        //    Navigator.pop(context);
        //    setState(() {});
        //  }
        //});
      });
    }
  }

  bool availablePost() {
    if (descController.text.trim().length > 0 || images.isNotEmpty) {
      return true;
    }
    return false;
  }

  onPost() async {
    FocusScope.of(context).unfocus();
    KSHttpClient _client = KSHttpClient();
    Map<String, String> fields = Map<String, String>();
    if (descController.text.trim().isNotEmpty) {
      fields['description'] = descController.text;
    }
    showKSLoading(context);
    var data = await _client.postUploads('/create/feed', files, fields: fields);
    if (data != null) {
      dismissScreen(context);
      if (data is! HttpResult) {
        dismissScreen(context);
        var newPost = Post.fromJson(data);
        BlocProvider.of<HomeCubit>(context).onPostFeed(newPost);
      }
    }
  }
}
