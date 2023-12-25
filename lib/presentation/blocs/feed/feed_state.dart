part of 'feed_cubit.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class LoadingFeed extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Article> articles;
  final int page;
  final bool hasMore;
  const FeedLoaded(
      {required this.articles, required this.page, required this.hasMore});
  @override
  List<Object> get props => [articles, page];
}

class FeedError extends FeedState {
  final String errorMsg;
  const FeedError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
