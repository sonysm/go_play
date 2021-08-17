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
  final bool ownertHasReachedMax;

  HomeData({
    required this.data,
    this.status = DataState.None,
    this.page = 1,
    this.search,
    required this.ownerPost,
    this.ownertHasReachedMax = false,
  });

  HomeData copyWith({
    DataState? status,
    int? page,
    List<Post>? data,
    String? search,
    List<Post>? ownerPost,
    bool? ownertHasReachedMax,
  }) {
    return HomeData(
        status: status ?? this.status,
        page: page ?? this.page,
        data: data ?? this.data,
        search: search ?? this.search,
        ownerPost: ownerPost ?? this.ownerPost,
        ownertHasReachedMax: ownertHasReachedMax ?? this.ownertHasReachedMax);
  }

  @override
  List<Object> get props => [status, data, page, ownertHasReachedMax];
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
              // emit(state.copyWith(
              //     status: DataState.Loaded, ownerPost: ownerPosts));
            }
          }
        });

        emit(state.copyWith(
            status: DataState.Loaded, data: posts, ownerPost: ownerPosts));
      } else {
        if (data.code == -500) {
          emit(state.copyWith(status: DataState.ErrorSocket));
          return;
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
      emit(state.copyWith(status: DataState.None, page: 1));
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
            if (morePosts.isNotEmpty) {
              emit(state.copyWith(ownerPost: state.ownerPost + morePosts));
            } else {
              emit(state.copyWith(ownertHasReachedMax: true));
            }
          }
        }
      });
    }
  }
}
