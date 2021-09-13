import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/widgets/cache_image.dart';

class SearchResultCell extends StatelessWidget {
  const SearchResultCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        height: AppSize(context).appWidth(27),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: AppSize(context).appWidth(33),
              height: AppSize(context).appWidth(25),
              child: CacheImage(url: 'https://static.ffx.io/images/\$zoom_0.256%2C\$multiply_0.3541%2C\$ratio_1.776846%2C\$width_1059%2C\$x_0%2C\$y_86/t_crop_custom/q_86%2Cf_auto/c264c893649da0cd064488e85b1d07b04a88a1ef'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ronaldo has taken Man United from rage to rapture, the anger of May is forgotten',
                      maxLines: 3,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '07-Sept-2021',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
