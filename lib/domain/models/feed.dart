import 'dart:convert';

import 'package:app/domain/models/article.dart';
import 'package:equatable/equatable.dart';

class FilterTypes {
  FilterTypes._();
  static const String popularity = "popularity";
  static const String relevancy = "relevancy";
  static const String publishedAt = "publishedAt";
}

class Feed extends Equatable {
  final String status;
  final int totalResuls;
  final List<Article> articles;
  const Feed({
    required this.status,
    required this.totalResuls,
    required this.articles,
  });

  Feed copyWith({
    String? status,
    int? totalResuls,
    List<Article>? articles,
  }) {
    return Feed(
      status: status ?? this.status,
      totalResuls: totalResuls ?? this.totalResuls,
      articles: articles ?? this.articles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'totalResuls': totalResuls,
      'articles': articles.map((x) => x.toMap()).toList(),
    };
  }

  factory Feed.fromMap(Map<String, dynamic> map) {
    return Feed(
      status: map['status'] ?? '',
      totalResuls: map['totalResuls']?.toInt() ?? 0,
      articles:
          List<Article>.from(map['articles']?.map((x) => Article.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Feed.fromJson(String source) => Feed.fromMap(json.decode(source));

  @override
  String toString() =>
      'Feed(status: $status, totalResuls: $totalResuls, articles: $articles)';

  @override
  List<Object> get props => [status, totalResuls, articles];
}
