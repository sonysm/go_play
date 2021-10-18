import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kroma_sport/models/team.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:line_icons/line_icons.dart';

class TeamCell extends StatelessWidget {
  final VoidCallback? onMoreTap;
  final Team team;
  const TeamCell({Key? key, required this.team, this.onMoreTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 32.0),
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            decoration: BoxDecoration(
              color: ColorResources.getPrimary(context),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(blurRadius: 4.0, color: Colors.black12, offset: Offset(1, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: onMoreTap,
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
                          foregroundColor: MaterialStateProperty.all(Colors.grey),
                          shape: MaterialStateProperty.all(CircleBorder()),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: MaterialStateProperty.all(EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                          minimumSize: MaterialStateProperty.all(Size.zero)),
                      child: Icon(LineIcons.verticalEllipsis),
                    )
                  ],
                ),
                Text(
                  team.teamInfo.name,
                  style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w600),
                ),
                16.height,
                Row(
                  children: [
                    Icon(
                      LineIcons.futbol,
                      size: 18.0,
                    ),
                    8.width,
                    Text(team.teamInfo.sport.name)
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Icon(
                      LineIcons.tShirt,
                      size: 18.0,
                    ),
                    8.width,
                    Text('Player-coach')
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: Dimensions.PADDING_SIZE_SMALL,
            top: Dimensions.PADDING_SIZE_DEFAULT,
            child: Container(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
              child: Icon(
                LineIcons.alternateShield,
                size: 32.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
