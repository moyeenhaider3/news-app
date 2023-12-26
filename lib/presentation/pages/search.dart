import 'package:app/presentation/blocs/filter/filter_cubit.dart';
import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
import 'package:app/presentation/blocs/search/search_cubit.dart';
import 'package:app/presentation/pages/news_detail.dart';
import 'package:app/presentation/widgets/feed_card.dart';
import 'package:app/presentation/widgets/filter_dialog.dart';
import 'package:app/presentation/widgets/soucres_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/source.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
          ),
          onSubmitted: (query) {
            // Handle the search query when the user submits the text
            _handleSearch(query, context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Handle the search query when the user presses the search icon
              _handleSearch(_searchController.text, context);
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              final blc = context.read<NewsSourceCubit>();
              final filterBlc = context.read<FilterCubit>();
              final searchBlc = context.read<SearchCubit>();

              showDialog(
                context: context,
                builder: (context) => BlocProvider.value(
                  value: searchBlc,
                  child: BlocProvider.value(
                    value: filterBlc,
                    child: BlocProvider<NewsSourceCubit>.value(
                      value: blc,
                      child: const SourceSelectionDialog(),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            onPressed: () async {
              final blc = context.read<NewsSourceCubit>();
              final filterBlc = context.read<FilterCubit>();
              final searchBlc = context.read<SearchCubit>();

              showDialog(
                context: context,
                builder: (context) => BlocProvider.value(
                  value: searchBlc,
                  child: BlocProvider.value(
                    value: filterBlc,
                    child: BlocProvider<NewsSourceCubit>.value(
                      value: blc,
                      child: const SelectFilterDialog(),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.sort),
          )
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is InitialSearch) {
            return const Center(
              child: Text("Search Something"),
            );
          }
          if (state is LoadingSearch) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SearchError) {
            return Center(
              child: Text(state.errorMsg),
            );
          }
          if (state is SearchLoaded) {
            final articles = state.articles;
            return BlocListener<NewsSourceCubit, NewsSourceState>(
              listener: (context, state) {
                if (state is NewsSourceLoaded) {
                  final List<Source>? selectedSources =
                      context.read<NewsSourceCubit>().getSelectedSources();

                  context.read<SearchCubit>().onSearch(
                      query: _searchController.text,
                      sources: selectedSources,
                      firstPage: 1);
                }
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Display articles
                    ...articles.map(
                      (article) => FeedCard(
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailPage(
                                article: article,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Loading indicator at the end of the list
                    if (state.hasMore)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleSearch(String query, BuildContext context) {
    //while searching, fetching all the other parameters for search like: sources, filterType
    print("Search query: $query");

    //selected type @default sortBy publishedAt
    final type = context.read<FilterCubit>().state.type;

    final sourceCubit = context.read<NewsSourceCubit>();

    //selected sources, if there's any
    List<Source> sources = [];

    if (sourceCubit is NewsSourceLoaded) {
      sources = (sourceCubit as NewsSourceLoaded).selected.toList();
    }

    context
        .read<SearchCubit>()
        .onSearch(query: query, type: type, sources: sources);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<SearchCubit>().loadMore(_searchController.text.trim());
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
