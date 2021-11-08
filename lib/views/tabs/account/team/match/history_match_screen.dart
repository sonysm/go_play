import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';

class HistoryMatchScreen extends StatefulWidget {
  static const tag = '/historyMatchScreen';

  HistoryMatchScreen({Key? key}) : super(key: key);

  @override
  _HistoryMatchScreenState createState() => _HistoryMatchScreenState();
}

class _HistoryMatchScreenState extends State<HistoryMatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match history'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: KSScreenState(
          icon: Icon(FeatherIcons.activity, size: 150, color: isLight(context) ? Colors.blueGrey[700] : Colors.blueGrey[100]),
          title: 'No match yet',
        ),
      ),
    );
  }
}
