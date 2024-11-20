import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor {
  developer,
  qa,
  sandbox,
  preproduction,
  production,
}

class FlavorValues {
  final String baseUrl;
  final String environmentName;
  final Color? bannerColor;

  FlavorValues({
    required this.baseUrl,
    required this.environmentName,
    this.bannerColor,
  });
}

class FlavorConfig {
  static Flavor? appFlavor;

  static FlavorValues get flavorValues {
    switch (appFlavor) {
      case Flavor.developer:
        return FlavorValues(
          baseUrl: dotenv.env['DEVELOPER']!,
          environmentName: 'DEVELOPER',
          bannerColor: Colors.red,
        );
      case Flavor.qa:
        return FlavorValues(
          baseUrl: dotenv.env['QA']!,
          environmentName: 'QUALITY',
          bannerColor: Colors.yellow[700],
        );
      case Flavor.sandbox:
        return FlavorValues(
          baseUrl: dotenv.env['SANDBOX']!,
          environmentName: 'SANDBOX',
          bannerColor: Colors.green,
        );
      case Flavor.preproduction:
        return FlavorValues(
          baseUrl: dotenv.env['PREPRODUCTION']!,
          environmentName: 'PREPRODUCTION',
          bannerColor: Colors.deepPurple,
        );
      case Flavor.production:
        return FlavorValues(
          baseUrl: dotenv.env['PRODUCTION']!,
          environmentName: 'PRODUCTION',
          bannerColor: Colors.transparent,
        );
      default:
        return FlavorValues(
          baseUrl: dotenv.env['PRODUCTION']!,
          environmentName: 'PRODUCTION',
          bannerColor: Colors.transparent,
        );
    }
  }
}
