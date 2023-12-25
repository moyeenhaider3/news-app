import 'package:app/core/errors/exceptions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> fetchCountryCodeName() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> address =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placeMark = address.first;
      print("$placeMark  placemark");
      String countryCode = placeMark.isoCountryCode ?? "in";
      print("$countryCode  countryCode");

      emit(CountryCode(countryCode: countryCode));
    } on GeneralException catch (e) {
      print("General Exception caught: ${e.toString()}");
    }
  }
}
