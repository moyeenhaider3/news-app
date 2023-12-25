import 'package:app/core/errors/exceptions.dart';
import 'package:app/data/news_api.dart';
import 'package:app/domain/models/feed.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({required this.newsApi}) : super(LoadingFeed());

  final NewsApi newsApi;
  Future<void> loadPage([List<Source>? sources]) async {
    try {
      if (state is FeedLoaded) {
        final page = (state as FeedLoaded).page + 1;
        final oldArticles = (state as FeedLoaded).articles;

        final List<String>? sourceIds = sources
            ?.map((e) => e.id)
            .where((id) => id != null)
            .cast<String>()
            .toList();

        final List<Article> articles = await newsApi.loadFeedFromTopHeadline(
          page: page,
          sources: sourceIds,
        );

        final hasMore = articles.isNotEmpty;

        emit(FeedLoaded(
          articles: [...oldArticles, ...articles],
          page: page,
          hasMore: hasMore,
        ));
      }

      if (state is LoadingFeed) {
        final List<String>? sourceIds = sources
            ?.map((e) => e.id)
            .where((id) => id != null)
            .cast<String>()
            .toList();

        final List<Article> articles = await newsApi.loadFeedFromTopHeadline(
          sources: sourceIds,
        );

        final hasMore = articles.isNotEmpty;

        emit(FeedLoaded(
          articles: articles,
          page: 1,
          hasMore: hasMore,
        ));
      }
    } on GeneralException catch (e) {
      emit(FeedError(errorMsg: e.toString()));
      print("General Exception caught: ${e.toString()}");
    }
  }

  // Future<void> fetchArticleForSources(List<Source> sources) async {
  //   final List<String> sources0 = sources
  //       .map((e) => e.id)
  //       .where((id) => id != null)
  //       .cast<String>()
  //       .toList();
  //   await loadPage(sources0);
  // }

  /// refresh the list with the latest data.
  Future<void> refresh() async {
    emit(LoadingFeed());
    await loadPage();
  }
}
