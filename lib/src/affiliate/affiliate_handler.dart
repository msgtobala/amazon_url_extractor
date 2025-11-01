import '../models/results.dart';
import '../parsing/url_patterns.dart';

/// Handles affiliate link detection and extraction
class AffiliateHandler {
  /// Extract affiliate information from URL
  static AffiliateInfo extractAffiliateInfo(String url) {
    try {
      final uri = Uri.parse(url);

      // Check query parameters
      String? tag =
          uri.queryParameters['tag'] ?? uri.queryParameters['AssociateTag'];
      String? linkCode = uri.queryParameters['linkCode'];

      // Try regex patterns
      if (tag == null) {
        final tagMatch = AmazonUrlPatterns.affiliateTagPattern.firstMatch(url);
        if (tagMatch != null && tagMatch.groupCount >= 1) {
          tag = tagMatch.group(1);
        }
      }

      return AffiliateInfo(
        tag: tag,
        linkCode: linkCode,
        associateTag: tag, // Same as tag
      );
    } catch (_) {
      return AffiliateInfo();
    }
  }

  /// Check if URL contains affiliate tag
  static bool hasAffiliateTag(String url) {
    final info = extractAffiliateInfo(url);
    return info.hasAffiliateTag;
  }

  /// Remove affiliate tags from URL
  static String removeAffiliateTags(String url) {
    try {
      final uri = Uri.parse(url);
      final params = Map<String, String>.from(uri.queryParameters);

      params.remove('tag');
      params.remove('AssociateTag');
      params.remove('linkCode');

      return uri.replace(queryParameters: params).toString();
    } catch (_) {
      return url;
    }
  }

  /// Add affiliate tag to URL
  static String addAffiliateTag(String url, String tag) {
    try {
      final uri = Uri.parse(url);
      final params = Map<String, String>.from(uri.queryParameters);
      params['tag'] = tag;

      return uri.replace(queryParameters: params).toString();
    } catch (_) {
      return url;
    }
  }
}
