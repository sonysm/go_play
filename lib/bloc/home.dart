import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';

class HomeData extends Equatable {
  final List<Post> data;
  final int page;
  final String? search;
  final DataState status;
  final List<Post> ownerPost;
  final bool ownerHasReachedMax;
  final bool reload;

  HomeData(
      {required this.data,
      this.status = DataState.None,
      this.page = 1,
      this.search,
      required this.ownerPost,
      this.ownerHasReachedMax = false,
      this.reload = false});

  HomeData copyWith({
    DataState? status,
    int? page,
    List<Post>? data,
    String? search,
    List<Post>? ownerPost,
    bool? ownerHasReachedMax,
    bool? reload,
  }) {
    return HomeData(
      status: status ?? this.status,
      page: page ?? this.page,
      data: data ?? this.data,
      search: search ?? this.search,
      ownerPost: ownerPost ?? this.ownerPost,
      ownerHasReachedMax: ownerHasReachedMax ?? this.ownerHasReachedMax,
      reload: reload ?? this.reload,
    );
  }

  @override
  List<Object> get props =>
      [status, data, page, ownerHasReachedMax, ownerPost, reload];
}

class HomeCubit extends Cubit<HomeData> {
  HomeCubit() : super(HomeData(data: [], ownerPost: []));

  final KSHttpClient _client = KSHttpClient();

