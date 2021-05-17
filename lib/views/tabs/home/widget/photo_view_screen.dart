import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPhotoScreen extends StatefulWidget {
  static const tag = '/viewPhotoScreen';

  final Post post;
  ViewPhotoScreen({Key? key, required this.post}) : super(key: key);

  @override
  _ViewPhotoScreenState createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
  var showDescription = true;

  PhotoViewController photoViewController = PhotoViewController();
  PhotoViewScaleStateController scaleStateController =
      PhotoViewScaleStateController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            setState(() {
              showDescription = !showDescription;
            });
          },
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
                          initialScale: PhotoViewComputedScale.contained * 0.8,
                          heroAttributes:
                              PhotoViewHeroAttributes(tag: image.id),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: 1.0,
                          scaleStateController: scaleStateController,
                          scaleStateCycle: (state) {
                            return state == PhotoViewScaleState.initial
                                ? PhotoViewScaleState.covering
                                : PhotoViewScaleState.initial;
                          });
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
                  ),
                  /*PhotoView(
                    //controller: photoViewController,
                    //scaleStateController: scaleStateController,
                    backgroundDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    tightMode: true,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: 1.5,
                    imageProvider:
                        CachedNetworkImageProvider(widget.post.photo!),
                    loadingBuilder: (context, event) {
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(whiteColor),
                      );
                    },
                    scaleStateChangedCallback: (photoScaleState) {},
                  ),*/
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
    );
  }
}
