import 'package:flutter/material.dart';

class AppConfig {
  // static const apiKey = "d599203f3ccd4f68822563fed3918b28";
  static const apiKey = "c55de70b17ab4e76a3466d7def6c80f7";

  /// used in [navigator] and [localization] shortcuts
  static final GlobalKey appKey = GlobalKey();

  /// Use this to show [SnackBar] or [MaterialBanner] in the app.
  ScaffoldMessengerState get messenger =>
      ScaffoldMessenger.of(AppConfig.appKey.currentContext!);
}
