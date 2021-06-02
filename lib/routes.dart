import 'package:flutter/material.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/views/auth/login_screen.dart';
import 'package:kroma_sport/views/auth/register_screen.dart';
import 'package:kroma_sport/views/auth/verify_code_screen.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/account/edit_profile_screen.dart';
import 'package:kroma_sport/views/tabs/account/setting/setting_screen.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/fav_sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/sports_screen.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';
import 'package:kroma_sport/views/tabs/home/activity_preview_screen.dart';
import 'package:kroma_sport/views/tabs/home/choose_location_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_activity_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/home_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/photo_view_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_detail_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_activity_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_list_screen.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';
import 'package:kroma_sport/views/tabs/venue/venue_detail_screen.dart';
import 'package:kroma_sport/views/tabs/venue/venue_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case LoginScreen.tag:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RegisterScreen.tag:
        return MaterialPageRoute(
            builder: (_) => RegisterScreen(phoneNumber: args as String));
      case VerifyCodeScreen.tag:
        return MaterialPageRoute(
          builder: (_) => VerifyCodeScreen(phoneNumber: args as String),
        );
      case MainView.tag:
        return MaterialPageRoute(
          builder: (_) => MainView(),
          settings: RouteSettings(name: MainView.tag),
        );
      case HomeScreen.tag:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case MeetupScreen.tag:
        return MaterialPageRoute(builder: (_) => MeetupScreen());
      case NotificationScreen.tag:
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case AccountScreen.tag:
        return MaterialPageRoute(
          builder: (_) => AccountScreen(),
          // settings: RouteSettings(name: AccountScreen.tag),
        );
      case FeedDetailScreen.tag:
        var data = args as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => FeedDetailScreen(
                post: data['post'], isCommentTap: data['isCommentTap']));
      case CreatPostScreen.tag:
        return MaterialPageRoute(builder: (_) => CreatPostScreen());
      case SettingScreen.tag:
        return MaterialPageRoute(builder: (_) => SettingScreen());
      case SportsScreen.tag:
        return MaterialPageRoute(builder: (_) => SportsScreen());
      case FavoriteSportDetailScreen.tag:
        return MaterialPageRoute(
            builder: (_) => FavoriteSportDetailScreen(sport: args as Sport));
      case SportDetailScreen.tag:
        return MaterialPageRoute(
            builder: (_) => SportDetailScreen(sport: args as Sport));
      case ViewUserProfileScreen.tag:
        return MaterialPageRoute(
            builder: (_) => ViewUserProfileScreen(user: args as User));
      case CreateActivityScreen.tag:
        return MaterialPageRoute(builder: (_) => CreateActivityScreen());
      case ViewPhotoScreen.tag:
        args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ViewPhotoScreen(
            post: args['post'],
            initailIndex: args['index'],
          ),
        );
      case SetAddressScreen.tag:
        return MaterialPageRoute(builder: (_) => SetAddressScreen());
      case ActivityPreviewScreen.tag:
        return MaterialPageRoute(
          builder: (_) => ActivityPreviewScreen(
            activityData: args as Map<String, dynamic>,
          ),
        );
      case MeetupDetailScreen.tag:
        return MaterialPageRoute(
          builder: (_) => MeetupDetailScreen(
            meetup: args as Post,
          ),
        );
      case OrganizeListScreen.tag:
        return MaterialPageRoute(builder: (_) => OrganizeListScreen());
      case OragnizeActivityScreen.tag:
        return MaterialPageRoute(
          builder: (_) => OragnizeActivityScreen(
            sport: args as Sport,
          ),
        );
      case EditProfileScreen.tag:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case VenueScreen.tag:
        return MaterialPageRoute(builder: (_) => VenueScreen());
      case VenueDetailScreen.tag:
        return MaterialPageRoute(builder: (_) => VenueDetailScreen());
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
