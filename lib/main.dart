import 'package:app/core/constraints/routes.dart';
import 'package:app/core/utils/observer.dart';
import 'package:app/di.dart';
import 'package:app/presentation/blocs/feed/feed_cubit.dart';
import 'package:app/presentation/blocs/filter/filter_cubit.dart';
import 'package:app/presentation/blocs/location/location_cubit.dart';
import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
import 'package:app/presentation/blocs/search/search_cubit.dart';
import 'package:app/presentation/pages/feeds.dart';
import 'package:app/presentation/pages/search.dart';
import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";

void main() {
  setup();
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Routes.feed,
      routes: {
        Routes.feed: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<LocationCubit>(
                  create: (context) => sl()..fetchCountryCodeName(),
                ),
                BlocProvider<FeedCubit>(
                  create: (context) => sl()..loadPage(),
                ),
                BlocProvider<NewsSourceCubit>(
                  create: (context) => sl(),
                  lazy: false,
                ),
                BlocProvider<SearchCubit>(
                  create: (context) => sl(),
                ),
              ],
              child: const FeedsPage(),
            ),
        Routes.search: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<SearchCubit>(
                  create: (context) => sl(),
                ),
                BlocProvider<FilterCubit>(
                  create: (context) => sl(),
                ),
                BlocProvider<NewsSourceCubit>(
                  create: (context) => sl()..fetchSources(),
                  lazy: false,
                ),
              ],
              child: const SearchPage(),
            )
      },
    );
  }
}
