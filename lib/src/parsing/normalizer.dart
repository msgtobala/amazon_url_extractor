import '../models/results.dart';
import 'asin_extractor.dart';
import 'url_patterns.dart';
import '../utils/sanitize.dart';
import '../domains/domain_mapper.dart';

/// Normalizes Amazon URLs to canonical format
class AmazonUrlNormalizer {
  /// Normalize URL to canonical product URL format
  static String? canonicalProductUrl(String url, {String? asin}) {
    try {
      final domain = DomainMapper.getDomainInfo(url);
      if (domain == null) {
        return null;
      }

      final productAsin = asin ?? AsinExtractor.extractAsin(url);
      if (productAsin == null) {
        return null;
      }

      // Build canonical: https://{domain}/dp/{ASIN}
      return 'https://${domain.domain}/dp/$productAsin';
    } catch (_) {
      return null;
    }
  }

  /// Normalize and sanitize URL
  static String normalizeUrl(String url, {bool preserveAffiliate = false}) {
    try {
      final sanitized = AmazonUrlSanitizer.sanitizeUrl(
        url,
        preserveAffiliate: preserveAffiliate,
      );
      return sanitized;
    } catch (_) {
      return url;
    }
  }

  /// Build product URL with options
  static String buildProductUrl({
    required String asin,
    required String domain,
    String? affiliateTag,
    Map<String, String>? variants,
    String? sellerId,
  }) {
    final uri = Uri.https(domain, '/dp/$asin');

    final params = <String, String>{};

    if (affiliateTag != null) {
      params['tag'] = affiliateTag;
    }

    if (sellerId != null) {
      params['seller'] = sellerId;
    }

    if (variants != null && variants.isNotEmpty) {
      params.addAll(variants);
    }

    if (params.isNotEmpty) {
      return uri.replace(queryParameters: params).toString();
    }

    return uri.toString();
  }

  /// Build affiliate URL
  static String buildAffiliateUrl({
    required String url,
    required String affiliateTag,
  }) {
    try {
      final uri = Uri.parse(url);
      final params = Map<String, String>.from(uri.queryParameters);
      params['tag'] = affiliateTag;

      return uri.replace(queryParameters: params).toString();
    } catch (_) {
      return url;
    }
  }

  /// Extract URL type
  static UrlType detectUrlType(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();
      final query = uri.query;

      if (AmazonUrlPatterns.wishlistPattern.hasMatch(path)) {
        return UrlType.wishlist;
      }

      if (path.contains('/s') && query.contains('k=')) {
        return UrlType.search;
      }
      if (AmazonUrlPatterns.searchPattern.hasMatch(query)) {
        return UrlType.search;
      }

      if (AmazonUrlPatterns.storePattern.hasMatch(path)) {
        return UrlType.store;
      }

      if (AmazonUrlPatterns.reviewPattern.hasMatch(path)) {
        return UrlType.review;
      }

      if (path.contains('/cart') || path.contains('/gp/cart')) {
        return UrlType.cart;
      }

      // Check for product patterns
      if (AsinExtractor.extractAsin(url) != null) {
        return UrlType.product;
      }

      return UrlType.unknown;
    } catch (_) {
      return UrlType.unknown;
    }
  }
}
