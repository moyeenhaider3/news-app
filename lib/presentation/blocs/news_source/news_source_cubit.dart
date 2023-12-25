import 'package:app/core/errors/exceptions.dart';
import 'package:app/data/news_api.dart';
import 'package:app/domain/models/feed.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'news_source_state.dart';

class NewsSourceCubit extends Cubit<NewsSourceState> {
  NewsSourceCubit({required this.newsApi}) : super(NewsSourceInitial());
  final NewsApi newsApi;

  Future<void> fetchSources() async {
    try {
      emit(LoadingNewsSource());
      final List<Source> sources = await newsApi.fetchSources();
      emit(NewsSourceLoaded(sources: sources, selected: const {}));
    } on GeneralException catch (e) {
      emit(NewsSourceError(errorMsg: e.toString()));

      // Catch and handle GeneralException
      print("General Exception caught: ${e.toString()}");
      // Handle the exception as needed, e.g., show an error message to the user
    } catch (e) {
      emit(NewsSourceError(errorMsg: e.toString()));
      // Catch other exceptions
      print("Unexpected Exception caught: ${e.toString()}");
      // Handle the exception as needed
    }
  }

  void addSelectedSource(Source sourceToAdd) {
    print("${sourceToAdd.name}hello");

    if (state is NewsSourceLoaded) {
      final currentState = state as NewsSourceLoaded;

      final Set<Source> updatedSelected = Set.from(currentState.selected)
        ..add(sourceToAdd);

      emit(NewsSourceLoaded(
        sources: currentState.sources,
        selected: updatedSelected,
      ));
    }
  }

  // Method to remove a selected source
  void removeSelectedSource(Source sourceToRemove) {
    if (state is NewsSourceLoaded) {
      final currentState = state as NewsSourceLoaded;

      final Set<Source> updatedSelected = Set.from(currentState.selected)
        ..remove(sourceToRemove);

      emit(NewsSourceLoaded(
        sources: currentState.sources,
        selected: updatedSelected,
      ));
    }
  }

  bool isSourceSelected(Source source) {
    if (state is NewsSourceLoaded) {
      final selectedSources = (state as NewsSourceLoaded).selected;
      return selectedSources.contains(source);
    }
    return false;
  }

  List<Source>? getSelectedSources() {
    if (state is NewsSourceLoaded) {
      final selectedSources = (state as NewsSourceLoaded).selected.toList();

      return selectedSources;
    } else {
      return null; // or handle default case as per your app's logic
    }
  }
}
