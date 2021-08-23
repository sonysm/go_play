import 'package:flutter/material.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class SuggestionCell extends StatefulWidget {
  SuggestionCell({Key? key}) : super(key: key);

  @override
  _SuggestionCellState createState() => _SuggestionCellState();
}

class _SuggestionCellState extends State<SuggestionCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      margin: EdgeInsets.only(bottom: 8.0),
      color: ColorResources.getPrimary(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'These are official contributor',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return FollowCell();
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 8.0);
              },
              itemCount: 5,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class FollowCell extends StatelessWidget {
  const FollowCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize(context).appWidth(50) - 48,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: ColorResources.getPrimary(context),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          width: 0.5,
          color: ColorResources.getSuggestionBorderColor(context),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Avatar(radius: 32.0, user: KS.shared.user),
              SizedBox(height: 8.0),
              Text(
                '${KS.shared.user.getFullname()}',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w600, fontFamily: 'Metropolis'),
              ),
            ],
          ),
          Positioned(
            left: 8.0,
            right: 8.0,
            bottom: 0,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                        color: isLight(context)
                            ? Colors.blueGrey
                            : Colors.grey[300]!),
                  ),
                ),
                overlayColor: MaterialStateProperty.all(ColorResources.getOverlayIconColor(context)),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: MaterialStateProperty.all(
                    isLight(context) ? Colors.blueGrey : Colors.grey[300]),
              ),
              child: Text(
                'Follow',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Metropolis',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
