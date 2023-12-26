part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class InitialSearch extends SearchState {}

class LoadingSearch extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Article> articles;
  final int page;
  final String searchText;
  final bool hasMore;
  const SearchLoaded(
      {required this.articles,
      required this.page,
      required this.hasMore,
      required this.searchText});
  @override
  List<Object> get props => [articles, page];
}

class SearchError extends SearchState {
  final String errorMsg;
  const SearchError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
