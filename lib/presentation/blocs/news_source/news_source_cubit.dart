import 'package:app/core/errors/exceptions.dart';
import 'package:app/data/news_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/source.dart';

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
    } catch (e) {
      emit(NewsSourceError(errorMsg: e.toString()));
      // Catch other exceptions
      print("Unexpected Exception caught: ${e.toString()}");
    }
  }

  //?updated method is toggleSelectedSource for addSelectedSource
  void addSelectedSource(Source sourceToAdd) {
    print("${sourceToAdd.name}hello");

    if (state is NewsSourceLoaded) {
      final currentState = state as NewsSourceLoaded;

      final updatedSelected = {...currentState.selected, sourceToAdd};
      emit(NewsSourceLoaded(
        sources: currentState.sources,
        selected: updatedSelected,
      ));
    }
  }

  // Method to remove a selected source
  //?updated method is toggleSelectedSource for removeSelectedSource
  void removeSelectedSource(Source sourceToRemove) {
    if (state is NewsSourceLoaded) {
      final currentState = state as NewsSourceLoaded;

      final updatedSelected = {...currentState.selected}
        ..remove(sourceToRemove);

      emit(NewsSourceLoaded(
        sources: currentState.sources,
        selected: updatedSelected,
      ));
    }
  }

  void toggleSelectedSource(Source source) {
    if (state is NewsSourceLoaded) {
      final currentState = state as NewsSourceLoaded;
      final isCurrentlySelected = currentState.selected.contains(source);
      final selectedSource = isCurrentlySelected
          ? ({...currentState.selected}..remove(source))
          : {...currentState.selected, source};
      emit(NewsSourceLoaded(
          sources: currentState.sources, selected: selectedSource));
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
      return null;
    }
  }
}
