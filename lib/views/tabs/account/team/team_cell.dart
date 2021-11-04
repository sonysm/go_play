import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/team.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:line_icons/line_icons.dart';

class TeamCell extends StatelessWidget {
  final VoidCallback? onCellTap;
  final VoidCallback? onMoreTap;
  final Team team;
  const TeamCell({Key? key, required this.team, this.onCellTap, this.onMoreTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(blurRadius: 4.0, color: Colors.black12, offset: Offset(1, 2)),
              ],
            ),
            child: Material(
              color: ColorResources.getPrimary(context),
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                onTap: onCellTap,
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        team.teamInfo.name,
                        style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      8.height,
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
              ),
            ),
          ),
          Positioned(
            left: Dimensions.PADDING_SIZE_SMALL,
            top: -Dimensions.PADDING_SIZE_DEFAULT,
            child: ClipOval(
              child: Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.2, color: Colors.grey.shade400)
                ),
                child: team.teamInfo.photo != null ? CacheImage(url: team.teamInfo.photo!) : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset('assets/icons/ic_team.svg', color: Colors.grey[600],),
                ),
              ),
            ),
          ),
          if (KS.shared.user.id == team.owner.id)
            Positioned(
              right: 8.0,
              top: 8.0,
              child: ElevatedButton(
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
              ),
            )
        ],
      ),
    );
  }
}
