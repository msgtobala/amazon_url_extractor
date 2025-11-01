import '../models/errors.dart';
import 'url_patterns.dart';

/// Extracts ASIN from Amazon URLs
class AsinExtractor {
  /// Extract ASIN from URL
  static String? extractAsin(String url) {
    try {
      final uri = Uri.parse(url);

      // Try patterns in path
      final patterns = [
        AmazonUrlPatterns.dpPattern,
        AmazonUrlPatterns.gpProductPattern,
        AmazonUrlPatterns.productPattern,
        AmazonUrlPatterns.awdPattern,
        AmazonUrlPatterns.oPattern,
        AmazonUrlPatterns.execPattern,
      ];

      for (final pattern in patterns) {
        final match = pattern.firstMatch(uri.path);
        if (match != null && match.groupCount >= 1) {
          final asin = match.group(1)!.toUpperCase();
          if (_isValidAsin(asin)) {
            return asin;
          }
        }
      }

      // Try direct ASIN in path
      final directMatch =
          AmazonUrlPatterns.directAsinPattern.firstMatch(uri.path);
      if (directMatch != null && directMatch.groupCount >= 1) {
        final asin = directMatch.group(1)!.toUpperCase();
        if (_isValidAsin(asin)) {
          return asin;
        }
      }

      // Try ASIN in query parameters
      final asinQuery =
          uri.queryParameters['asin'] ?? uri.queryParameters['ASIN'];
      if (asinQuery != null) {
        final asin = asinQuery.toUpperCase();
        if (_isValidAsin(asin)) {
          return asin;
        }
      }

      // Try ASIN in query string (regex)
      final queryMatch =
          AmazonUrlPatterns.asinQueryPattern.firstMatch(uri.query);
      if (queryMatch != null && queryMatch.groupCount >= 1) {
        final asin = queryMatch.group(1)!.toUpperCase();
        if (_isValidAsin(asin)) {
          return asin;
        }
      }

      return null;
    } catch (e) {
      throw AsinExtractionException('Failed to extract ASIN: $e');
    }
  }

  /// Validate ASIN format
  static bool _isValidAsin(String asin) {
    if (asin.length != 10) {
      return false;
    }
    // ASIN is 10 characters, alphanumeric
    return RegExp(r'^[A-Z0-9]{10}$').hasMatch(asin);
  }

  /// Validate ASIN (public method)
  static bool isValidAsin(String asin) {
    return _isValidAsin(asin.toUpperCase());
  }

  /// Extract ASIN or throw exception
  static String extractAsinOrThrow(String url) {
    final asin = extractAsin(url);
    if (asin == null) {
      throw AsinExtractionException('Could not extract ASIN from URL: $url');
    }
    if (!_isValidAsin(asin)) {
      throw InvalidAsinException('Invalid ASIN format: $asin');
    }
    return asin;
  }
}