  Future<void> onLoad() async {
    emit(state.copyWith(status: DataState.Loading, page: 1));
    var data = await _client
        .getApi('/home', queryParameters: {'page': state.page.toString()});
    if (data != null) {
      if (data is! HttpResult) {
        List<Post> posts = (data as List).map((e) => Post.fromJson(e)).toList();
        // await Future.delayed(Duration(milliseconds: 500));

        List<Post> ownerPosts = [];
        await _client.getApi('/user/feed/by/${KS.shared.user.id}').then((data) {
          if (data != null) {
            if (data is! HttpResult) {
              ownerPosts = (data as List).map((e) => Post.fromJson(e)).toList();
            }
          }
        });

        emit(state.copyWith(
            status: DataState.Loaded, data: posts, ownerPost: ownerPosts));
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

    // _client.getApi('/user/feed/by/${KS.shared.user.id}').then((data) {
    //   if (data != null) {
    //     if (data is! HttpResult) {
    //       List<Post> ownerPosts =
    //           (data as List).map((e) => Post.fromJson(e)).toList();
    //       emit(state.copyWith(status: DataState.Loaded, ownerPost: ownerPosts));
    //     }
    //   }
    // });
  }

  Future<void> onRefresh() async {
    if (state.status == DataState.Loaded) {
      emit(state.copyWith(page: 1));
      var data = await _client
          .getApi('/home', queryParameters: {'page': state.page.toString()});
      if (data != null) {
        if (data is! HttpResult) {
          List<Post> posts =
              (data as List).map((e) => Post.fromJson(e)).toList();
          await Future.delayed(Duration(milliseconds: 500));
          emit(state.copyWith(status: DataState.Loaded, data: posts));
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
  }

  Future<void> onLoadMore() async {
    if (state.status != DataState.LoadedMore) {
      emit(state.copyWith(status: DataState.LoadingMore, page: state.page + 1));
      var data = await _client.getApi('/home', queryParameters: {
        'page': state.page.toString(),
        'search': state.search
      });
      if (data != null) {
        if (data is! HttpResult) {
          var newPosts = (data as List).map((e) => Post.fromJson(e)).toList();
          if (newPosts.isNotEmpty) {
            emit(state.copyWith(
                status: DataState.Loaded, data: state.data + newPosts));
          } else {
            emit(state.copyWith(status: DataState.Loaded));
          }
        } else {
          if (data.code == -500) {
            emit(state.copyWith(status: DataState.ErrorSocket));
            return;
          }
          print('error $data');
        }
      }
    }
  }

  Future<void> onPostFeed(Post newPost) async {
    if (state.status == DataState.Loaded) {
      emit(state.copyWith(
          data: [newPost] + state.data,
          ownerPost: [newPost] + state.ownerPost));
    }
  }

  Future<void> onDeletePostFeed(int postId) async {
    if (state.status == DataState.Loaded) {
      final updatedList =
          state.data.where((element) => element.id != postId).toList();
      final updatedOwnerList =
          state.ownerPost.where((element) => element.id != postId).toList();

      emit(state.copyWith(data: updatedList, ownerPost: updatedOwnerList));
    }
  }

  onReset() {
    emit(HomeData(data: [], ownerPost: []));
  }

  Future<void> updatePost(Post newPost) async {
    if (state.status == DataState.Loaded) {
      final updatedList = state.data.map((element) {
        return element.id == newPost.id ? newPost : element;
      }).toList();

      final updatedOwnerList = state.ownerPost.map((element) {
        return element.id == newPost.id ? newPost : element;
      }).toList();

      emit(state.copyWith(data: updatedList, ownerPost: updatedOwnerList));
    }
  }

  Future<void> loadOwnerPost(int page) async {
    if (state.status == DataState.Loaded) {
      List<Post> morePosts = [];
      await _client.getApi('/user/feed/by/${KS.shared.user.id}',
          queryParameters: {'page': page.toString()}).then((data) {
        if (data != null) {
          if (data is! HttpResult) {
            morePosts = (data as List).map((e) => Post.fromJson(e)).toList();
            if (page == 1) {
              emit(state.copyWith(
                  ownerPost: morePosts, ownerHasReachedMax: false));
            } else {
              if (morePosts.isNotEmpty) {
                emit(state.copyWith(ownerPost: state.ownerPost + morePosts));
              } else {
                emit(state.copyWith(ownerHasReachedMax: true));
              }
            }
          }
        }
      });
    }
  }

  Future<void> reactPost(int id, bool reacted, {bool home = false}) async {
    if (state.status == DataState.Loaded) {
      // emit(state.copyWith(status: DataState.None));
      bool reEmit = false;
      if (home) {
        for (var element in state.ownerPost) {
          if (element.id == id) {
            element.reacted = reacted;
            if (reacted) {
              element.totalReaction += 1;
            } else {
              element.totalReaction -= 1;
            }
            reEmit = true;
            break;
          }
        }
      } else {
        for (var element in state.data) {
          if (element.id == id) {
            element.reacted = reacted;
            if (reacted) {
              element.totalReaction += 1;
            } else {
              element.totalReaction -= 1;
            }
            reEmit = true;
            break;
          }
        }
      }

      if (reEmit) {
        emit(state.copyWith(
            data: state.data,
            ownerPost: state.ownerPost,
            reload: !state.reload));
      }
    }
  }

  Future<void> onHidePost(int postId) async {
    if (state.status == DataState.Loaded) {
      _client.postApi('/user/activity/hide_post/$postId');

      final updatedList =
          state.data.where((element) => element.id != postId).toList();

      emit(state.copyWith(data: updatedList));
    }
  }

  void onUndoHidingPost({required int index, required Post post}) {
    if (state.status == DataState.Loaded) {
      _client.postApi('/user/activity/show/hidden_post/${post.id}');

      state.data.insert(index, post);
      emit(state.copyWith(data: state.data, reload: !state.reload));
    }
  }

  void onBlockUser(int userId) {
    if (state.status == DataState.Loaded) {
      _client.postApi('/user/activity/block/$userId');

      final updatedList =
          state.data.where((element) => element.owner.id != userId).toList();

      emit(state.copyWith(data: updatedList));
    }
  }

  void onUnblockUser(int userId) {
    if (state.status == DataState.Loaded) {
      // _client.postApi('/user/activity/block/$userId');

      // final updatedList =
      //     state.data.where((element) => element.owner.id != userId).toList();

      // emit(state.copyWith(data: updatedList));
    }
  }
}
