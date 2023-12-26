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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Source &&
          runtimeType == other.runtimeType &&
          // Compare relevant properties for equality
          id == other.id &&
          name == other.name; // Add other properties as needed

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
