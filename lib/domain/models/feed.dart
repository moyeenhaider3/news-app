import 'dart:convert';

import 'package:equatable/equatable.dart';

class Source extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? url;
  final String? country;
  const Source({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.country,
  });

  Source copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    String? country,
  }) {
    return Source(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'country': country,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      country: map['country'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Source.fromJson(String source) => Source.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Source(id: $id, name: $name, description: $description, url: $url, country: $country)';
  }

  @override
  List<Object> get props {
    return [];
  }
}

class Article extends Equatable {
  final Source source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  const Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
      };

  Article copyWith({
    Source? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
  }) {
    return Article(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source': source.toMap(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.millisecondsSinceEpoch,
      'content': content,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    dynamic publishedAt = map['publishedAt'];
    int publishedAtMillis;

    if (publishedAt is String) {
      // Convert the string to an integer
      publishedAtMillis = int.tryParse(publishedAt) ?? 0;
    } else if (publishedAt is int) {
      // Use the integer value directly
      publishedAtMillis = publishedAt;
    } else {
      // Use a default value or handle the situation as needed
      publishedAtMillis = 0;
    }
    return Article(
      source: Source.fromMap(map['source']),
      author: map['author'],
      title: map['title'] ?? '',
      description: map['description'],
      url: map['url'] ?? '',
      urlToImage: map['urlToImage'],
      publishedAt: DateTime.fromMillisecondsSinceEpoch(publishedAtMillis),
      content: map['content'],
    );
  }

  @override
  String toString() {
    return 'Article(source: $source, author: $author, title: $title, description: $description, url: $url, urlToImage: $urlToImage, publishedAt: $publishedAt, content: $content)';
  }

  @override
  List<Object> get props {
    return [
      source,
      title,
      url,
      publishedAt,
    ];
  }
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
