import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final User user;
  final bool isSelectable;
  final Function(User)? onTap;

  const Avatar({
    Key? key,
    required this.radius,
    required this.user,
    this.isSelectable = true,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelectable
          ? () async {
              if (user.id != KS.shared.user.id) {
                var data = await launchScreen(
                    context, ViewUserProfileScreen.tag,
                    arguments: user);
                if (data != null) {
                  onTap!(data as User);
                }
              } else {
                launchScreen(context, AccountScreen.tag);
              }
            }
          : null,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        // backgroundImage: AssetImage('assets/images/user.jpg'),
        child: ClipOval(
          child: SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: user.photo != null
                ? CachedNetworkImage(
                    imageUrl: user.photo ?? '',
                    errorWidget: (context, s, e) {
                      return Image.asset('assets/images/user.jpg');
                    },
                  )
                : ColorLetterProfile(user: user),
          ),
        ),
      ),
    );
  }
}

class ColorLetterProfile extends StatefulWidget {
  final User user;
  const ColorLetterProfile({Key? key, required this.user}) : super(key: key);

  @override
  _ColorLetterProfileState createState() => _ColorLetterProfileState();
}

class _ColorLetterProfileState extends State<ColorLetterProfile> with AutomaticKeepAliveClientMixin {
  late String _name;

  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _name = widget.user.getFullname().substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
      ),
      alignment: Alignment.center,
      child: Text(
        _name,
        style: TextStyle(
          color: whiteColor,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
