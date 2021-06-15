import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/bloc/theme.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/routes.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
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
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit()..init(),
        ),
        BlocProvider<HomeCubit>(
          create: (BuildContext context) => HomeCubit(),
        ),
        BlocProvider<MeetupCubit>(
          create: (BuildContext context) => MeetupCubit(),
        ),
        BlocProvider<UserCubit>(
          create: (BuildContext context) => UserCubit(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(builder: (_, mode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          home: SplashScreen(),
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: ThemeData.light().copyWith(
            primaryColor: whiteColor,
            accentColor: mainColor,
            scaffoldBackgroundColor: greyColor,
            iconTheme: IconThemeData(color: mainColor),
            accentIconTheme: IconThemeData(color: mainColor),
            primaryIconTheme: IconThemeData(color: mainColor),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryTextTheme:
                Theme.of(context).primaryTextTheme.apply(bodyColor: blackColor),
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 14.0, color: blackColor, fontFamily: 'Avenir'),
              headline2: TextStyle(fontSize: 14.0, color: blackColor, fontFamily: 'Avenir'),
              headline3: TextStyle(fontSize: 14.0, color: blackColor, fontFamily: 'Avenir'),
              headline4: TextStyle(fontSize: 14.0, color: blackColor, fontFamily: 'Avenir'),
              headline5: TextStyle(fontSize: 24.0, color: blackColor, fontFamily: 'Avenir'),
              headline6: TextStyle(fontSize: 20.0, color: blackColor, fontFamily: 'Avenir'),
              bodyText1: TextStyle(
                fontSize: 16.0,
                color: blackColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'Avenir'
              ),
              bodyText2: TextStyle(fontSize: 14.0, color: blackColor, fontFamily: 'Avenir'),
              caption: TextStyle(fontSize: 12.0, color: blackColor, fontFamily: 'Avenir'),
            ),
            appBarTheme: AppBarTheme(
              elevation: 1,
              textTheme: TextTheme(
                headline6: TextStyle(
                  fontSize: 20.0,
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Metropolis'
                ),
              ),
            ),
            tabBarTheme: TabBarTheme(
              labelColor: mainColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Color(0xFF536872),
            accentColor: Colors.greenAccent,
            scaffoldBackgroundColor: Color(0xFF36454f), // Color(0xFF485b63),
            iconTheme: IconThemeData(color: Colors.greenAccent),
            accentIconTheme: IconThemeData(color: Colors.greenAccent),
            primaryIconTheme: IconThemeData(color: Colors.greenAccent),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryTextTheme:
                Theme.of(context).primaryTextTheme.apply(bodyColor: whiteColor),
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 14.0, color: whiteColor, fontFamily: 'Avenir'),
              headline2: TextStyle(fontSize: 14.0, color: whiteColor, fontFamily: 'Avenir'),
              headline3: TextStyle(fontSize: 14.0, color: whiteColor, fontFamily: 'Avenir'),
              headline4: TextStyle(fontSize: 14.0, color: whiteColor, fontFamily: 'Avenir'),
              headline5: TextStyle(fontSize: 24.0, color: whiteColor, fontFamily: 'Avenir'),
              headline6: TextStyle(fontSize: 20.0, color: whiteColor, fontFamily: 'Avenir'),
              bodyText1: TextStyle(fontSize: 16.0, color: whiteColor, fontFamily: 'Avenir'),
              bodyText2: TextStyle(fontSize: 14.0, color: whiteColor, fontFamily: 'Avenir'),
              caption: TextStyle(fontSize: 12.0, color: whiteColor, fontFamily: 'Avenir'),
            ),
            appBarTheme: AppBarTheme(
              elevation: 1,
              textTheme: TextTheme(
                headline6: TextStyle(
                  fontSize: 20.0,
                  color: whiteColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Metropolis'
                ),
              ),
            ),
            tabBarTheme: TabBarTheme(
              labelColor: Colors.greenAccent,
              unselectedLabelColor: whiteColor,
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
      }),
    );
  }
}
