/// URL patterns for detecting and parsing Amazon URLs
class AmazonUrlPatterns {
  // Main Amazon domain pattern
  static final RegExp amazonDomain = RegExp(
    r'(?:https?://)?(?:www\.)?(?:[a-z]{2,3}\.)?amazon\.(?:com|co\.uk|ca|de|fr|it|es|in|co\.jp|com\.au|com\.mx|com\.br|nl|se|pl|sg|ae|sa|tr|eg)(?:/|$)',
    caseSensitive: false,
  );

  // Product URL patterns
  // /dp/ASIN
  static final RegExp dpPattern =
      RegExp(r'/dp/([A-Z0-9]{10})', caseSensitive: false);
  // /gp/product/ASIN
  static final RegExp gpProductPattern =
      RegExp(r'/gp/product/([A-Z0-9]{10})', caseSensitive: false);
  // /product/ASIN
  static final RegExp productPattern =
      RegExp(r'/product/([A-Z0-9]{10})', caseSensitive: false);
  // /gp/aw/d/ASIN
  static final RegExp awdPattern =
      RegExp(r'/gp/aw/d/([A-Z0-9]{10})', caseSensitive: false);
  // /o/ASIN
  static final RegExp oPattern =
      RegExp(r'/o/([A-Z0-9]{10})', caseSensitive: false);
  // /exec/obidos/ASIN/ASIN
  static final RegExp execPattern =
      RegExp(r'/exec/obidos/ASIN/([A-Z0-9]{10})', caseSensitive: false);
  // /ASIN/ (direct ASIN in path)
  static final RegExp directAsinPattern =
      RegExp(r'^/([A-Z0-9]{10})/?$', caseSensitive: false);

  // ASIN in query parameter
  static final RegExp asinQueryPattern =
      RegExp(r'[&?](?:asin|ASIN)=([A-Z0-9]{10})');

  // Wishlist patterns
  static final RegExp wishlistPattern =
      RegExp(r'/gp/registry/wishlist/([A-Z0-9]+)', caseSensitive: false);

  // Search patterns
  static final RegExp searchPattern = RegExp(r'/s\?.*k=([^&]+)');

  // Store patterns
  static final RegExp storePattern = RegExp(r'/stores/([^/]+)');

  // Review patterns
  static final RegExp reviewPattern = RegExp(r'/review/([A-Z0-9]+)');

  // Short URL patterns (amzn.to, amzn.eu, etc.)
  static final RegExp shortUrlPattern = RegExp(
    r'(?:https?://)?(?:www\.)?(?:amzn\.to|amzn\.eu|a\.co)/([A-Za-z0-9]+)',
    caseSensitive: false,
  );

  // Affiliate tag patterns
  static final RegExp affiliateTagPattern = RegExp(
    r'[&?](?:tag|AssociateTag|linkCode)=([^&]+)',
    caseSensitive: false,
  );

  // Price patterns in URL (rare but possible)
  static final RegExp pricePattern = RegExp(
    r'[&?](?:price|amount)=([0-9.]+)',
    caseSensitive: false,
  );

  // Variant patterns
  static final RegExp variantPattern = RegExp(
    r'[&?](?:size|color|style|variant)=([^&]+)',
    caseSensitive: false,
  );

  // Seller patterns
  static final RegExp sellerPattern = RegExp(r'[&?]seller=([^&]+)');

  // Check if URL is an Amazon URL
  static bool isAmazonUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return amazonDomain.hasMatch(uri.host) ||
          shortUrlPattern.hasMatch(url) ||
          _isAmazonHost(uri.host);
    } catch (_) {
      return false;
    }
  }

  static bool _isAmazonHost(String host) {
    final normalized = host.toLowerCase();
    return normalized.contains('amazon.') ||
        normalized.contains('amzn.') ||
        normalized == 'a.co';
  }
}
