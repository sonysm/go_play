import 'dart:io';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:any_link_preview/web_analyzer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
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
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:linkify/linkify.dart';

class CreatPostScreen extends StatefulWidget {
  static const String tag = '/createPostScreen';
  final String? sharedInfo;
  CreatPostScreen({Key? key, this.sharedInfo}) : super(key: key);

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

  var exUrl;

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Create Post'),
      centerTitle: true,
      elevation: 0.5,
      forceElevated: true,
      pinned: true,
      leading: ElevatedButton(
        onPressed: () {
          widget.sharedInfo != null
              ? SystemNavigator.pop()
              : dismissScreen(context);
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(
              isLight(context) ? mainColor : whiteColor),
        ),
        child: Icon(Icons.arrow_back),
      ),
      actions: [
        TextButton(
          onPressed: availablePost() ? onPost : null,
          child: Text(
            'Post',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: availablePost()
                    ? isLight(context)
                        ? mainColor
                        : mainDarkColor
                    : isLight(context)
                        ? Colors.green[200]
                        : Colors.green[100],
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

  // final RegExp urlRegExp = RegExp(
  //     r'^(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})');

  final RegExp urlRegExp = RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.))?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
    caseSensitive: false,
  );

  // final urlRegExp = RegExp(
  //   r'^(.*?)((https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*))',
  //   caseSensitive: false,
  //   dotAll: true,
  // );

  final _protocolIdentifierRegex = RegExp(
    r'^(https?:\/\/)',
    caseSensitive: false,
  );

  Widget buildPostCaption() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
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
            final urlMatches = urlRegExp.allMatches(text);

            List<String> urls = urlMatches
                .map((urlMatch) => text.substring(urlMatch.start, urlMatch.end))
                .toList();

            urls.forEach((x) => print(x));
            if (urls.isNotEmpty) {
              _url = urls.elementAt(0);

              if (!_url!.startsWith(_protocolIdentifierRegex)) {
                _url =
                    (LinkifyOptions().defaultToHttps ? "https://" : "http://") +
                        _url!;
              }
            }

            if (_url != null &&
                    _url!.startsWith(_protocolIdentifierRegex) &&
                    text.endsWith(' ') ||
                text.endsWith('\n')) {
              setState(() {});
            }
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
                foregroundColor: MaterialStateProperty.all(
                    isLight(context) ? mainColor : mainDarkColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FeatherIcons.camera),
                  8.width,
                  Text(
                    'Add Photo',
                    strutStyle: StrutStyle(fontSize: 20.0),
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isLight(context) ? mainColor : mainDarkColor,
                        ),
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
          showKSConfirmDialog(
            context,
            message: 'Are you sure you want to discard post?',
            onYesPressed: () {
              dismissScreen(context);
            },
          );
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
                    buildUrlWidget(),
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

  String? _url;
  WebInfo? linkInfo;

