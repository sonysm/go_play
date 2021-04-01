import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);
  
  Future<void> init() async {
    // check local data
    emit(ThemeMode.system);
  }

  void emitTheme(ThemeMode mode){
      emit(mode);
  }
}
