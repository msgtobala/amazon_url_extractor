import 'models/entities.dart';
import 'models/results.dart';
import 'models/errors.dart';
import 'parsing/url_patterns.dart';
import 'parsing/asin_extractor.dart';
import 'parsing/normalizer.dart';
import 'parsing/short_url_expander.dart';
import 'domains/domain_mapper.dart';
import 'affiliate/affiliate_handler.dart';
import 'metadata/metadata_extractor.dart';
import 'utils/validators.dart';

/// Main extractor class for Amazon URLs
class AmazonUrlExtractor {
  const AmazonUrlExtractor();

  /// Extract entity from URL
  ParseResult<ExtractedEntity> extract(String inputUrl) {
    try {
      // Validate URL
      if (!AmazonUrlValidators.isValidAmazonUrl(inputUrl)) {
        return ParseResult.fail('Invalid Amazon URL');
      }

      final uri = Uri.parse(inputUrl);
      final urlType = AmazonUrlNormalizer.detectUrlType(inputUrl);

      // Extract based on URL type
      switch (urlType) {
        case UrlType.product:
          final asin = AsinExtractor.extractAsin(inputUrl);
          if (asin == null) {
            return ParseResult.fail('Could not extract ASIN from product URL');
          }

          // Extract variant info
          final variants = MetadataExtractor.extractVariants(inputUrl);
          final sellerId =
              MetadataExtractor.extractSellerInfo(inputUrl)?.sellerId;

          return ParseResult.ok(
            ExtractedEntity.product(
              ProductRef(
                asin: asin,
                variantParams: variants,
                sellerId: sellerId,
              ),
            ),
          );

        case UrlType.wishlist:
          final match = AmazonUrlPatterns.wishlistPattern.firstMatch(uri.path);
          if (match != null && match.groupCount >= 1) {
            return ParseResult.ok(
              ExtractedEntity.wishlist(match.group(1)!),
            );
          }
          return ParseResult.fail('Could not extract wishlist ID');

        case UrlType.search:
          final match = AmazonUrlPatterns.searchPattern.firstMatch(uri.query);
          if (match != null && match.groupCount >= 1) {
            final query = Uri.decodeComponent(match.group(1)!);
            return ParseResult.ok(ExtractedEntity.search(query));
          }
          return ParseResult.fail('Could not extract search query');

        case UrlType.store:
          final match = AmazonUrlPatterns.storePattern.firstMatch(uri.path);
          if (match != null && match.groupCount >= 1) {
            return ParseResult.ok(ExtractedEntity.store(match.group(1)!));
          }
          return ParseResult.fail('Could not extract store ID');

        case UrlType.review:
          final match = AmazonUrlPatterns.reviewPattern.firstMatch(uri.path);
          if (match != null && match.groupCount >= 1) {
            return ParseResult.ok(ExtractedEntity.review(match.group(1)!));
          }
          return ParseResult.fail('Could not extract review ID');

        case UrlType.cart:
        case UrlType.unknown:
          return ParseResult.fail('Unsupported URL type: $urlType');
      }
    } catch (e) {
      return ParseResult.fail('Error extracting entity: $e');
    }
  }

  /// Extract comprehensive product information
  Future<ExtractionResult> extractProductInfo(String url) async {
    // Expand short URL if needed
    String expandedUrl = url;
    if (ShortUrlExpander.isShortUrl(url)) {
      try {
        expandedUrl = await ShortUrlExpander.expandShortUrl(url);
      } catch (e) {
        throw UrlExpansionException('Failed to expand URL: $e');
      }
    }

    // Validate URL
    AmazonUrlValidators.validateAmazonUrl(expandedUrl);

    // Extract domain info
    final domain = DomainMapper.getDomainInfo(expandedUrl);
    if (domain == null) {
      throw UnsupportedDomainException('Unsupported Amazon domain');
    }

    // Extract ASIN
    final asin = AsinExtractor.extractAsin(expandedUrl);
    if (asin == null) {
      throw AsinExtractionException('Could not extract ASIN from URL');
    }

    // Extract URL type
    final urlType = AmazonUrlNormalizer.detectUrlType(expandedUrl);

    // Extract title
    final title = MetadataExtractor.extractTitle(expandedUrl);

    // Extract price
    final price = MetadataExtractor.extractPrice(expandedUrl);

    // Extract availability
    final availability = MetadataExtractor.extractAvailabilityInfo(expandedUrl);

    // Extract metadata
    final metadata = MetadataExtractor.extractProductMetadata(expandedUrl);

    // Extract affiliate info
    final affiliateInfo = AffiliateHandler.extractAffiliateInfo(expandedUrl);

    // Get canonical URL
    final canonicalUrl =
        AmazonUrlNormalizer.canonicalProductUrl(expandedUrl, asin: asin);

    return ExtractionResult(
      asin: asin,
      title: title,
      price: price,
      availability: availability,
      metadata: metadata,
      affiliateInfo: affiliateInfo,
      canonicalUrl: canonicalUrl,
      domain: domain,
      urlType: urlType,
    );
  }

  /// Extract only ASIN from URL
  String? extractAsin(String url) {
    return AsinExtractor.extractAsin(url);
  }

  /// Extract ASIN or throw exception
  String extractAsinOrThrow(String url) {
    return AsinExtractor.extractAsinOrThrow(url);
  }

  /// Process Amazon URL (expand if needed, then extract)
  Future<ExtractionResult> processAmazonUrl(String url) async {
    return extractProductInfo(url);
  }

  /// Process batch of URLs
  Future<List<ExtractionResult?>> processBatch(List<String> urls) async {
    final results = <ExtractionResult?>[];
    for (final url in urls) {
      try {
        final result = await processAmazonUrl(url);
        results.add(result);
      } catch (_) {
        results.add(null);
      }
    }
    return results;
  }
}
