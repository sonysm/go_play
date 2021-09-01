import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/models/user.dart';

class SuggestionData extends Equatable {
  final List<User> data;
  final DataState status;

  SuggestionData({required this.data, this.status = DataState.None});

  SuggestionData copyWith({List<User>? data, DataState? status}) {
    return SuggestionData(
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [data, status];
}

class SuggestionCubit extends Cubit<SuggestionData> {
  SuggestionCubit() : super(SuggestionData(data: []));

  final KSHttpClient _ksClient = KSHttpClient();

  void onLoad() {
    emit(state.copyWith(status: DataState.Loading));

    _ksClient.getApi('/user/recommend/users').then((data) {
      if (data != null) {
        if (data is! HttpResult) {
          List<User> listUser =
              List.from((data as List).map((e) => User.fromJson(e)));
          emit(state.copyWith(data: listUser, status: DataState.Loaded));
        } else {
          if (data.code == -500) {
            emit(state.copyWith(status: DataState.ErrorSocket));
            return;
          } else if (data.code == 401) {
            emit(state.copyWith(status: DataState.UnAuthorized));
          }
          print("error");
        }
      }
    });
  }

  void onBlockSuggestionUser(int userId) {
    if (state.status == DataState.Loaded) {
      _ksClient.postApi('/user/activity/block/$userId');

      final updatedList =
          state.data.where((element) => element.id != userId).toList();
      emit(state.copyWith(data: updatedList));
    }
  }
}
