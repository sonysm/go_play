import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';

class UserCubit extends Cubit<User> {
  UserCubit() : super(KS.shared.user);
  
  KSHttpClient ksClient = KSHttpClient();

  void emitUser(User user) {
    emit(user);
  }
  
  Future onRefresh() async {
    var data = await ksClient.getApi('/user/profile');
    if (data != null && data is! HttpResult) {
      var user = User.fromJson(data);
      emit(user);
    }
  }
}
