import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final User user;
  final bool isSelectable;

  const Avatar({
    Key? key,
    required this.radius,
    required this.user,
    this.isSelectable = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelectable
          ? () =>
              launchScreen(context, ViewUserProfileScreen.tag, arguments: user)
          : null,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        backgroundImage: AssetImage('assets/images/user.jpg'),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.photo ?? '',
            errorWidget: (context, s, e) {
              return Image.asset('assets/images/user.jpg');
            },
          ),
        ),
      ),
    );
  }
}
