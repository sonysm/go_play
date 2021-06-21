import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/member.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';

class InviteMeetupScreen extends StatefulWidget {
  static const tag = '/inviteMeetupScreen';

  final List<Member> joinMember;
  final Post meetup;

  InviteMeetupScreen({Key? key, required this.joinMember, required this.meetup}) : super(key: key);

  @override
  _InviteMeetupScreenState createState() => _InviteMeetupScreenState();
}

class _InviteMeetupScreenState extends State<InviteMeetupScreen> {
  KSHttpClient ksClient = KSHttpClient();
  bool isLoading = true;
  List<User> followerList = [];

  Widget buildSearch() {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
      sliver: SliverToBoxAdapter(
        child: TextField(
          onChanged: (text) {
            searchPlayer(text);
          },
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w500),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search',
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Colors.grey[400]!)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Colors.grey[400]!)),
            fillColor: Colors.white,
            labelStyle: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.w500),
            counterStyle: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.w500),
            suffixIcon: Icon(
              Feather.search,
              size: 20.0,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget playerLabel() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
        child: Text(
          'Players',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  Widget playerListWidget() {
    return followerList.isNotEmpty
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final user = followerList[index];
                var isJoined = widget.joinMember
                    .any((element) => element.user.id == user.id);
                return UserInviteCell(
                  user: user,
                  isJoined: isJoined,
                  onInvite: () {
                    invitePlayer(user);
                  },
                );
              },
              childCount: followerList.length,
            ),
          )
        : SliverFillRemaining(
            child: Center(
              child: !isLoading
                  ? Text('Player not found')
                  : CircularProgressIndicator(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Invite player'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: [
            buildSearch(),
            playerLabel(),
            playerListWidget(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getFollower();
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void getFollower({String queryString = ''}) async {
    var followerRes = await ksClient
        .getApi('/user/invite/users', queryParameters: {'q': queryString, 'meetup_id': widget.meetup.id.toString()});
    if (followerRes != null) {
      if (followerRes is! HttpResult) {
        followerList = List.from(followerRes.map((e) => User.fromJson(e)));
      }
    }

    isLoading = false;
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {});
  }

  void searchPlayer(String q) {
    followerList.clear();
    isLoading = true;
    setState(() {});
    getFollower(queryString: q);
  }

  void invitePlayer(User user) {
    FocusScope.of(context).unfocus();
    showKSConfirmDialog(
      context,
      'Invite\n${user.getFullname()}',
      () {},
    );
  }
}

class UserInviteCell extends StatelessWidget {
  const UserInviteCell({
    Key? key,
    required this.user,
    this.isJoined = false,
    this.onInvite,
  }) : super(key: key);

  final User user;
  final bool isJoined;
  final VoidCallback? onInvite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          children: [
            Avatar(radius: 24, user: user),
            8.width,
            Text(
              user.getFullname(),
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontFamily: 'ProximaNova', fontWeight: FontWeight.w600),
            ),
            Spacer(),
            isJoined
                ? Text('Joined')
                : ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: MaterialStateProperty.all(mainColor),
                      foregroundColor: MaterialStateProperty.all(whiteColor),
                    ),
                    onPressed: onInvite,
                    child: Text('Invite'),
                  )
          ],
        ),
      ),
    );
  }
}
