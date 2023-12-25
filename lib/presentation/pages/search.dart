import 'package:app/domain/models/feed.dart';
import 'package:app/presentation/blocs/news_source/news_source_cubit.dart';
import 'package:app/presentation/blocs/search/search_cubit.dart';
import 'package:app/presentation/pages/news_detail.dart';
import 'package:app/presentation/widgets/feed_card.dart';
import 'package:app/presentation/widgets/soucres_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              showDialog(
                context: context,
                builder: (context) => BlocProvider<NewsSourceCubit>.value(
                  value: blc,
                  child: const SourceSelectionDialog(),
                ),
              );
            },
            icon: const Icon(Icons.select_all),
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

                  context
                      .read<SearchCubit>()
                      .onSearch(_searchController.text, selectedSources, 1);
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
    // Handle the search query, for now, print it
    print("Search query: $query");
    context.read<SearchCubit>().onSearch(query);
    // You can perform further actions with the search query, like fetching data
    // and updating the UI with the search results.
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
