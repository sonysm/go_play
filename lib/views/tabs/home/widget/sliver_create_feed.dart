import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class SliverCreateFeed extends StatelessWidget {
  final VoidCallback onPost;
  final VoidCallback onActivity;
  const SliverCreateFeed({
    Key? key,
    required this.onPost,
    required this.onActivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UserCubit, User>(
                  builder: (context, user) {
                    return Avatar(
                      radius: 24.0,
                      user: user,
                    );
                  },
                ),
                8.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What\'s going on ${KS.shared.user.getFullname()}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'Share a photo, post or activity with your followers.',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onPost,
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(isLight(context) ? Colors.grey[100] : Colors.blueGrey[300]),
                      foregroundColor: MaterialStateProperty.all(ColorResources.getMainColor(context)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FeatherIcons.camera),
                        8.width,
                        Text(
                          'Post',
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorResources.getMainColor(context),
                                fontSize: 18.0,
                              ),
                          strutStyle: StrutStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: onActivity,
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(isLight(context) ? Colors.grey[100] : Colors.blueGrey[300]),
                      foregroundColor: MaterialStateProperty.all(ColorResources.getMainColor(context)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FeatherIcons.activity),
                        8.width,
                        Text(
                          'Activity',
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                                color: ColorResources.getMainColor(context),
                              ),
                          strutStyle: StrutStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
