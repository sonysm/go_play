import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  Future<void> init() async {
    // check local data

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var theme = prefs.getString('theme');
    if (theme != null) {
      // emitTheme(theme == 'light' ? ThemeMode.light : ThemeMode.dark);

      switch (theme) {
        case 'light':
          emitTheme(ThemeMode.light);
          break;
        case 'dark':
          emitTheme(ThemeMode.dark);
          break;
        case 'system':
          emitTheme(ThemeMode.system);
          break;
      }
    } else {
      emit(ThemeMode.dark);
    }
  }

  static ThemeMode _themeMode = ThemeMode.light;
  static ThemeMode get themeMode => _themeMode;

  void emitTheme(ThemeMode mode) {
    _themeMode = mode;
    emit(mode);
  }
}
