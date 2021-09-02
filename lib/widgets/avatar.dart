import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';

class Avatar extends StatefulWidget {
  final double radius;
  final User user;
  final bool isSelectable;
  final Color? backgroundcolor;
  final Function(User)? onTap;
  final Function(Color)? backgroundColorCallback;

  const Avatar({
    Key? key,
    required this.radius,
    required this.user,
    this.isSelectable = true,
    this.backgroundcolor,
    this.onTap,
    this.backgroundColorCallback,
  }) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  Random _random = Random();

  late Color _color;

  @override
  void initState() {
    super.initState();
    if (widget.backgroundcolor != null) {
      _color = widget.backgroundcolor!;
    } else {
      _color = Color.fromARGB(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
      );
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.backgroundColorCallback != null) {
        widget.backgroundColorCallback!(_color);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isSelectable
          ? () async {
              if (widget.user.id != KS.shared.user.id) {
                var data = await launchScreen(
                    context, ViewUserProfileScreen.tag, arguments: {
                  'user': widget.user,
                  'backgroundColor': _color
                });
                if (data != null) {
                  if (widget.onTap != null) {
                    widget.onTap!(data['user'] as User);
                  }
                }
              } else {
                launchScreen(context, AccountScreen.tag);
              }
            }
          : null,
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.grey[200],
        // backgroundImage: AssetImage('assets/images/user.jpg'),
        child: Container(
          width: widget.radius * 2,
          height: widget.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[100]!, width: 0.5),
          ),
          child: widget.user.photo != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.user.photo ?? '',
                    errorWidget: (context, s, e) {
                      return Image.asset('assets/images/user.jpg');
                    },
                  ),
                )
              : ClipOval(
                  child: ColorLetterProfile(user: widget.user, color: _color)),
        ),
      ),
    );
  }
}

class ColorLetterProfile extends StatefulWidget {
  final Color? color;
  final User user;
  const ColorLetterProfile({
    Key? key,
    required this.user,
    this.color,
  }) : super(key: key);

  @override
  _ColorLetterProfileState createState() => _ColorLetterProfileState();
}

class _ColorLetterProfileState extends State<ColorLetterProfile>
    with AutomaticKeepAliveClientMixin {
  late String _name;

  // Random _random = Random();

  // late Color _color;

  @override
  void initState() {
    super.initState();
    _name = widget.user.getFullname().substring(0, 1).toUpperCase();
    // _color =  Color.fromARGB(
    //   _random.nextInt(256),
    //   _random.nextInt(256),
    //   _random.nextInt(256),
    //   _random.nextInt(256),
    // );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: widget.color,
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
