import 'package:flutter_test/flutter_test.dart';
import 'package:amazon_url_extractor/amazon_url_extractor.dart';

void main() {
  group('AmazonUrlExtractor', () {
    final extractor = AmazonUrlExtractor();

    test('extract ASIN from standard product URL', () {
      const url = 'https://www.amazon.com/dp/B08N5WRWNW';
      final asin = extractor.extractAsin(url);
      expect(asin, equals('B08N5WRWNW'));
    });

    test('extract ASIN from various URL formats', () {
      final testCases = [
        ('https://www.amazon.com/dp/B08N5WRWNW', 'B08N5WRWNW'),
        ('https://www.amazon.com/gp/product/B08N5WRWNW', 'B08N5WRWNW'),
        ('https://www.amazon.com/product/B08N5WRWNW', 'B08N5WRWNW'),
        ('https://amazon.com/dp/B08N5WRWNW?tag=test-20', 'B08N5WRWNW'),
        ('https://www.amazon.in/dp/B08N5WRWNW', 'B08N5WRWNW'),
        ('https://www.amazon.co.uk/dp/B08N5WRWNW', 'B08N5WRWNW'),
      ];

      for (final (url, expectedAsin) in testCases) {
        final asin = extractor.extractAsin(url);
        expect(asin, equals(expectedAsin), reason: 'Failed for URL: $url');
      }
    });

    test('validate ASIN format', () {
      expect(AsinExtractor.isValidAsin('B08N5WRWNW'), isTrue);
      expect(AsinExtractor.isValidAsin('1234567890'), isTrue);
      expect(AsinExtractor.isValidAsin('invalid'), isFalse);
      expect(AsinExtractor.isValidAsin('B08N5WRWNWX'), isFalse); // 11 chars
      expect(AsinExtractor.isValidAsin('B08N5WRWN'), isFalse); // 9 chars
    });

    test('extract entity from product URL', () {
      const url = 'https://www.amazon.com/dp/B08N5WRWNW';
      final result = extractor.extract(url);

      expect(result.isSuccess, isTrue);
      expect(result.value, isNotNull);
      expect(result.value!.type, equals(UrlType.product));
      expect(result.value!.product?.asin, equals('B08N5WRWNW'));
    });

    test('detect URL type', () {
      expect(
        AmazonUrlNormalizer.detectUrlType(
          'https://www.amazon.com/dp/B08N5WRWNW',
        ),
        equals(UrlType.product),
      );
      expect(
        AmazonUrlNormalizer.detectUrlType(
          'https://www.amazon.com/gp/registry/wishlist/ABC123',
        ),
        equals(UrlType.wishlist),
      );
      expect(
        AmazonUrlNormalizer.detectUrlType(
          'https://www.amazon.com/s?k=laptop',
        ),
        equals(UrlType.search),
      );
    });

    test('extract affiliate information', () {
      const url = 'https://www.amazon.com/dp/B08N5WRWNW?tag=test-20';
      final info = AffiliateHandler.extractAffiliateInfo(url);

      expect(info.tag, equals('test-20'));
      expect(info.hasAffiliateTag, isTrue);
    });

    test('domain mapping', () {
      final domain =
          DomainMapper.getDomainInfo('https://www.amazon.com/dp/B08N5WRWNW');
      expect(domain, isNotNull);
      expect(domain!.countryCode, equals('US'));
      expect(domain.currency, equals('USD'));

      final domainIn =
          DomainMapper.getDomainInfo('https://www.amazon.in/dp/B08N5WRWNW');
      expect(domainIn, isNotNull);
      expect(domainIn!.countryCode, equals('IN'));
      expect(domainIn.currency, equals('INR'));
    });

    test('validate Amazon URL', () {
      expect(
          AmazonUrlValidators.isValidAmazonUrl(
              'https://www.amazon.com/dp/B08N5WRWNW'),
          isTrue);
      expect(
          AmazonUrlValidators.isValidAmazonUrl(
              'https://www.amazon.in/dp/B08N5WRWNW'),
          isTrue);
      expect(AmazonUrlValidators.isValidAmazonUrl('https://www.google.com'),
          isFalse);
      expect(AmazonUrlValidators.isValidAmazonUrl('not-a-url'), isFalse);
    });

    test('sanitize URL', () {
      const url =
          'https://www.amazon.com/dp/B08N5WRWNW?tag=test-20&ref=sr_1_1&sr=8-1';
      final sanitized = AmazonUrlSanitizer.sanitizeUrl(url);

      expect(sanitized, contains('B08N5WRWNW'));
      expect(sanitized, isNot(contains('sr=')));
      expect(sanitized, isNot(contains('ref=')));
    });

    test('build canonical URL', () {
      const url = 'https://www.amazon.com/gp/product/B08N5WRWNW?tag=test-20';
      final canonical = AmazonUrlNormalizer.canonicalProductUrl(url);

      expect(canonical, equals('https://amazon.com/dp/B08N5WRWNW'));
    });

    test('build product URL with options', () {
      final url = AmazonUrlBuilders.buildProductUrl(
        asin: 'B08N5WRWNW',
        domainOrUrl: 'amazon.com',
        affiliateTag: 'test-20',
        variants: {'size': 'large', 'color': 'black'},
      );

      expect(url, contains('B08N5WRWNW'));
      expect(url, contains('tag=test-20'));
      expect(url, contains('size=large'));
      expect(url, contains('color=black'));
    });
  });

  group('SupportedDomains', () {
    test('check supported domains', () {
      expect(SupportedDomains.isSupported('amazon.com'), isTrue);
      expect(SupportedDomains.isSupported('amazon.in'), isTrue);
      expect(SupportedDomains.isSupported('amazon.co.uk'), isTrue);
      expect(SupportedDomains.isSupported('amazon.ca'), isTrue);
      expect(SupportedDomains.isSupported('invalid.com'), isFalse);
    });

    test('extract domain from URL', () {
      expect(
        SupportedDomains.extractDomain('https://www.amazon.com/dp/B08N5WRWNW'),
        equals('amazon.com'),
      );
      expect(
        SupportedDomains.extractDomain('https://amazon.in/dp/B08N5WRWNW'),
        equals('amazon.in'),
      );
    });
  });

  group('Cache', () {
    test('cache operations', () {
      final cache = CacheManager(maxSize: 10);

      cache.put('key1', 'value1');
      expect(cache.get('key1'), equals('value1'));
      expect(cache.containsKey('key1'), isTrue);

      cache.put('key2', 'value2');
      expect(cache.size, equals(2));

      cache.clear();
      expect(cache.size, equals(0));
    });

    test('LRU eviction', () {
      final cache = CacheManager(maxSize: 2);

      cache.put('key1', 'value1');
      cache.put('key2', 'value2');
      cache.put('key3', 'value3'); // Should evict key1

      expect(cache.containsKey('key1'), isFalse);
      expect(cache.containsKey('key2'), isTrue);
      expect(cache.containsKey('key3'), isTrue);
    });
  });
}
