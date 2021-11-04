import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/bloc/suggestion.dart';
import 'package:kroma_sport/bloc/theme.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/notification/my_notification.dart';
import 'package:kroma_sport/routes.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/connection_service.dart';
import 'package:kroma_sport/utils/constant.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await MyNotification.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions();

  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      );
      runApp(App());
    },
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(loginBackground), context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (BuildContext context) => ThemeCubit()..init()),
        BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit()),
        BlocProvider<SuggestionCubit>(create: (BuildContext context) => SuggestionCubit()..onLoad()),
        BlocProvider<MeetupCubit>(create: (BuildContext context) => MeetupCubit()),
        BlocProvider<UserCubit>(create: (BuildContext context) => UserCubit())
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(builder: (_, mode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          home: SplashScreen(),
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: ThemeData.light().copyWith(
            brightness: Brightness.light,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: backgroundPrimary,
            iconTheme: IconThemeData(color: mainColor),
            primaryIconTheme: IconThemeData(color: mainColor),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryTextTheme: Theme.of(context).primaryTextTheme.apply(bodyColor: blackColor),
            textTheme: TextTheme(
              headline1: aeonikRegularBlack.copyWith(fontSize: 96.0),
              headline2: aeonikRegularBlack.copyWith(fontSize: 60.0),
              headline3: aeonikRegularBlack.copyWith(fontSize: 48.0),
              headline4: aeonikRegularBlack.copyWith(fontSize: 34.0),
              headline5: aeonikRegularBlack.copyWith(fontSize: 24.0),
              headline6: aeonikRegularBlack.copyWith(fontSize: 20.0),
              bodyText1: aeonikRegularBlack.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
              bodyText2: aeonikRegularBlack,
              caption: aeonikRegularBlack.copyWith(fontSize: 12.0),
            ),
            appBarTheme: AppBarTheme(
              elevation: 0.3,
              color: primaryColor,
              centerTitle: false,
              titleTextStyle: aeonikMainColor20,
              iconTheme: IconThemeData(color: mainColor),
            ),
            tabBarTheme: TabBarTheme(
              labelColor: mainColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
            radioTheme: RadioThemeData(fillColor: MaterialStateProperty.all(mainColor)),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(aeonikRegularBlack.copyWith(fontSize: 16.0)),
                // padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0)),
                // elevation: MaterialStateProperty.all(0),
                // backgroundColor: MaterialStateProperty.all(mainColor),
              ),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: primaryColor,
              secondary: mainColor,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: mainColor,
              selectionColor: mainColor,
              selectionHandleColor: mainColor,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            brightness: Brightness.dark,
            primaryColor: primaryDarkColor,
            scaffoldBackgroundColor: backgroundDarkPrimary,
            iconTheme: IconThemeData(color: mainDarkColor),
            primaryIconTheme: IconThemeData(color: mainDarkColor),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryTextTheme: Theme.of(context).primaryTextTheme.apply(bodyColor: whiteColor),
            textTheme: TextTheme(
              headline1: aeonikRegularWhite.copyWith(fontSize: 96.0),
              headline2: aeonikRegularWhite.copyWith(fontSize: 60.0),
              headline3: aeonikRegularWhite.copyWith(fontSize: 48.0),
              headline4: aeonikRegularWhite.copyWith(fontSize: 34.0),
              headline5: aeonikRegularWhite.copyWith(fontSize: 24.0),
              headline6: aeonikRegularWhite.copyWith(fontSize: 20.0),
              bodyText1: aeonikRegularWhite.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
              bodyText2: aeonikRegularWhite,
              caption: aeonikRegularWhite.copyWith(fontSize: 12.0),
            ),
            appBarTheme: AppBarTheme(
              elevation: 0.3,
              centerTitle: false,
              color: primaryDarkColor,
              titleTextStyle: aeonikWhite20,
              iconTheme: IconThemeData(color: whiteColor),
            ),
            tabBarTheme: TabBarTheme(
              labelColor: mainDarkColor,
              unselectedLabelColor: whiteColor,
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(aeonikRegularBlack.copyWith(fontSize: 16.0)),
              ),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: primaryDarkColor,
              secondary: mainDarkColor,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.greenAccent[400],
              selectionColor: Colors.greenAccent[400],
              selectionHandleColor: mainDarkColor,
            ),
          ),
        );
      }),
    );
  }
}
