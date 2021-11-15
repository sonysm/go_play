import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/models/post.dart';

class MeetupData extends Equatable {
  final List<Post> data;
  final int page;
  final String? search;
  final DataState status;
  // final List<Post> ownerMeetup;
  // final bool ownerHasReachedMax;
  final bool reload;

  MeetupData({
    required this.data,
    this.status = DataState.None,
    this.page = 1,
    this.search,
    // required this.ownerMeetup,
    // this.ownerHasReachedMax = false,
    this.reload = false,
  });

  MeetupData copyWith({
    DataState? status,
    int? page,
    List<Post>? data,
    String? search,
    List<Post>? ownerMeetup,
    bool? ownerHasReachedMax,
    bool? reload,
  }) {
    return MeetupData(
      status: status ?? this.status,
      page: page ?? this.page,
      data: data ?? this.data,
      search: search ?? this.search,
      // ownerMeetup: ownerMeetup ?? this.ownerMeetup,
      // ownerHasReachedMax: ownerHasReachedMax ?? this.ownerHasReachedMax,
      reload: reload ?? this.reload,
    );
  }

  @override
  List<Object> get props =>
      [status, data, page, reload];
}

class MeetupCubit extends Cubit<MeetupData> {
  MeetupCubit() : super(MeetupData(data: []));

  final KSHttpClient _client = KSHttpClient();

  Future<void> onLoad() async {
    emit(state.copyWith(status: DataState.Loading, page: 1));
    var data = await _client
        .getApi('/meetup', queryParameters: {'page': state.page.toString()});
    if (data != null) {
      if (data is! HttpResult) {
        List<Post> posts = (data as List).map((e) => Post.fromJson(e)).toList();
        DataState status = DataState.Loaded;
        if(posts.length < 10) {
            status = DataState.NoMore;
        }
        emit(state.copyWith(status: status, data: posts));
      } else {
        if (data.code == -500) {
          emit(state.copyWith(status: DataState.ErrorSocket));
          return;
        }
        print("error");
      }
    }
  }

  Future<MeetupData> onRefresh() async {
    var data = await _client
        .getApi('/meetup', queryParameters: {'page': 1.toString()});
    if (data != null) {
      if (data is! HttpResult) {
        List<Post> posts = (data as List).map((e) => Post.fromJson(e)).toList();
        DataState status = DataState.Loaded;
        if(posts.length < 10) {
            status = DataState.NoMore;
        }
        return state.copyWith(
            status: status,
            data: posts,
            reload: !state.reload,
            page: 1
        );
      } else {
        if (data.code == -500) {
          return state.copyWith(status: DataState.ErrorSocket);
        }
        print("error");
      }
    }
    return state;
  }

  Future<MeetupData> onLoadMore() async {
      final p = state.page + 1;
      var data = await _client.getApi('/meetup', queryParameters: {
        'page': p.toString(),
        'search': state.search
      });
      if (data != null) {
        if (data is! HttpResult) {
          var newPosts = (data as List).map((e) => Post.fromJson(e)).toList();
          DataState status = DataState.Loaded;
          if(newPosts.length < 10) {
              status = DataState.NoMore;
          }
          return state.copyWith(status: status, data: state.data + newPosts, page: p);
        } else {
          if (data.code == -500) {
            return state.copyWith(status: DataState.ErrorSocket);
          }
          print('error $data');
        }
      }
      return state;
  }

  Future<void> onAddMeetup(Post newPost) async {
    // if (state.status == DataState.Loaded) {
      emit(state.copyWith(data: [newPost] + state.data));
    // }
  }

  Future<void> onDeleteMeetup(int meetupId) async {
    // if (state.status == DataState.Loaded) {
      final updatedList =
          state.data.where((element) => element.id != meetupId).toList();

      // final updateMeetupOwner =
      //     state.ownerMeetup.where((element) => element.id != meetupId).toList();

      emit(state.copyWith(data: updatedList));
    // }
  }

  // onReset() {
  //   emit(MeetupData(data: [], ownerMeetup: []));
  // }

  Future<void> update(Post newMeetup) async {
    // if (state.status == DataState.Loaded) {
      final updatedList = state.data.map((element) {
        return element.id == newMeetup.id ? newMeetup : element;
      }).toList();

      // final updatedOwnerList = state.ownerMeetup.map((element) {
      //   return element.id == newMeetup.id ? newMeetup : element;
      // }).toList();

      emit(state.copyWith(data: updatedList));
    // }
  }

  // Future<void> loadOwnerMeetup(int page) async {
  //   if (state.status == DataState.Loaded) {
  //     List<Post> moreMeetups = [];
  //     await _client.getApi('/user/meetup/by/${KS.shared.user.id}',
  //         queryParameters: {'page': page.toString()}).then((data) {
  //       if (data != null) {
  //         if (data is! HttpResult) {
  //           moreMeetups = (data as List).map((e) => Post.fromJson(e)).toList();
  //           if (page == 1) {
  //             emit(state.copyWith(
  //                 ownerMeetup: moreMeetups, ownerHasReachedMax: false));
  //           } else {
  //             if (moreMeetups.isNotEmpty) {
  //               emit(state.copyWith(
  //                   ownerMeetup: state.ownerMeetup + moreMeetups));
  //             } else {
  //               emit(state.copyWith(ownerHasReachedMax: true));
  //             }
  //           }
  //         }
  //       }
  //     });
  //   }
  // }

  Future<void> onHideMeetup(int postId) async {
    // if (state.status == DataState.Loaded) {
      _client.postApi('/user/activity/hide_post/$postId');

      final updatedList =
          state.data.where((element) => element.id != postId).toList();

      emit(state.copyWith(data: updatedList));
    // }
  }

  void onUndoHidingMeetup({required int index, required Post post}) {
    // if (state.status == DataState.Loaded) {
      _client.postApi('/user/activity/show/hidden_post/${post.id}');

      state.data.insert(index, post);
      emit(state.copyWith(data: state.data, reload: !state.reload));
    // }
  }

  void onBlockUser(int userId) {
    // if (state.status == DataState.Loaded) {
      // _client.postApi('/user/activity/block/$userId');

      final updatedList =
          state.data.where((element) => element.owner.id != userId).toList();

      emit(state.copyWith(data: updatedList));
    // }
  }

  void onUnblockUser(int userId) {
    // if (state.status == DataState.Loaded) {
      // _client.postApi('/user/activity/unblock/$userId');
      onRefresh();
    }
  // }
}
