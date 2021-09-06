import 'package:flutter/material.dart';
import 'package:kroma_sport/config/env.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';

class AboutScreen extends StatefulWidget {
  static const tag = '/about';

  AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('About'),
      ),
      backgroundColor: ColorResources.getPrimary(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0, bottom: 16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
                child: Image.asset(imgVplayText, color: mainColor),
              ),
              4.height,
              Text(
                'Version: ${KS.shared.packageInfo.version}${DEBUG ? " (Development)" : ''}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              24.height,
              Text(
                'VPlay is sport app which user can connect, share and meetup with other over sports and other related activities.',
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
