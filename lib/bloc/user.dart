import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';

class UserCubit extends Cubit<User> {
  UserCubit() : super(KS.shared.user);

  void emitUser(User user) {
    emit(user);
  }
}
