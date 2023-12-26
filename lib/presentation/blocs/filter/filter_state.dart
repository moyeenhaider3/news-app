import 'package:app/domain/models/feed.dart';

class FilterState {
  String type;
  FilterState({this.type = FilterTypes.popularity});

  FilterState copyWith({
    String? type,
  }) {
    return FilterState(
      type: type ?? this.type,
    );
  }
}
