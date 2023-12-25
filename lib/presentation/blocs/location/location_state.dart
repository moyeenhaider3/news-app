part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class CountryCode extends LocationState {
  final String countryCode;
  const CountryCode({required this.countryCode});
}
