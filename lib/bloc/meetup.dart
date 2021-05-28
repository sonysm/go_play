import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';

class MeetupData extends Equatable {
  final List<Post> data;
  final int page;
  final String? search;
  final DataState status;
  final List<Post> ownerMeetup;

  MeetupData({
    required this.data,
    this.status = DataState.None,
    this.page = 1,
    this.search,
    required this.ownerMeetup,
  });

  MeetupData copyWith({
    DataState? status,
    int? page,
    List<Post>? data,
    String? search,
    List<Post>? ownerMeetup,
  }) {
    return MeetupData(
        status: status ?? this.status,
        page: page ?? this.page,
        data: data ?? this.data,
        search: search ?? this.search,
        ownerMeetup: ownerMeetup ?? this.ownerMeetup);
  }

  @override
  List<Object> get props => [status, data, page, ownerMeetup];
}

class MeetupCubit extends Cubit<MeetupData> {
  MeetupCubit() : super(MeetupData(data: [], ownerMeetup: []));

  final KSHttpClient _client = KSHttpClient();

  Future<void> onLoad() async {
    emit(state.copyWith(status: DataState.Loading, page: 1));
    var data = await _client
        .getApi('/meetup', queryParameters: {'page': state.page.toString()});
    if (data != null) {
      if (data is! HttpResult) {
        List<Post> posts = (data as List).map((e) => Post.fromJson(e)).toList();
        // await Future.delayed(Duration(milliseconds: 500));

        List<Post> ownerMeetups = [];
        await _client
            .getApi('/user/meetup/by/${KS.shared.user.id}')
            .then((data) {
          if (data != null) {
            if (data is! HttpResult) {
              ownerMeetups =
                  (data as List).map((e) => Post.fromJson(e)).toList();
            }
          }
        });

        emit(state.copyWith(
            status: DataState.Loaded, data: posts, ownerMeetup: ownerMeetups));
      } else {
        print("error");
      }
    }
  }

  Future<void> onRefresh() async {
    if (state.status == DataState.Loaded) {
      emit(state.copyWith(status: DataState.None, page: 1));
      var data = await _client
          .getApi('/meetup', queryParameters: {'page': state.page.toString()});
      if (data != null) {
        if (data is! HttpResult) {
          List<Post> posts =
              (data as List).map((e) => Post.fromJson(e)).toList();
          await Future.delayed(Duration(milliseconds: 500));
          emit(state.copyWith(status: DataState.Loaded, data: posts));
        } else {
          print("error");
        }
      }
    }
  }

  Future<void> onLoadMore() async {
    if (state.status != DataState.LoadedMore) {
      emit(state.copyWith(status: DataState.LoadingMore, page: state.page + 1));
      var data = await _client.getApi('/meetup', queryParameters: {
        'page': state.page.toString(),
        'search': state.search
      });
      if (data != null) {
        if (data is! HttpResult) {
          var newPosts = (data as List).map((e) => Post.fromJson(e)).toList();
          if (newPosts.length > 0) {
            emit(state.copyWith(
                status: DataState.Loaded, data: state.data + newPosts));
          } else {
            emit(state.copyWith(status: DataState.LoadedMore));
          }
        } else {
          print('error $data');
        }
      }
    }
  }

  Future<void> onAddMeetup(Post newPost) async {
    if (state.status == DataState.Loaded) {
      emit(state.copyWith(data: [newPost] + state.data));
    }
  }

  Future<void> onDeleteMeetup(int meetupId) async {
    if (state.status == DataState.Loaded) {
      final updatedList =
          state.data.where((element) => element.id != meetupId).toList();
      emit(state.copyWith(data: updatedList));
    }
  }

  onReset() {
    emit(MeetupData(data: [], ownerMeetup: []));
  }
}
