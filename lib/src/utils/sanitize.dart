/// Sanitize Amazon URLs by removing tracking parameters
class AmazonUrlSanitizer {
  /// Parameters to remove (tracking, analytics, etc.)
  static const Set<String> trackingParams = {
    'ref',
    'ref_',
    'refRID',
    'sr',
    'sr_',
    'ie',
    'pf_rd_r',
    'pf_rd_p',
    'pf_rd_m',
    'pf_rd_s',
    'pf_rd_t',
    'pf_rd_i',
    'psc',
    'tag',
    'AssociateTag',
    'linkCode',
    'creativeASIN',
    'creative',
    'keywords',
    'qid',
    'colid',
    'sr_1_',
    'srs',
    'rh',
    'rw_',
    'rw',
    'coliid',
    'spLa',
    'sp_csd',
    'sprefix',
    'fbclid',
    'gclid',
    'utm_source',
    'utm_medium',
    'utm_campaign',
    'utm_term',
    'utm_content',
    '_encoding',
    'pd_rd_w',
    'pd_rd_wg',
    'pd_rd_r',
    'pd_rd_i',
    'th=1',
    'psc=1',
    'm=A',
    'm=A1',
    'm=A2',
    'm=A3',
    'seller',
    'store',
  };

  /// Parameters to preserve (essential for product identification)
  static const Set<String> preserveParams = {
    'asin',
    'ASIN',
    'k', // search keyword
    'i', // category
    'node', // category node
    'rh', // refinement (sometimes needed)
    'size', // variant
    'color', // variant
    'style', // variant
    'variant', // variant
  };

  /// Sanitize URL by removing tracking parameters
  static Uri sanitizeUri(Uri uri, {bool preserveAffiliate = false}) {
    final params = Map<String, String>.from(uri.queryParameters);

    // Remove tracking parameters
    params.removeWhere((key, _) {
      // Always preserve essential params
      if (preserveParams.contains(key)) {
        return false;
      }

      // Preserve affiliate tags if requested
      if (preserveAffiliate && _isAffiliateParam(key)) {
        return false;
      }

      // Remove tracking params
      if (trackingParams.contains(key)) {
        return true;
      }

      // Remove params that start with ref_, pf_rd_, etc.
      if (key.startsWith('ref_') ||
          key.startsWith('pf_rd_') ||
          key.startsWith('pd_rd_') ||
          key.startsWith('rw_') ||
          key.startsWith('sr_')) {
        return true;
      }

      return false;
    });

    return uri.replace(queryParameters: params);
  }

  /// Sanitize URL string
  static String sanitizeUrl(String url, {bool preserveAffiliate = false}) {
    try {
      final uri = Uri.parse(url);
      final sanitized = sanitizeUri(uri, preserveAffiliate: preserveAffiliate);
      return sanitized.toString();
    } catch (_) {
      return url;
    }
  }

  /// Check if parameter is an affiliate parameter
  static bool _isAffiliateParam(String key) {
    return key == 'tag' || key == 'AssociateTag' || key == 'linkCode';
  }

  /// Extract clean product URL (canonical format)
  static String? getCanonicalUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final asin = _extractAsinFromUrl(url);

      if (asin == null) {
        return null;
      }

      // Build canonical URL: https://{domain}/dp/{ASIN}
      return 'https://${uri.host}/dp/$asin';
    } catch (_) {
      return null;
    }
  }

  /// Helper to extract ASIN (simplified version)
  static String? _extractAsinFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;

      // Try common patterns
      final patterns = [
        RegExp(r'/dp/([A-Z0-9]{10})', caseSensitive: false),
        RegExp(r'/gp/product/([A-Z0-9]{10})', caseSensitive: false),
        RegExp(r'/product/([A-Z0-9]{10})', caseSensitive: false),
      ];

      for (final pattern in patterns) {
        final match = pattern.firstMatch(path);
        if (match != null && match.groupCount >= 1) {
          final asin = match.group(1)!.toUpperCase();
          if (RegExp(r'^[A-Z0-9]{10}$').hasMatch(asin)) {
            return asin;
          }
        }
      }

      // Try query param
      final asin = uri.queryParameters['asin'] ?? uri.queryParameters['ASIN'];
      if (asin != null &&
          RegExp(r'^[A-Z0-9]{10}$').hasMatch(asin.toUpperCase())) {
        return asin.toUpperCase();
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
