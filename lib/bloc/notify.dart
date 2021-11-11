import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/models/notification.dart';

class NotifyData extends Equatable {
    final List<KSNotification> data;
    final int page;
    final int badge;
    final DataState status;

    NotifyData(
      {required this.data,
      this.status = DataState.None,
      this.page = 1,
      this.badge = 0});

    NotifyData copyWith({
        List<KSNotification>? data,
        DataState? status,
        int ?page,
        int ?badge
    }){
      return NotifyData(
        data: data ?? this.data,
        page: page ?? this.page,
        status: status ?? this.status,
        badge: badge ?? this.badge
      );
    }

  @override
  List<Object?> get props => [data, page, badge, status];
}

class NotifyCubit extends Cubit<NotifyData> {
    NotifyCubit() : super(NotifyData(data: []));
    
    final KSHttpClient _client = KSHttpClient();

    Future<void> onLoad() async {
        emit(state.copyWith(status: DataState.Loading, page: 1));
        var data = await _client.getApi('/user/my_notification', queryParameters: {'page': 1.toString()});
        if (data != null) {
            if (data is! HttpResult) {
              List<KSNotification> posts = (data as List).map((e) => KSNotification.fromJson(e)).toList();
              int count = 0;
              posts.forEach((element) {
                  if(element.isTap != null && !element.isTap!){
                    count += 1;
                  }
              });
              DataState d = DataState.Loaded;
              if(data.length < 30){
                  d = DataState.NoMore;
              }
              emit(state.copyWith(status: d, data: posts, badge: count));
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
  }
  Future<NotifyData> onRefresh() async {
      var data = await _client.getApi('/user/my_notification', queryParameters: {'page': 1.toString()});
      if (data != null) {
          if (data is! HttpResult) {
            List<KSNotification> posts = (data as List).map((e) => KSNotification.fromJson(e)).toList();
            DataState d = DataState.Loaded;
            if(data.length < 30){
                d = DataState.NoMore;
            }
            tapViewNotify();
            return state.copyWith(status: d, data: posts, badge: 0);
          } else {
            if (data.code == -500) {
              return state.copyWith(status: DataState.ErrorSocket);
            } else if (data.code == 401) {
              return state.copyWith(status: DataState.UnAuthorized);
            }
            print("error");
          }
      }
      return state;
  }

  Future<NotifyData> onLoadMore() async {
      int p = state.page + 1; 
      var data = await _client.getApi('/user/my_notification', queryParameters: {'page': p.toString()});
      if (data != null) {
          if (data is! HttpResult) {
            List<KSNotification> posts = (data as List).map((e) => KSNotification.fromJson(e)).toList();
            DataState d = DataState.Loaded;
            if(data.length < 30){
                d = DataState.NoMore;
            }
            return state.copyWith(status: d, data: state.data + posts, page: p);
          } else {
            if (data.code == -500) {
              return state.copyWith(status: DataState.ErrorSocket);
            } else if (data.code == 401) {
              return state.copyWith(status: DataState.UnAuthorized);
            }
            print("error");
          }
      }
      return state;
  }

  void readNotify(int id) async{
      _client.postApi('/user/notification/update/read/$id').then((value) => null);
  }

  void tapViewNotify() async{
      _client.postApi('/user/notification/update/tap_view').then((value) => null);
  }

}