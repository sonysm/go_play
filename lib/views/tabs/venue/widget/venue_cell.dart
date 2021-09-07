import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/models/venue.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/venue/venue_detail_screen.dart';
import 'package:kroma_sport/widgets/cache_image.dart';

class VenueCell extends StatelessWidget {
  final Venue venue;

  const VenueCell({
    Key? key,
    required this.venue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var urlVenue =
        'https://images.unsplash.com/photo-1487466365202-1afdb86c764e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1052&q=80';

    return Container(
      // height: 220.0,
      // margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            venue.profilePhoto != null
                ? Hero(
                  tag: 'venue_profile${venue.id}',
                  child: CacheImage(
                      url: venue.profilePhoto!, type: ImageErrorType.venue),
                )
                : CachedNetworkImage(
                    imageUrl: urlVenue,
                    fit: BoxFit.cover,
                  ),
            // Container(color: Colors.black.withOpacity(0.3),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 8.0, right: 8.0, bottom: 12.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black87,
                        Color(0x00000000),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    venue.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Icon(
                //       Feather.map_pin,
                //       color: whiteColor,
                //       size: 14.0,
                //     ),
                //     4.width,
                //     Flexible(
                //       child: Text(
                //         venue.address,
                //         style: TextStyle(
                //           color: whiteColor,
                //           fontSize: 14.0,
                //         ),
                //         maxLines: 2,
                //         strutStyle: StrutStyle(fontSize: 14.0),
                //       ),
                //     ),
                //   ],
                // ),
                // 8.height,
                /*Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber[700],
                      size: 20.0,
                    ),
                    4.width,
                    Text(
                      '4.5',
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),*/
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Text(
                      //   'Pitches: 7',
                      //   style: TextStyle(
                      //     color: whiteColor,
                      //     fontSize: 14.0,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      Spacer(),
                      Icon(
                        Icons.star,
                        color: Colors.amber[700],
                        size: 18.0,
                      ),
                      4.width,
                      Text(
                        '4.5',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Spacer(),
                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //     padding: MaterialStateProperty.all(
                      //         EdgeInsets.symmetric(horizontal: 32.0)),
                      //     elevation: MaterialStateProperty.all(0),
                      //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //     backgroundColor:
                      //         MaterialStateProperty.all(whiteColor),
                      //     foregroundColor:
                      //         MaterialStateProperty.all(mainColor),
                      //   ),
                      //   onPressed: () {
                      //     launchScreen(
                      //       context,
                      //       VenueDetailScreen.tag,
                      //       arguments: venue,
                      //     );
                      //   },
                      //   child: Text(
                      //     'View',
                      //     style: TextStyle(
                      //       fontSize: 14.0,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => launchScreen(
                  context,
                  VenueDetailScreen.tag,
                  arguments: venue,
                ),
                child: Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VenueCell2 extends StatelessWidget {
  final String image;
  final String name;

  const VenueCell2({
    Key? key,
    required this.image,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 220.0,
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        // decoration: BoxDecoration(
        //   color: Theme.of(context).primaryColor,
        //   borderRadius: BorderRadius.circular(8.0),
        //   image: DecorationImage(
        //     image: CachedNetworkImageProvider(
        //       venue.coverPhoto ??
        //           'https://images.unsplash.com/photo-1487466365202-1afdb86c764e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1052&q=80',
        //     ),
        //     fit: BoxFit.cover,
        //     colorFilter: ColorFilter.mode(
        //         Colors.black.withOpacity(0.3), BlendMode.colorBurn),
        //   ),
        // ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CacheImage(url: image),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Feather.map_pin,
                          color: whiteColor,
                          size: 14.0,
                        ),
                        4.width,
                        Flexible(
                          child: Text(
                            'Khan Sensok, Phnom Penh',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 14.0,
                            ),
                            strutStyle: StrutStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                    // 8.height,
                    /*Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber[700],
                          size: 20.0,
                        ),
                        4.width,
                        Text(
                          '4.5',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),*/
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Text(
                        //   'Pitches: 7',
                        //   style: TextStyle(
                        //     color: whiteColor,
                        //     fontSize: 14.0,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        Icon(
                          Icons.star,
                          color: Colors.amber[700],
                          size: 20.0,
                        ),
                        4.width,
                        Text(
                          '4.5',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 32.0)),
                            elevation: MaterialStateProperty.all(0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                MaterialStateProperty.all(whiteColor),
                            foregroundColor:
                                MaterialStateProperty.all(mainColor),
                          ),
                          onPressed: () {},
                          child: Text(
                            'View',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
