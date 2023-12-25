import 'package:app/core/errors/exceptions.dart';
import 'package:app/data/news_api.dart';
import 'package:app/domain/models/feed.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.newsApi}) : super(InitialSearch());

  final NewsApi newsApi;

  Future<void> onSearch(String query,
      [List<Source>? sources, int? firstPage, String? type]) async {
    //necessary imports
    try {
      final List<String>? sourceIds = sources
          ?.map((e) => e.id)
          .where((id) => id != null)
          .cast<String>()
          .toList();
      final List<Article> articles =
          await newsApi.loadFeedFromEverything(q: query, sources: sourceIds);

      final hasMore = articles.isNotEmpty;

      emit(SearchLoaded(articles: articles, page: 1, hasMore: hasMore));
    } on GeneralException catch (e) {
      emit(SearchError(errorMsg: e.toString()));

      // Catch and handle GeneralException
      print("General Exception caught: ${e.toString()}");
      // Handle the exception as needed, e.g., show an error message to the user
    }
  }

  Future<void> loadMore(String query) async {
    try {
      if (state is SearchLoaded) {
        final page = (state as SearchLoaded).page + 1;
        final oldArticles = (state as SearchLoaded).articles;

        // Call loadSearch with necessary parameters
        final List<Article> articles =
            await newsApi.loadFeedFromEverything(page: page, q: query);

        final hasMore = articles.isNotEmpty;

        emit(SearchLoaded(
            articles: [...oldArticles, ...articles],
            page: page,
            hasMore: hasMore));
      }
      if (state is LoadingSearch || state is InitialSearch) {
        // Call loadSearch with necessary parameters
        final List<Article> articles =
            await newsApi.loadFeedFromEverything(q: query);

        final hasMore = articles.isNotEmpty;

        emit(SearchLoaded(articles: articles, page: 1, hasMore: hasMore));
      }
    } on GeneralException catch (e) {
      emit(SearchError(errorMsg: e.toString()));

      // Catch and handle GeneralException
      print("General Exception caught: ${e.toString()}");
      // Handle the exception as needed, e.g., show an error message to the user
    } catch (e) {
      emit(SearchError(errorMsg: e.toString()));
      // Catch other exceptions
      print("Unexpected Exception caught: ${e.toString()}");
      // Handle the exception as needed
    }
  }
}
