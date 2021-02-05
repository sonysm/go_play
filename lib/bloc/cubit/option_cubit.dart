/*
 * File: option_cubit.dart
 * Project: cubit
 * -----
 * Created Date: Thursday February 4th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:bloc/bloc.dart';

class OptionCubit<T> extends Cubit<OptionState> {
  OptionCubit([T value])
      : currentValue = value,
        super(OptionInitial(value));

  T currentValue;

  change(T newValue) {
    currentValue = newValue;
    emit(OptionChangeState(newValue));
  }
}

abstract class OptionState<T> {
  OptionState([this.value]);
  final T value;
}

class OptionInitial<T> extends OptionState {
  OptionInitial(T newValue) : super(newValue);
}

class OptionChangeState<T> extends OptionState {
  OptionChangeState(newValue) : super(newValue);
}
