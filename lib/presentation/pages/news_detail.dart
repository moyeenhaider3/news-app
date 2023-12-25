import 'package:app/domain/models/feed.dart';
import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Center(
        child: Text(article.description ?? "No Description"),
      ),
    );
  }
}
