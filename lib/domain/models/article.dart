import 'package:app/domain/models/source.dart';
import 'package:equatable/equatable.dart';

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
