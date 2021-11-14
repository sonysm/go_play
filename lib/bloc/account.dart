import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';

class AccountData extends Equatable {
    final List<Post> posts;
    final DataState postStatus;
    final int postPage;

    final List<Post> meetup;
    final DataState meetupStatus;
    final int meetupPage;
    final bool rebuild;

    AccountData({
      required this.posts,
      required this.meetup,
      this.postStatus = DataState.None,
      this.meetupStatus = DataState.None,
      this.postPage = 1,
      this.meetupPage = 1,
      this.rebuild = false});

    AccountData copyWith({
        List<Post>? posts,
        DataState? postStatus,
        int? postPage,

        List<Post>? meetup,
        DataState? meetupStatus,
        int? meetupPage,
        bool? rebuild
    }){
        return AccountData(
            posts: posts ?? this.posts,
            postStatus: postStatus ?? this.postStatus,
            postPage: postPage ?? this.postPage,
            
            meetup: meetup ?? this.meetup,
            meetupStatus: meetupStatus ?? this.meetupStatus,
            meetupPage: meetupPage ?? this.meetupPage,
            rebuild: rebuild ?? this.rebuild,
        );
    }

  @override
  List<Object?> get props => [posts, meetup, postStatus, meetupStatus, postPage, meetupPage, rebuild];
}

class AccountCubit extends Cubit<AccountData>{
    AccountCubit() : super(AccountData(meetup: [], posts: []));
    final KSHttpClient _client = KSHttpClient();

    Future<void> onLoad() async {
        emit(state.copyWith(postStatus: DataState.Loading, postPage: 1, meetupStatus: DataState.Loading, meetupPage: 1));
        _client.getApi('/user/feed/by/${KS.shared.user.id}').then((data) {
            List<Post> posts = [];
            DataState status = DataState.Loaded;
            if(data != null){
              if (data is! HttpResult) {
                  posts = (data as List).map((e) => Post.fromJson(e)).toList();
                  if(posts.length < 10){
                      status = DataState.NoMore;
                  }
              }else {
                  if (data.code == -500) {
                      status = DataState.ErrorSocket;
                  } else if (data.code == 401) {
                      status = DataState.UnAuthorized;
                  }
              }
            }
            emit(state.copyWith(posts: posts, postStatus: status, postPage: 1));
        });
        
        _client.getApi('/user/meetup/by/${KS.shared.user.id}').then((data) {
            List<Post> meetup = [];
            DataState status = DataState.Loaded;
            if(data != null){
              if (data is! HttpResult) {
                  meetup = (data as List).map((e) => Post.fromJson(e)).toList();
                   if(meetup.length < 10){
                      status = DataState.NoMore;
                  }
              }else {
                  if (data.code == -500) {
                      status = DataState.ErrorSocket;
                  } else if (data.code == 401) {
                      status = DataState.UnAuthorized;
                  }
              }
            }
            emit(state.copyWith(meetup: meetup, meetupStatus: status, meetupPage: 1));
        });
    }

    Future<AccountData> onRefresh() async {
        var values = await Future.wait([
          _client.getApi('/user/feed/by/${KS.shared.user.id}'),
          _client.getApi('/user/meetup/by/${KS.shared.user.id}')
        ]);
        var result = state.copyWith(meetupPage: 1, postPage: 1);
        if(values.length > 0){
            int index = 0;
            values.forEach((data) { 
                List<Post> posts = [];
                DataState status = DataState.Loaded;
                if(data != null){
                  if (data is! HttpResult) {
                      posts = (data as List).map((e) => Post.fromJson(e)).toList();
                      if(posts.length < 10){
                          status = DataState.NoMore;
                      }
                  }else {
                      if (data.code == -500) {
                          status = DataState.ErrorSocket;
                      } else if (data.code == 401) {
                          status = DataState.UnAuthorized;
                      }
                  }
                }
                if(index == 0){
                    result = result.copyWith(postStatus: status, posts: posts);
                }else{
                    result = result.copyWith(meetupStatus: status, meetup: posts);
                }
                index ++ ;
            });
        }
        return result;
    }

    Future<AccountData> onMoreFeed() async{
        emit(state.copyWith(postStatus: DataState.LoadingMore));
        final p = state.postPage + 1;
        var data = await _client.getApi('/user/feed/by/${KS.shared.user.id}', queryParameters: {'page': p.toString()});
        List<Post> posts = [];
        DataState status = DataState.Loaded;
        if(data != null){
          if (data is! HttpResult) {
              posts = (data as List).map((e) => Post.fromJson(e)).toList();
              if(posts.isEmpty){
                  status = DataState.NoMore;
              }
          }else {
              if (data.code == -500) {
                  status = DataState.ErrorSocket;
              } else if (data.code == 401) {
                  status = DataState.UnAuthorized;
              }
          }
        }
        return state.copyWith(posts: state.posts + posts, postStatus: status, postPage: p);
    }

    Future<AccountData> onMoreMeetup() async{
        emit(state.copyWith(meetupStatus: DataState.LoadingMore));
        final p = state.postPage + 1;
        var data = await _client.getApi('/user/meetup/by/${KS.shared.user.id}', queryParameters: {'page': p.toString()});
        List<Post> meetup = [];
        DataState status = DataState.Loaded;
        if(data != null){
          if (data is! HttpResult) {
              meetup = (data as List).map((e) => Post.fromJson(e)).toList();
              if(meetup.isEmpty){
                  status = DataState.NoMore;
              }
          }else {
              if (data.code == -500) {
                  status = DataState.ErrorSocket;
              } else if (data.code == 401) {
                  status = DataState.UnAuthorized;
              }
          }
        }
        return state.copyWith(meetup: state.meetup + meetup, meetupStatus: status, meetupPage: p);
    }

    void checkReactPost(int id, bool isReacted, bool home){
        if (home) {
            bool reEmit = false;
            for (var element in state.posts) {
              if (element.id == id) {
                  element.reacted = isReacted;
                  if (isReacted) {
                    element.totalReaction += 1;
                  } else {
                    element.totalReaction -= 1;
                  }
                  reEmit = true;
                  break;
              }
            }
            if(reEmit){
                emit(state.copyWith(rebuild: !state.rebuild, posts: state.posts));
            }
        }
    }

    void onDeletePost(int id){
        final newPosts = state.posts.where((element) => element.id != id).toList();
        emit(state.copyWith(posts: newPosts));
    }

    void onAddPost(Post post){
        emit(state.copyWith(posts: [post] + state.posts));
    }

    void onUpdatePost(Post post){
        bool build = false;
        final updated = state.posts.map((element) {
            if( element.id == post.id){
                build = true;
                return post;
            }
            return element;
        }).toList();
        if(build){
            emit(state.copyWith(posts: updated, rebuild: !state.rebuild));
        }
    }

    void onDeleteMeetup(int id){
        final newPosts = state.meetup.where((element) => element.id != id).toList();
        emit(state.copyWith(posts: newPosts));
    }

     void onAddMeetup(Post meetup){
        emit(state.copyWith(meetup: [meetup] + state.meetup));
    }

    void onUpdateMeetup(Post meetup){
        bool build = false;
        final updated = state.meetup.map((element) {
            if( element.id == meetup.id){
                build = true;
                return meetup;
            }
            return element;
        }).toList();
        if(build){
            emit(state.copyWith(meetup: updated, rebuild: !state.rebuild));
        }
    }
}