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
              primaryColor: primaryColor,
              accentColor: mainColor,
              scaffoldBackgroundColor: backgroundPrimary,
              iconTheme: IconThemeData(color: mainColor),
              accentIconTheme: IconThemeData(color: mainColor),
              primaryIconTheme: IconThemeData(color: mainColor),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryTextTheme: Theme.of(context).primaryTextTheme.apply(bodyColor: blackColor),
              textTheme: TextTheme(
                headline1: avenirRegularBlack,
                headline2: avenirRegularBlack,
                headline3: avenirRegularBlack,
                headline4: avenirRegularBlack,
                headline5: avenirRegularBlack.copyWith(fontSize: 24.0),
                headline6: avenirRegularBlack.copyWith(fontSize: 20.0),
                bodyText1: avenirRegularBlack.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
                bodyText2: avenirRegularBlack,
                caption: avenirRegularBlack.copyWith(fontSize: 12.0),
              ),
              appBarTheme: AppBarTheme(
                elevation: 1,
                textTheme: TextTheme(headline6: metropolisMainColor20),
              ),
              tabBarTheme: TabBarTheme(
                labelColor: mainColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: Theme.of(context).textTheme.bodyText1,
              ),
              radioTheme: RadioThemeData(fillColor: MaterialStateProperty.all(mainColor))),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: primaryDarkColor,
            accentColor: mainDarkColor,
            scaffoldBackgroundColor: backgroundDarkPrimary,
            iconTheme: IconThemeData(color: mainDarkColor),
            accentIconTheme: IconThemeData(color: mainDarkColor),
            primaryIconTheme: IconThemeData(color: mainDarkColor),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryTextTheme: Theme.of(context).primaryTextTheme.apply(bodyColor: whiteColor),
            textTheme: TextTheme(
              headline1: avenirRegularWhite,
              headline2: avenirRegularWhite,
              headline3: avenirRegularWhite,
              headline4: avenirRegularWhite,
              headline5: avenirRegularWhite.copyWith(fontSize: 24.0),
              headline6: avenirRegularWhite.copyWith(fontSize: 20.0),
              bodyText1: avenirRegularWhite.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
              bodyText2: avenirRegularWhite,
              caption: avenirRegularWhite.copyWith(fontSize: 12.0),
            ),
            appBarTheme: AppBarTheme(
              elevation: 1,
              textTheme: TextTheme(headline6: metropolisWhite20),
            ),
            tabBarTheme: TabBarTheme(
              labelColor: mainDarkColor,
              unselectedLabelColor: whiteColor,
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
      }),
    );
  }
}
