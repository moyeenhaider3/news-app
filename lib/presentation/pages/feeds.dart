import 'package:app/core/constraints/constraints.dart';
import 'package:app/core/constraints/routes.dart';
import 'package:app/presentation/blocs/feed/feed_cubit.dart';
import 'package:app/presentation/pages/news_detail.dart';
import 'package:app/presentation/widgets/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Feed"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.search);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state is LoadingFeed) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FeedError) {
            return Center(
              child: Text(state.errorMsg),
            );
          }
          if (state is FeedLoaded) {
            final articles = state.articles;

            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstraints.small),
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
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<FeedCubit>().refresh();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<FeedCubit>().loadPage();
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
