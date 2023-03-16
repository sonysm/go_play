import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class BlockAccountScreen extends StatefulWidget {
  static const tag = '/blockAccount';

  BlockAccountScreen({Key? key}) : super(key: key);

  @override
  _BlockAccountScreenState createState() => _BlockAccountScreenState();
}

class _BlockAccountScreenState extends State<BlockAccountScreen> {
  List<User> _blockedAccount = [];

  KSHttpClient _ksClient = KSHttpClient();
  bool _isLoading = true;

  late HomeCubit _homeCubit;
  late MeetupCubit _meetupCubit;

  Widget blockedAccountListWidget() {
    return _isLoading
        ? SliverToBoxAdapter()
        : _blockedAccount.isNotEmpty
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final user = _blockedAccount[index];
                    return BlockedAccountCell(
                      user: user,
                      onTap: (isBlocked) {
                        if (isBlocked) {
                          _homeCubit.onBlockUser(user.id);
                          _meetupCubit.onBlockUser(user.id);
                        } else {
                          _homeCubit.onUnblockUser(user.id);
                          _meetupCubit.onUnblockUser(user.id);
                        }
                      },
                    );
                  },
                  childCount: _blockedAccount.length,
                ),
              )
            : SliverFillRemaining(
                child: EmptyBlockedAccount(),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        titleSpacing: 0,
        title: Text('Blocked Accounts'),
      ),
      backgroundColor: ColorResources.getPrimary(context),
      body: CustomScrollView(
        slivers: [
          blockedAccountListWidget(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fecthBlockedAccount();
    });

    _homeCubit = context.read<HomeCubit>();
    _meetupCubit = context.read<MeetupCubit>();
  }

  void fecthBlockedAccount() {
    _ksClient.getApi('/user/activity/my/blocks').then((data) {
      if (data != null && data is! HttpResult) {
        _blockedAccount = List.from((data as List).map((e) => User.fromJson(e['user'])));
        _isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
}

class EmptyBlockedAccount extends StatelessWidget {
  const EmptyBlockedAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResources.getPrimary(context),
      padding: const EdgeInsets.all(24.0),
      child: Padding(
        padding: EdgeInsets.only(bottom: AppBar().preferredSize.height + kToolbarHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'You aren\'t blocking anyone',
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              'when you block someone, that person won\'t be able to follow or message you, and you won\'t see notification from them.',
            )
          ],
        ),
      ),
    );
  }
}

class BlockedAccountCell extends StatefulWidget {
  final User user;
  final Function(bool)? onTap;
  BlockedAccountCell({Key? key, required this.user, this.onTap}) : super(key: key);

  @override
  _BlockedAccountCellState createState() => _BlockedAccountCellState();
}

class _BlockedAccountCellState extends State<BlockedAccountCell> {
  bool isBlocked = true;

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
            Avatar(
              radius: 24,
              user: widget.user,
              isSelectable: false,
            ),
            8.width,
            Text(
              widget.user.getFullname(),
              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
            ),
            Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0.0),
                backgroundColor: MaterialStateProperty.all(isBlocked ? mainColor : Colors.blueGrey),
                foregroundColor: MaterialStateProperty.all(whiteColor),
              ),
              onPressed: () {
                isBlocked = !isBlocked;
                widget.onTap!(isBlocked);
                setState(() {});
              },
              child: Text(isBlocked ? 'Unblock' : 'Block'),
            )
          ],
        ),
      ),
    );
  }
}
