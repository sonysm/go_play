

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/model/post.dart';
import 'package:kroma_sport/model/state.dart';




class HomeData extends Equatable
{

  final List<Post> data;
  final int page;
  final State status;

  HomeData({this.status = State.None, required this.data, this.page = 1});

 HomeData copyWith({
    State? status,
    int? page,
    List<Post>? data,
    String? search
  }) {
    return HomeData(
      status: status ?? this.status,
      page: page ?? this.page,
      data: data ?? this.data,
    );
  }


  @override
  List<Object> get props => [status];

}

class HomeCubit extends Cubit<HomeData> {
    HomeCubit() : super(HomeData(data: []));

    final KSHttpClient _client = KSHttpClient();
  

    Future<void> onLoad() async {
        print('xxxx');
        emit(state.copyWith(status: State.Loading, page: 1));
        var data = await this._client.getApi('/home', queryParameters: {'page': state.page.toString()});
        if(data != null){
            if (data is! HttpResult) {
              List<Post> newData = (data as List).map((e) => Post(e)).toList();
              emit(state.copyWith(status: State.Loaded, data: newData));
            } else {
                print("error $data");
            }
        }
    }

    Future<void> onLoadMore() async {
        if (state.status != State.LoadedMore) {
            emit(state.copyWith(status: State.LoadingMore, page: state.page + 1));
            var data = await this._client.getApi('/home', queryParameters: {'page': state.page.toString()});
            if (data != null) {
              if (data is! HttpResult) {
                var newData = (data as List).map((e) => Post(e)).toList();
                if (newData.length > 0) {
                    emit(state.copyWith(status: State.Loaded, data: state.data + newData));
                } else {
                    emit(state.copyWith(status: State.LoadedMore));
                }
              } else {
                  print("error $data");
              }
            }
        }
    }
}