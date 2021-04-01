import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/bloc/theme.dart';
import 'package:kroma_sport/views/main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
    return BlocProvider(
        create: (_) =>ThemeCubit()..init(),
        child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (_, mode) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: mode,
              home: MainView(),
          );
        })
    );
  }
}
