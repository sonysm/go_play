import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPhotoScreen extends StatefulWidget {
  static const tag = '/viewPhotoScreen';

  final Post post;
  final int initailIndex;
  ViewPhotoScreen({Key? key, required this.post, this.initailIndex = 0})
      : super(key: key);

  @override
  _ViewPhotoScreenState createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
  var showDescription = true;
  PageController pageController = PageController();
  PhotoViewScaleStateController scaleStateController =
      PhotoViewScaleStateController();

  var activeIndex;

  @override
  void initState() {
    super.initState();
    activeIndex = widget.initailIndex + 1;
    Future.delayed(Duration.zero).then((value) {
      pageController.jumpToPage(widget.initailIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor:
              Theme.of(context).brightness == Brightness.light
                  ? Color.fromRGBO(113, 113, 113, 1)
                  : Color.fromRGBO(15, 15, 15, 1),
        ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            setState(() {
              showDescription = !showDescription;
            });
          },
          child: SafeArea(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  Center(
                    child: PhotoViewGallery.builder(
                      itemCount: widget.post.image!.length,
                      builder: (context, index) {
                        var image = widget.post.image!.elementAt(index);
                        return PhotoViewGalleryPageOptions(
                          imageProvider: CachedNetworkImageProvider(image.name),
                          initialScale: PhotoViewComputedScale.contained,
                          heroAttributes: PhotoViewHeroAttributes(tag: image.id),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.covered,
                          scaleStateController: scaleStateController,
                          scaleStateCycle: (state) {
                            return state == PhotoViewScaleState.initial
                                ? PhotoViewScaleState.covering
                                : PhotoViewScaleState.initial;
                          },
                        );
                      },
                      loadingBuilder: (context, event) {
                        return Center(
                          child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(whiteColor),
                            ),
                          ),
                        );
                      },
                      scaleStateChangedCallback: (photoScaleState) {},
                      pageController: pageController,
                      onPageChanged: (idx) {
                        setState(() => activeIndex = idx + 1);
                      },
                    ),
                  ),
                  Positioned(
                    left: 16.0,
                    top: 16.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 28.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                            color: whiteColor, shape: BoxShape.circle),
                        child: Icon(
                          Icons.close,
                          color: blackColor,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    top: 16.0,
                    child: showDescription ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text('$activeIndex/${widget.post.image!.length}', style: TextStyle(color: blackColor),),
                    ) : SizedBox(),
                  ),
                  widget.post.description != null
                      ? Positioned(
                          bottom: 0,
                          child: showDescription
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 300.0,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    width: AppSize(context).appWidth(100),
                                    // height: 300.0,
                                    color: blackColor.withOpacity(0.5),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        widget.post.description!,
                                        style: TextStyle(color: whiteColor),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
