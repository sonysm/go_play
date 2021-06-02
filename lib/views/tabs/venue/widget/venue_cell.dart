import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/venue/venue_detail_screen.dart';

class VenueCell extends StatelessWidget {
  final String venueName;
  final String venueImage;

  const VenueCell({
    Key? key,
    required this.venueName,
    required this.venueImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchScreen(context, VenueDetailScreen.tag);
      },
      child: Container(
        height: 220.0,
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              venueImage,
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.colorBurn),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                venueName,
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Feather.map_pin,
                    color: whiteColor,
                    size: 14.0,
                  ),
                  4.width,
                  Text(
                    'Phnom Penh',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 14.0,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              8.height,
              Row(
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
              ),
              Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Pitches: 7',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 14.0,
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
                      backgroundColor: MaterialStateProperty.all(whiteColor),
                      foregroundColor: MaterialStateProperty.all(mainColor),
                    ),
                    onPressed: () {
                      launchScreen(context, VenueDetailScreen.tag);
                    },
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
      ),
    );
  }
}
