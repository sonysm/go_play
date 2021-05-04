import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';

part 'feed_data.dart';

class FeedCubit extends Cubit<FeedData> {
  FeedCubit() : super(FeedData(data: []));

  Future<void> onLoad() async {
    emit(state.copyWith(status: DataState.Loading, page: 1));
    var data = await KSHttpClient().getApi('/feed');
    if (data != null) {
      if (data is! HttpResult) {
        ///TOD0
        emit(state.copyWith(status: DataState.Loaded, data: data));
      } else {
        print("error");
      }
    }
  }

  Future<void> onLoadMore() async {
    if (state.status != DataState.LoadedMore) {
      emit(state.copyWith(status: DataState.LoadingMore, page: state.page + 1));
      var data = await KSHttpClient().getApi('/feed',
          queryParameters: {'page': state.page, 'search': state.search});
      if (data != null) {
        if (data is! HttpResult) {
          ///TOD0
        }
      }
    }
  }
}
