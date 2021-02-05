/*
 * File: switch_cubit.dart
 * Project: cubit
 * -----
 * Created Date: Thursday February 4th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:bloc/bloc.dart';

class SwitchCubit extends Cubit<bool> {
  SwitchCubit([bool intial])
      : value = (intial ?? true),
        super(intial ?? true);

  bool value;

  change(bool newValue) {
    emit(newValue);
  }
}
