part of 'news_source_cubit.dart';

abstract class NewsSourceState extends Equatable {
  const NewsSourceState();

  @override
  List<Object> get props => [];
}

class NewsSourceInitial extends NewsSourceState {}

class LoadingNewsSource extends NewsSourceState {}

class NewsSourceLoaded extends NewsSourceState {
  final List<Source> sources;
  final Set<Source> selected;
  const NewsSourceLoaded({required this.sources, required this.selected});
  @override
  List<Object> get props => [sources];
}

class NewsSourceError extends NewsSourceState {
  final String errorMsg;
  const NewsSourceError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
