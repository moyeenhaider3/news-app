import 'package:app/core/errors/exceptions.dart';
import 'package:app/data/news_api.dart';
import 'package:app/domain/models/article.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({
    required this.newsApi,
  }) : super(LoadingFeed());

  final NewsApi newsApi;
  String? _countryCode;

  Future<void> loadPage() async {
    final countryCode = await fetchCountryCodeName();
    print("$countryCode ccccccc");
    try {
      if (state is FeedLoaded) {
        final page = (state as FeedLoaded).page + 1;
        final oldArticles = (state as FeedLoaded).articles;

        final List<Article> articles = await newsApi.loadFeedFromTopHeadline(
            page: page, country: countryCode);

        final hasMore = articles.isNotEmpty;

        emit(FeedLoaded(
          articles: [...oldArticles, ...articles],
          page: page,
          hasMore: hasMore,
        ));
      }

      if (state is LoadingFeed) {
        final List<Article> articles =
            await newsApi.loadFeedFromTopHeadline(country: countryCode);

        final hasMore = articles.isNotEmpty;

        emit(FeedLoaded(
          articles: articles,
          page: 1,
          hasMore: hasMore,
        ));
      }
    } on GeneralException catch (e) {
      emit(FeedError(errorMsg: e.toString()));
      print("General Exception caught: ${e.toString()}");
    }
  }

  Future<void> refresh() async {
    emit(LoadingFeed());
    await loadPage();
  }

  Future<String> fetchCountryCodeName() async {
    if (_countryCode != null) {
      return _countryCode!;
    }
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> address =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placeMark = address.first;
      print("$placeMark  placemark");
      String countryCode = placeMark.isoCountryCode ?? "in";
      print("$countryCode  countryCode");
      _countryCode = countryCode;
      return countryCode;
    } catch (e) {
      print("General Exception caught: ${e.toString()}");
      return "us";
    }
  }
}
