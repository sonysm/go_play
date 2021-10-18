import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/dimensions.dart';

class ItemOptionWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const ItemOptionWidget({Key? key, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44.0,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }
}
