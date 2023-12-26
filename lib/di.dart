import 'package:app/data/news_api.dart';
import 'package:app/presentation/blocs/feed/feed_cubit.dart';
import 'package:app/presentation/blocs/filter/filter_cubit.dart';
import 'package:app/presentation/blocs/location/location_cubit.dart';
import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
import 'package:app/presentation/blocs/search/search_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setup() {
  sl.registerSingleton<NewsApiImp>(NewsApiImp());
  sl.registerSingleton<LocationCubit>(LocationCubit());
  sl.registerFactory<FilterCubit>(() => FilterCubit());
  sl.registerFactory<FeedCubit>(
      () => FeedCubit(newsApi: sl<NewsApiImp>(), lc: sl<LocationCubit>()));
  sl.registerFactory<SearchCubit>(() => SearchCubit(newsApi: sl<NewsApiImp>()));
  sl.registerFactory<NewsSourceCubit>(
      () => NewsSourceCubit(newsApi: sl<NewsApiImp>()));
}
