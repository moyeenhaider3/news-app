import 'package:app/core/errors/exceptions.dart';
import 'package:app/data/news_api.dart';
import 'package:app/domain/models/article.dart';
import 'package:app/domain/models/source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.newsApi}) : super(InitialSearch());

  final NewsApi newsApi;

  Future<void> onSearch({
    String? query,
    List<Source>? sources,
    int? firstPage,
    String? type,
  }) async {
    try {
      final List<String>? sourceIds = sources
          ?.map((e) => e.id)
          .where((id) => id != null)
          .cast<String>()
          .toList();

      final List<Article> articles = await newsApi.loadFeedFromEverything(
          q: query, sources: sourceIds, sortBy: type);

      final hasMore = !(articles.length < 10);

      emit(
        SearchLoaded(
            articles: articles,
            page: 1,
            hasMore: hasMore,
            searchText: query ?? ""),
      );
    } on GeneralException catch (e) {
      emit(SearchError(errorMsg: e.toString()));

      // Catch and handle GeneralException
      print("General Exception caught: ${e.toString()}");
    }
  }

  Future<void> loadMore({
    String? query,
    List<Source>? sources,
    int? firstPage,
    String? type,
  }) async {
    try {
      if (state is SearchLoaded) {
        final page = (state as SearchLoaded).page + 1;
        final oldArticles = (state as SearchLoaded).articles;
        final List<String>? sourceIds = sources
            ?.map((e) => e.id)
            .where((id) => id != null)
            .cast<String>()
            .toList();
        // Call loadSearch with necessary parameters
        final List<Article> articles = await newsApi.loadFeedFromEverything(
            page: page, q: query, sortBy: type, sources: sourceIds);

        final hasMore = !(articles.length < 10);

        emit(SearchLoaded(
            articles: [...oldArticles, ...articles],
            page: page,
            hasMore: hasMore,
            searchText: query ?? ""));
      }
      if (state is LoadingSearch || state is InitialSearch) {
        // Call loadSearch with necessary parameters

        final List<String>? sourceIds = sources
            ?.map((e) => e.id)
            .where((id) => id != null)
            .cast<String>()
            .toList();

        final List<Article> articles = await newsApi.loadFeedFromEverything(
            q: query, sortBy: type, sources: sourceIds);

        final hasMore = !(articles.length < 10);

        emit(SearchLoaded(
            articles: articles,
            page: 1,
            hasMore: hasMore,
            searchText: query ?? ""));
      }
    } on GeneralException catch (e) {
      emit(SearchError(errorMsg: e.toString()));

      // Catch and handle GeneralException
      print("General Exception caught: ${e.toString()}");
    }
  }

  Future<void> fetchFilteredResult({
    String? query,
    List<Source>? sources,
    int? firstPage,
    String? type,
  }) async {
    try {
      emit(LoadingSearch());
      await onSearch(
          query: query, sources: sources, firstPage: firstPage, type: type);
    } on GeneralException catch (e) {
      emit(SearchError(errorMsg: e.toString()));

      // Catch and handle GeneralException
      print("General Exception caught: ${e.toString()}");
    }
  }

  String getSearchText() {
    if (state is SearchLoaded) {
      return (state as SearchLoaded).searchText;
    }
    return "";
  }
}
