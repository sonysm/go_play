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
      emitTheme(theme == 'light' ? ThemeMode.light : ThemeMode.dark);
    } else {
      emit(ThemeMode.dark);
    }
  }

  void emitTheme(ThemeMode mode){
      emit(mode);
  }
}
