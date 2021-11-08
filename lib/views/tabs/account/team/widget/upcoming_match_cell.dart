import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class UpcomingMatchCell extends StatelessWidget {
  const UpcomingMatchCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            children: [
              Text('Sun'),
              Text('7'),
              Text('Nov'),
              Text('4:00 PM'),
            ],
          ),
          Container(
            width: 1,
            height: 100,
            color: Colors.grey,
          ),
          Column(
            children: [
              Text(
                'Legenday',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                'Man City',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text('Phnom Penh, Cambodia'),
            ],
          )
        ],
      ),
    );
  }
}
