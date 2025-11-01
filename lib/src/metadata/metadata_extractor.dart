import '../models/results.dart';
import '../parsing/url_patterns.dart';

/// Extracts metadata from Amazon URLs
class MetadataExtractor {
  /// Extract title from URL (if encoded in path/query)
  static String? extractTitle(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;

      // Try to decode title from path segments
      // Format: /Product-Name/dp/ASIN or /dp/Product-Name/ASIN
      final segments = path.split('/');
      for (final segment in segments) {
        if (segment.isNotEmpty &&
            !segment.contains('dp') &&
            !segment.contains('gp') &&
            !RegExp(r'^[A-Z0-9]{10}$').hasMatch(segment)) {
          try {
            final decoded = Uri.decodeComponent(segment);
            if (decoded.length > 3) {
              // Filter out common non-title segments
              if (!decoded.toLowerCase().contains('product') &&
                  !decoded.toLowerCase().contains('search')) {
                return decoded.replaceAll('-', ' ').replaceAll('_', ' ');
              }
            }
          } catch (_) {
            // Ignore decode errors
          }
        }
      }

      // Try query parameter
      final titleParam = uri.queryParameters['title'] ?? uri.queryParameters['Title'];
      if (titleParam != null) {
        try {
          return Uri.decodeComponent(titleParam);
        } catch (_) {
          return titleParam;
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Extract price from URL (if present in parameters)
  static PriceInfo? extractPrice(String url) {
    try {
      final uri = Uri.parse(url);

      // Try query parameters
      final priceParam = uri.queryParameters['price'] ?? uri.queryParameters['amount'];
      if (priceParam != null) {
        try {
          final amount = double.parse(priceParam);
          return PriceInfo(
            amount: amount,
            formattedPrice: priceParam,
          );
        } catch (_) {
          // Invalid price format
        }
      }

      // Try regex pattern
      final priceMatch = AmazonUrlPatterns.pricePattern.firstMatch(url);
      if (priceMatch != null && priceMatch.groupCount >= 1) {
        try {
          final amount = double.parse(priceMatch.group(1)!);
          return PriceInfo(amount: amount);
        } catch (_) {
          // Invalid price format
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Extract variants from URL
  static Map<String, String>? extractVariants(String url) {
    try {
      final uri = Uri.parse(url);
      final params = uri.queryParameters;

      final variants = <String, String>{};

      // Common variant parameters
      const variantKeys = ['size', 'color', 'style', 'variant', 'material'];
      for (final key in variantKeys) {
        if (params.containsKey(key)) {
          variants[key] = params[key]!;
        }
      }

      // Also check regex
      final variantMatches = AmazonUrlPatterns.variantPattern.allMatches(url);
      for (final match in variantMatches) {
        if (match.groupCount >= 2) {
          final key = match.group(1);
          final value = match.group(2);
          if (key != null && value != null) {
            variants[key] = value;
          }
        }
      }

      return variants.isEmpty ? null : variants;
    } catch (_) {
      return null;
    }
  }

  /// Extract seller information
  static SellerInfo? extractSellerInfo(String url) {
    try {
      final uri = Uri.parse(url);
      final sellerId = uri.queryParameters['seller'] ?? uri.queryParameters['merchantId'];

      if (sellerId == null) {
        final sellerMatch = AmazonUrlPatterns.sellerPattern.firstMatch(url);
        if (sellerMatch != null && sellerMatch.groupCount >= 1) {
          return SellerInfo(sellerId: sellerMatch.group(1));
        }
        return null;
      }

      return SellerInfo(
        sellerId: sellerId,
        marketplace: _extractMarketplace(url),
      );
    } catch (_) {
      return null;
    }
  }

  /// Extract marketplace from URL
  static String? _extractMarketplace(String url) {
    // Marketplace is typically determined by domain
    // This would be filled by domain mapper
    return null;
  }

  /// Extract product metadata
  static ProductMetadata extractProductMetadata(String url) {
    return ProductMetadata(
      variants: extractVariants(url),
      sellerInfo: extractSellerInfo(url),
    );
  }

  /// Extract availability info (limited - mostly from URL patterns)
  static AvailabilityInfo? extractAvailabilityInfo(String url) {
    // Amazon URLs don't typically contain availability in URL
    // This would require scraping or API
    // Return null for now - can be enhanced with API integration
    return null;
  }
}

