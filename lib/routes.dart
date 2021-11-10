import 'package:flutter/material.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/models/team.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/models/venue.dart';
import 'package:kroma_sport/views/auth/get_started_screen.dart';
import 'package:kroma_sport/views/auth/login_screen.dart';
import 'package:kroma_sport/views/auth/register_screen.dart';
import 'package:kroma_sport/views/auth/verify_code_screen.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/account/edit_profile_screen.dart';
import 'package:kroma_sport/views/tabs/account/follow_screen.dart';
import 'package:kroma_sport/views/tabs/account/setting/about_screen.dart';
import 'package:kroma_sport/views/tabs/account/setting/block_account_screen.dart';
import 'package:kroma_sport/views/tabs/account/setting/setting_screen.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/fav_sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/sports_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/create_team_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/delete_team_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/join_team_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/match/create_match_team_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/match/history_match_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/player_list_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/player_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/team_get_started_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/team_list_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/team_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/team_setting_screen.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';
import 'package:kroma_sport/views/tabs/home/activity_preview_screen.dart';
import 'package:kroma_sport/views/tabs/home/choose_location_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_activity_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/home_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/photo_view_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/connect_booking_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/invite_meetup_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_detail_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_activity_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_list_screen.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';
import 'package:kroma_sport/views/tabs/search/search_screen.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_detail.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_screen.dart';
import 'package:kroma_sport/views/tabs/venue/booking_payment_screen.dart';
import 'package:kroma_sport/views/tabs/venue/pitch_booking_screen.dart';
import 'package:kroma_sport/views/tabs/venue/venue_detail_screen.dart';
import 'package:kroma_sport/views/tabs/venue/venue_map_screen.dart';
import 'package:kroma_sport/views/tabs/venue/venue_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case LoginScreen.tag:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case RegisterScreen.tag:
        return MaterialPageRoute(builder: (_) => RegisterScreen(phoneNumber: args as String));

      case VerifyCodeScreen.tag:
        return MaterialPageRoute(builder: (_) => VerifyCodeScreen(phoneNumber: args as String));

      case MainView.tag:
        return MaterialPageRoute(builder: (_) => MainView(), settings: RouteSettings(name: MainView.tag));

      case HomeScreen.tag:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case MeetupScreen.tag:
        return MaterialPageRoute(builder: (_) => MeetupScreen());

      case NotificationScreen.tag:
        return KSPageRoute(builder: (_) => NotificationScreen());

      case AccountScreen.tag:
        return KSPageRoute(builder: (_) => AccountScreen());

      case FeedDetailScreen.tag:
        var data = args as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => FeedDetailScreen(
                post: data['post'], postIndex: data['postIndex'], isCommentTap: data['isCommentTap'], postCallback: data['postCallback']));

      case DetailScreen.tag:
        var data = args as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => DetailScreen(postId: data['postId']));

      case CreatePostScreen.tag:
        return MaterialPageRoute(builder: (_) => CreatePostScreen(data: args));

      case SettingScreen.tag:
        return KSPageRoute(builder: (_) => SettingScreen());

      case SportsScreen.tag:
        return KSPageRoute(builder: (_) => SportsScreen());

      case FavoriteSportDetailScreen.tag:
        args as Map<String, dynamic>;
        return KSPageRoute(builder: (_) => FavoriteSportDetailScreen(favSport: args['favSport'], isMe: args['isMe']));

      case SportDetailScreen.tag:
        return MaterialPageRoute(builder: (_) => SportDetailScreen(sport: args as Sport));

      case ViewUserProfileScreen.tag:
        args as Map;
        return KSPageRoute(builder: (_) => ViewUserProfileScreen(user: args['user'], profileBackgroundColor: args['backgroundColor']));

      case CreateActivityScreen.tag:
        return KSPageRoute(builder: (_) => CreateActivityScreen());

      case ViewPhotoScreen.tag:
        args as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => ViewPhotoScreen(post: args['post'], initailIndex: args['index']));

      case SetAddressScreen.tag:
        return MaterialPageRoute(builder: (_) => SetAddressScreen(address: args));

      case ActivityPreviewScreen.tag:
        return MaterialPageRoute(builder: (_) => ActivityPreviewScreen(activityData: args as Map<String, dynamic>));

      case MeetupDetailScreen.tag:
        return KSPageRoute(builder: (_) => MeetupDetailScreen(meetup: args));

      case OrganizeListScreen.tag:
        return MaterialPageRoute(builder: (_) => OrganizeListScreen());

      case OragnizeActivityScreen.tag:
        return MaterialPageRoute(builder: (_) => OragnizeActivityScreen(data: args));

      case EditProfileScreen.tag:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());

      case VenueScreen.tag:
        return MaterialPageRoute(builder: (_) => VenueScreen());

      case VenueDetailScreen.tag:
        args as Map;
        return MaterialPageRoute(builder: (_) => VenueDetailScreen(venue: args['venue'], heroTag: args['heroTag']));

      case PitchBookingScreen.tag:
        args as Map<String, dynamic>;
        return KSPageRoute(builder: (_) => PitchBookingScreen(venue: args['venue'], venueService: args['venueService']));

      case BookingHistoryScreen.tag:
        return KSPageRoute(builder: (_) => BookingHistoryScreen());

      case BookingHistoryDetailScreen.tag:
        args as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => BookingHistoryDetailScreen(booking: args['booking'], bookingId: args['id']));
      case FollowScreen.tag:
        return KSPageRoute(builder: (_) => FollowScreen(user: args as User?));

      case InviteMeetupScreen.tag:
        args as Map<String, dynamic>;
        return KSPageRoute(builder: (_) => InviteMeetupScreen(joinMember: args['joinMember'], meetup: args['meetup']));

      case ConnectBookingScreen.tag:
        return KSPageRoute(builder: (_) => ConnectBookingScreen(meetup: args as Post));

      case AboutScreen.tag:
        return KSPageRoute(builder: (_) => AboutScreen());

      case BlockAccountScreen.tag:
        return MaterialPageRoute(builder: (_) => BlockAccountScreen());

      case VenueMapScreen.tag:
        return MaterialPageRoute(builder: (_) => VenueMapScreen(venueList: args as List<Venue>));

      case SearchScreen.tag:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case GetStartedScreen.tag:
        return MaterialPageRoute(builder: (_) => GetStartedScreen());
      case BookingPaymentScreen.tag:
        return KSPageRoute(builder: (_) => BookingPaymentScreen(bookingData: args as Map<String, String>));
      case TeamListScreen.tag:
        return KSPageRoute(builder: (_) => TeamListScreen(), settings: RouteSettings(name: TeamListScreen.tag, arguments: Map()));
      case TeamGetStartedScreen.tag:
        return MaterialPageRoute(builder: (_) => TeamGetStartedScreen());
      case JoinTeamScreen.tag:
        return MaterialPageRoute(builder: (_) => JoinTeamScreen());
      case CreateTeamScreen.tag:
        return MaterialPageRoute(builder: (_) => CreateTeamScreen());
      case DeleteTeamScreen.tag:
        return MaterialPageRoute(builder: (_) => DeleteTeamScreen());
      case TeamSettingScreen.tag:
        return MaterialPageRoute(builder: (_) => TeamSettingScreen(team: args as Team));
      case TeamScreen.tag:
        return MaterialPageRoute(builder: (_) => TeamScreen(team: args as Team));
      case PlayerScreen.tag:
        return MaterialPageRoute(builder: (_) => PlayerScreen(player: args as User));
      case PlayerListScreen.tag:
        return MaterialPageRoute(builder: (_) => PlayerListScreen(team: args as Team));
      case HistoryMatchScreen.tag:
        return MaterialPageRoute(builder: (_) => HistoryMatchScreen());
      case CreateMatchTeamScreen.tag:
        return MaterialPageRoute(builder: (_) => CreateMatchTeamScreen(data: args));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('No View'),
        ),
        body: Center(
          child: Text('No data'),
        ),
      );
    });
  }
}

class KSPageRoute<T> extends MaterialPageRoute<T> {
  KSPageRoute({required WidgetBuilder builder, RouteSettings? settings}) : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // animation = CurvedAnimation(
    //     parent: animation,
    //     curve: Curves.fastLinearToSlowEaseIn,
    //     reverseCurve: Curves.easeOut);

    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset.zero,
        ),
      ),
      child: child,
      // child: SlideTransition(
      //   position: Tween<Offset>(
      //     begin: Offset.zero,
      //     end: Offset(-1.0, 0.0),
      //   ).animate(secondaryAnimation),
      //   child: child,
      // ),
    );
  }
}

class KSSlidePageRoute<T> extends MaterialPageRoute<T> {
  KSSlidePageRoute({required WidgetBuilder builder, RouteSettings? settings}) : super(builder: builder, settings: settings);

  // @override
  // Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset.zero,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-1.0, 0.0),
        ).animate(secondaryAnimation),
        child: child,
      ),
    );
  }
}
