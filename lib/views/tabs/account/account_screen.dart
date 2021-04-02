import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  static String tag = '/accountScreen';

  AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Account'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildNavbar(),
        ],
      ),
    );
  }
}
