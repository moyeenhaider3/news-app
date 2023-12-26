import 'package:app/presentation/blocs/filter/filter_state.dart';
import 'package:bloc/bloc.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterState());

  /// update type of filter
  Future<void> updateType(String type) async {
    emit(state.copyWith(type: type));
  }
}
