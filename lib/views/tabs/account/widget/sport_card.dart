import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';

class SportCard extends StatelessWidget {
  final FavoriteSport favSport;
  final VoidCallback? onCardTap;
  const SportCard({
    Key? key,
    required this.favSport,
    this.onCardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap,
      child: Container(
        width: 320.0,
        margin: const EdgeInsets.only(top: 24.0, bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
            colors: [
              mainColor,
              mainColor,
              mainColor,
              Colors.green[400]!,
              Colors.lightGreen[400]!,
              Colors.lightGreen[300]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favSport.sport.name,
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                32.height,
                Text(
                  'Beginner',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                16.height,
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 44.0,
                          height: 44.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.teal[200],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            '0',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        4.height,
                        Text(
                          'Games',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    16.width,
                    Column(
                      children: [
                        Container(
                          width: 44.0,
                          height: 44.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.yellow[800],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            '0',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        4.height,
                        Text(
                          'Scores',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Positioned(
              top: -32.0,
              right: 0,
              child: SvgPicture.asset(
                svgSoccerBall2,
                width: 60,
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
