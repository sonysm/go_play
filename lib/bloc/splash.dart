import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/repositories/user_repository.dart';

enum SplashState {
  None,
  Exist,
  New,
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.None);

  void init() async {
    final userRepository = UserRepository();
    var headertoken = await userRepository.fetchHeaderToken();
    if (headertoken != null) {
      var ksClient = KSHttpClient();
      ksClient.setToken(headertoken);
      var data = await KSHttpClient().getApi('/user/profile');
      if (data != null) {
        if (data is! HttpResult) {
          KS.shared.user = User.fromJson(data);
          userRepository.persistUserPrefs(jsonEncode(data));
          emit(SplashState.Exist);
        } else {
          // emit(SplashState.New);

          var localUser = await userRepository.fetchUserPrefs();
          KS.shared.user = localUser;
          emit(SplashState.Exist);
        }
      } else {
        emit(SplashState.New);
      }
    } else {
      emit(SplashState.New);
    }
  }
}
