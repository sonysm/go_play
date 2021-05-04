import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final String? imageUrl;
  final VoidCallback? onTap;

  const Avatar({
    Key? key,
    required this.radius,
    this.imageUrl,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        foregroundImage: CachedNetworkImageProvider(imageUrl ?? ''),
        backgroundImage: AssetImage('assets/images/user.jpg'),
      ),
    );
  }
}
