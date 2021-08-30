import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/suggestion.dart';
import 'package:kroma_sport/models/user.dart';
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
    return BlocBuilder<SuggestionCubit, SuggestionData>(
      builder: (context, state) {
        // if (state.status == DataState.Loading) {
        //   return Container(
        //     height: 250.0,
        //     width: MediaQuery.of(context).size.width,
        //     child: Center(
        //       child: CircularProgressIndicator(),
        //     ),
        //   );
        // }

        return state.data.isNotEmpty
            ? Container(
                height: 250.0,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                margin: EdgeInsets.only(bottom: 8.0),
                color: ColorResources.getPrimary(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'These are the official contributors',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Metropolis',
                            ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final user = state.data.elementAt(index);

                          return FollowCell(user: user);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 8.0);
                        },
                        itemCount: state.data.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox();
      },
    );
  }
}

class FollowCell extends StatefulWidget {
  final User user;
  const FollowCell({Key? key, required this.user}) : super(key: key);

  @override
  _FollowCellState createState() => _FollowCellState();
}

class _FollowCellState extends State<FollowCell> {
  bool isFollowing = false;

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Avatar(
                radius: 32.0,
                user: widget.user,
                onTap: (_) {},
              ),
              SizedBox(height: 8.0),
              Text(
                '${widget.user.getFullname()}',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.w600, fontFamily: 'Metropolis'),
              ),
            ],
          ),
          Positioned(
            left: 8.0,
            right: 8.0,
            bottom: 0,
            child: ElevatedButton(
              onPressed: () {
                isFollowing = !isFollowing;
                setState(() {});
              },
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(
                      color: isLight(context)
                          ? Colors.blueGrey
                          : (isFollowing ? Colors.blueGrey : Colors.grey[300]!),
                    ),
                  ),
                ),
                overlayColor: MaterialStateProperty.all(
                    ColorResources.getOverlayIconColor(context)),
                backgroundColor: MaterialStateProperty.all(
                  isLight(context)
                      ? (isFollowing ? Colors.blueGrey : Colors.transparent)
                      : (isFollowing ? Colors.blueGrey : Colors.transparent),
                ),
                foregroundColor: MaterialStateProperty.all(isLight(context)
                    ? (isFollowing ? whiteColor : Colors.blueGrey)
                    : (isFollowing ? whiteColor : Colors.grey[300])),
              ),
              child: Text(
                isFollowing ? 'Following' : 'Follow',
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
