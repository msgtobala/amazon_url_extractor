import '../models/errors.dart';
import '../parsing/url_patterns.dart';
import '../parsing/asin_extractor.dart';
import '../domains/domain_mapper.dart';

/// Validation utilities for Amazon URLs and ASINs
class AmazonUrlValidators {
  /// Validate if URL is a valid Amazon URL
  static bool isValidAmazonUrl(String url) {
    if (url.isEmpty) {
      return false;
    }

    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
        return false;
      }

      return AmazonUrlPatterns.isAmazonUrl(url) ||
          DomainMapper.isDomainSupported(url);
    } catch (_) {
      return false;
    }
  }

  /// Validate and throw exception if invalid
  static void validateAmazonUrl(String url) {
    if (!isValidAmazonUrl(url)) {
      throw InvalidUrlException('Invalid Amazon URL: $url');
    }
  }

  /// Validate ASIN format
  static bool isValidAsin(String asin) {
    return AsinExtractor.isValidAsin(asin);
  }

  /// Validate and throw exception if ASIN is invalid
  static void validateAsin(String asin) {
    if (!isValidAsin(asin)) {
      throw InvalidAsinException('Invalid ASIN format: $asin');
    }
  }

  /// Validate domain
  static bool isValidDomain(String domain) {
    return DomainMapper.isDomainSupported(domain);
  }

  /// Validate and throw exception if domain is invalid
  static void validateDomain(String domain) {
    if (!isValidDomain(domain)) {
      throw UnsupportedDomainException('Unsupported Amazon domain: $domain');
    }
  }

  /// Validate coordinates (for geographic validation if needed)
  static bool isValidCoordinates(double lat, double lng) {
    return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
  }
}