  Widget buildUrlWidget() {
    if (images.isEmpty) {
      if (_url != null) {
        return SliverToBoxAdapter(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 12.0),
                child: AnyLinkPreview(
                  link: _url!,
                  borderRadius: 0,
                  cache: Duration(days: 1),
                  bodyMaxLines: 2,
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.3),
                    ),
                  ],
                  backgroundColor: Colors.grey[50],
                  errorTitle: '',
                  errorWidget: Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey[300],
                    child: Text('Oops!, unavailable to fetch data.'),
                  ),
                  placeholderWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(Colors.grey[400]),
                        ),
                      ),
                      8.width,
                      Text(
                        'Fetching data...',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  webInfoCallback: (webInfo) {
                    exUrl = _url;
                    if (webInfo != null) {
                      linkInfo = webInfo;
                    }
                  },
                ),
              ),
              Positioned(
                right: 24.0,
                top: 0,
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {
                      _url = null;
                      exUrl = null;
                      linkInfo = null;
                      setState(() {});
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                        shape: MaterialStateProperty.all(CircleBorder()),
                        alignment: Alignment.center),
                    child: Icon(
                      FeatherIcons.x,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return SliverToBoxAdapter();
      }
    }

    return SliverToBoxAdapter();

    // return images.isEmpty
    //     ? _url != null
    //         ? SliverToBoxAdapter(
    //             child: Stack(
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.all(16.0),
    //                   child: AnyLinkPreview(
    //                     link: _url!,
    //                     borderRadius: 0,
    //                     cache: Duration(days: 1),
    //                     bodyMaxLines: 2,
    //                     boxShadow: [
    //                       BoxShadow(
    //                         color: blackColor.withOpacity(0.3),
    //                       ),
    //                     ],
    //                     backgroundColor: Colors.grey[50],
    //                     errorTitle: '',
    //                     errorWidget: Container(
    //                       padding: const EdgeInsets.all(16.0),
    //                       color: Colors.grey[300],
    //                       child: Text('Oops!, unavailable to fetch data.'),
    //                     ),
    //                     placeholderWidget: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         SizedBox(
    //                           width: 24.0,
    //                           height: 24.0,
    //                           child: CircularProgressIndicator(
    //                             strokeWidth: 2.0,
    //                             valueColor:
    //                                 AlwaysStoppedAnimation(Colors.grey[400]),
    //                           ),
    //                         ),
    //                         8.width,
    //                         Text(
    //                           'Fetching data...',
    //                           style: TextStyle(color: Colors.grey[400]),
    //                         ),
    //                       ],
    //                     ),
    //                     webInfoCallback: (webInfo) {
    //                       initUrl = _url;
    //                       if (webInfo != null) {
    //                         // print('____create___ ${webInfo.title}');
    //                         // print('____create___ ${webInfo.description}');
    //                         // print('____create___ ${webInfo.image}');
    //                         linkInfo = webInfo;
    //                       }
    //                     },
    //                   ),
    //                 ),
    //                 Positioned(
    //                   right: 24.0,
    //                   top: 2,
    //                   child: SizedBox(
    //                     width: 28,
    //                     height: 28,
    //                     child: ElevatedButton(
    //                       onPressed: () {
    //                         _url = null;
    //                         setState(() {});
    //                       },
    //                       style: ButtonStyle(
    //                           padding:
    //                               MaterialStateProperty.all(EdgeInsets.zero),
    //                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //                           backgroundColor:
    //                               MaterialStateProperty.all(Colors.grey),
    //                           shape: MaterialStateProperty.all(CircleBorder()),
    //                           alignment: Alignment.center),
    //                       child: Icon(
    //                         FeatherIcons.x,
    //                         size: 20,
    //                       ),
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           )
    //         : SliverToBoxAdapter()
    //     : SliverToBoxAdapter();
  }

  @override
  void initState() {
    super.initState();
    descController = TextEditingController();
    if (widget.sharedInfo != null) {
      descController.text = widget.sharedInfo!;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        checkShareInfoString(widget.sharedInfo!);
      });
    }
  }

  String imageKey = 'images';

  Future getImage() async {
    List<Asset>? assetList;
    try {
      assetList = await MultiImagePicker.pickImages(
        maxImages: 10,
        selectedAssets: images,
      );
    } on Exception catch (_) {}

    if (!mounted) return;

    if (assetList != null) {
      images = assetList;
      _url = null;
      setState(() {});
    }

    // if (assetList != null) {
    //   Future.forEach(assetList, (element) async {
    //     {
    //       ByteData byteData = await (element as Asset).getByteData();
    //       List<int> imageData = byteData.buffer.asUint8List();

    //       files.add(MultipartFile.fromBytes(
    //         imageKey,
    //         imageData,
    //         filename: 'FD' +
    //             DateTime.now().millisecondsSinceEpoch.toString() +
    //             '.jpg',
    //       ));
    //     }
    //   }).then((value) {
    //     //showKSLoading(context);
    //     //TmsService().uploadPhotoGallery(files: files).then((user) {
    //     //  if (user != null) {
    //     //    widget.userDetails.user = user;
    //     //    TMS.shared.user = user;
    //     //    Navigator.pop(context);
    //     //    setState(() {});
    //     //  }
    //     //});
    //   });
    // }
  }

  bool availablePost() {
    if (descController.text.trim().length > 0 || images.isNotEmpty) {
      return true;
    } else if (exUrl != null) {
      return true;
    }
    return false;
  }

  onPost() async {
    // if (exUrl != null) print('______url: $exUrl');

    FocusScope.of(context).unfocus();
    KSHttpClient _client = KSHttpClient();
    Map<String, String> fields = Map<String, String>();
    if (descController.text.trim().isNotEmpty) {
      fields['description'] = descController.text;
    }

    await Future.forEach(images, (element) async {
      {
        ByteData byteData = await (element as Asset).getByteData();
        List<int> imageData = byteData.buffer.asUint8List();

        files.add(MultipartFile.fromBytes(
          imageKey,
          imageData,
          filename:
              'FD' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg',
        ));
      }
    });

    if (linkInfo != null) {
      if (files.isEmpty) {
        fields['is_external'] = '1';
        if (linkInfo!.image != null) {
          fields['ex_photo'] = linkInfo!.image!;
        }
      }
      fields['ex_desc'] = linkInfo!.description!;
      fields['ex_title'] = linkInfo!.title!;
      fields['ex_link'] = exUrl!;
    }

    showKSLoading(context);
    var data = await _client.postUploads('/create/feed', files, fields: fields);
    if (data != null) {
      dismissScreen(context);
      if (data is! HttpResult) {
        if (widget.sharedInfo != null) {
          SystemNavigator.pop();
          return;
        }
        dismissScreen(context);
        var newPost = Post.fromJson(data);
        BlocProvider.of<HomeCubit>(context).onPostFeed(newPost);
      } else {
        if (data.code == -500) {
          showKSMessageDialog(context, 'No Internet Connnection', () {},
              buttonTitle: 'OK');
          return;
        }
        showKSMessageDialog(
            context,
            'Something went wrong with the content! Image size might be too large!',
            () {},
            buttonTitle: 'OK');
      }
    }
  }

  void checkShareInfoString(String text) {
    final urlMatches = urlRegExp.allMatches(text);

    List<String> urls = urlMatches
        .map((urlMatch) => text.substring(urlMatch.start, urlMatch.end))
        .toList();

    urls.forEach((x) => print(x));
    if (urls.isNotEmpty) {
      _url = urls.elementAt(0);

      if (!_url!.startsWith(_protocolIdentifierRegex)) {
        _url =
            (LinkifyOptions().defaultToHttps ? "https://" : "http://") + _url!;
      }

      if (_url != null) {
        setState(() {});
      }
    }
  }
}
