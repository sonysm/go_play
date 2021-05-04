part of 'feed_cubit.dart';

class FeedData extends Equatable {
  final List<dynamic> data;
  final int page;
  final String? search;
  final DataState status;

  FeedData({
    required this.data,
    this.status = DataState.None,
    this.page = 1,
    this.search,
  });

  FeedData copyWith({
    DataState? status,
    int? page,
    List<dynamic>? data,
    String? search,
  }) {
    return FeedData(
        status: status ?? this.status,
        page: page ?? this.page,
        data: data ?? this.data,
        search: search ?? this.search);
  }

  @override
  List<Object> get props => [status];
}
