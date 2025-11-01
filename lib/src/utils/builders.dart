import '../domains/domain_mapper.dart';
import '../parsing/normalizer.dart';

/// URL builders for Amazon URLs
class AmazonUrlBuilders {
  /// Build canonical product URL
  static String buildProductUrl({
    required String asin,
    required String domainOrUrl,
    String? affiliateTag,
    Map<String, String>? variants,
    String? sellerId,
  }) {
    String domain;
    try {
      final domainInfo = DomainMapper.getDomainInfo(domainOrUrl);
      if (domainInfo != null) {
        domain = domainInfo.domain;
      } else {
        // Assume domainOrUrl is already a domain
        domain =
            domainOrUrl.replaceAll(RegExp(r'^https?://'), '').split('/').first;
      }
    } catch (_) {
      domain = 'amazon.com'; // Default fallback
    }

    return AmazonUrlNormalizer.buildProductUrl(
      asin: asin,
      domain: domain,
      affiliateTag: affiliateTag,
      variants: variants,
      sellerId: sellerId,
    );
  }

  /// Build affiliate URL
  static String buildAffiliateUrl({
    required String url,
    required String affiliateTag,
  }) {
    return AmazonUrlNormalizer.buildAffiliateUrl(
      url: url,
      affiliateTag: affiliateTag,
    );
  }

  /// Build shareable product URL
  static String buildShareableUrl({
    required String asin,
    required String domainOrUrl,
  }) {
    return buildProductUrl(asin: asin, domainOrUrl: domainOrUrl);
  }

  /// Build variant-specific URL
  static String buildVariantUrl({
    required String baseUrl,
    required Map<String, String> variants,
  }) {
    try {
      final uri = Uri.parse(baseUrl);
      final params = Map<String, String>.from(uri.queryParameters);
      params.addAll(variants);

      return uri.replace(queryParameters: params).toString();
    } catch (_) {
      return baseUrl;
    }
  }
}
