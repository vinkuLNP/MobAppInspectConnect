import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:injectable/injectable.dart';

enum ProductFlavor {
  dev,
  qa,
  sit,
  uat,
  prod,
}

extension ProductFlavorExtension on ProductFlavor? {
  String setBaseUrl() {
    switch (this) {
      case ProductFlavor.dev:
        return devBaseUrl;
      case ProductFlavor.qa:
        return qaBaseUrl;
      case ProductFlavor.sit:
        return qaBaseUrl;
      case ProductFlavor.uat:
        return uatBaseUrl;
      case ProductFlavor.prod:
        return prodBaseUrl;
      default:
        return devBaseUrl;
    }
  }
}

extension StringExtension on String {
  ProductFlavor? toProductFlavor() {
    switch (this) {
      case devEnvironmentString:
        return ProductFlavor.dev;
      case qaEnvironmentString:
        return ProductFlavor.qa;
      case sitEnvironmentString:
        return ProductFlavor.sit;
      case uatEnvironmentString:
        return ProductFlavor.uat;
      case prodEnvironmentString:
        return ProductFlavor.prod;
      default:
        return ProductFlavor.dev;
    }
  }
}

@singleton
class AppFlavorsHelper {
  ProductFlavor? _productFlavor;
  String? _baseUrl;

  void configure({required ProductFlavor? productFlavor}) {
    _productFlavor = productFlavor;
    _baseUrl = productFlavor?.setBaseUrl();
  }

  ProductFlavor? get productFlavor => _productFlavor;

  String? get baseUrl => _baseUrl;
}
