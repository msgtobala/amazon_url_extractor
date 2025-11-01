# Amazon URL Extractor

A comprehensive Flutter package to extract ASIN, product information, prices, and metadata from Amazon URLs. Supports all Amazon domains, affiliate links, shortened URLs, and provides widgets for displaying product information.

## Features

### Core Functionality
- ✅ **Extract ASIN** from various Amazon URL formats
- ✅ **Extract product titles** from URLs (when available)
- ✅ **Extract prices** from URL parameters (when available)
- ✅ **Multi-domain support** - All major Amazon domains (.com, .in, .uk, .ca, .au, .de, .fr, .it, .es, .jp, .mx, .br, .nl, etc.)
- ✅ **Affiliate link handling** - Detect and manage affiliate tags
- ✅ **Short URL expansion** - Expand amzn.to, amzn.eu shortened URLs
- ✅ **URL normalization** - Convert to canonical product URLs
- ✅ **URL sanitization** - Remove tracking parameters

### Advanced Features
- ✅ **Batch processing** for multiple URLs
- ✅ **Intelligent caching** with LRU eviction policy
- ✅ **Robust error handling** with custom exceptions
- ✅ **URL validation** and ASIN validation
- ✅ **Product metadata extraction** - Variants, seller info, etc.
- ✅ **Availability detection** (limited - requires API for full support)
- ✅ **URL builders** - Build affiliate URLs, variant URLs, etc.

### Flutter Widgets
- ✅ **Product Preview Widget** - Display product link previews
- ✅ **Product Card Widget** - Rich product card component

### Optional Features
- 🔄 **Amazon Product Advertising API integration** (placeholder - requires AWS SDK for full implementation)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  amazon_url_extractor: ^0.1.0
```

or run

```bash
flutter pub add amazon_url_extractor
```

## Quick Start

### Basic ASIN Extraction

```dart
import 'package:amazon_url_extractor/amazon_url_extractor.dart';

void main() {
  const extractor = AmazonUrlExtractor();
  
  // Extract ASIN
  const url = 'https://www.amazon.com/dp/B08N5WRWNW';
  final asin = extractor.extractAsin(url);
  print('ASIN: $asin'); // B08N5WRWNW
}
```

### Comprehensive Product Information

```dart
void main() async {
  const extractor = AmazonUrlExtractor();
  
  const url = 'https://www.amazon.com/dp/B08N5WRWNW?tag=affiliate-20';
  
  try {
    final result = await extractor.extractProductInfo(url);
    
    print('ASIN: ${result.asin}');
    print('Domain: ${result.domain.domain}');
    print('Country: ${result.domain.countryCode}');
    print('Currency: ${result.domain.currency}');
    print('Title: ${result.title}');
    print('Price: ${result.price?.formattedPrice}');
    print('Affiliate Tag: ${result.affiliateInfo?.tag}');
    print('Canonical URL: ${result.canonicalUrl}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Extract Entity from URL

```dart
void main() {
  const extractor = AmazonUrlExtractor();
  
  // Product URL
  final productResult = extractor.extract('https://www.amazon.com/dp/B08N5WRWNW');
  if (productResult.isSuccess && productResult.value!.type == UrlType.product) {
    final asin = productResult.value!.product!.asin;
    print('Product ASIN: $asin');
  }
  
  // Search URL
  final searchResult = extractor.extract('https://www.amazon.com/s?k=laptop');
  if (searchResult.isSuccess && searchResult.value!.type == UrlType.search) {
    final query = searchResult.value!.searchQuery;
    print('Search query: $query');
  }
}
```

## API Reference

### Core Methods

#### `extractAsin(String url)`
Extracts ASIN from an Amazon URL.

```dart
final asin = extractor.extractAsin(url);
if (asin != null) {
  print('ASIN: $asin');
}
```

#### `extractProductInfo(String url)`
Extracts comprehensive product information.

```dart
final result = await extractor.extractProductInfo(url);
print('ASIN: ${result.asin}');
print('Title: ${result.title}');
print('Price: ${result.price?.formattedPrice}');
print('Domain: ${result.domain.domain}');
```

#### `processAmazonUrl(String url)`
Processes any Amazon URL (expands if needed, then extracts).

```dart
final result = await extractor.processAmazonUrl(url);
```

### URL Processing

#### `expandShortUrl(String shortUrl)`
Expands shortened Amazon URLs (amzn.to, amzn.eu).

```dart
try {
  final expanded = await ShortUrlExpander.expandShortUrl('https://amzn.to/abc123');
  print('Expanded: $expanded');
} catch (e) {
  print('Error: $e');
}
```

#### `canonicalProductUrl(String url)`
Converts URL to canonical format.

```dart
final canonical = AmazonUrlNormalizer.canonicalProductUrl(url);
print('Canonical: $canonical'); // https://amazon.com/dp/B08N5WRWNW
```

### Batch Processing

#### `processBatch(List<String> urls)`
Processes multiple URLs in batch.

```dart
final urls = [
  'https://www.amazon.com/dp/B08N5WRWNW',
  'https://www.amazon.in/dp/B08N5WRWNW',
];
final results = await extractor.processBatch(urls);
for (int i = 0; i < results.length; i++) {
  if (results[i] != null) {
    print('URL ${i + 1}: ASIN ${results[i]!.asin}');
  }
}
```

### Validation

#### `isValidAmazonUrl(String url)`
Validates if a URL is a valid Amazon URL.

```dart
final isValid = AmazonUrlValidators.isValidAmazonUrl(url);
print('Valid: $isValid');
```

#### `isValidAsin(String asin)`
Validates ASIN format.

```dart
final isValid = AsinExtractor.isValidAsin('B08N5WRWNW');
print('Valid ASIN: $isValid');
```

### Affiliate Handling

#### `extractAffiliateInfo(String url)`
Extracts affiliate information from URL.

```dart
final info = AffiliateHandler.extractAffiliateInfo(url);
if (info.hasAffiliateTag) {
  print('Affiliate tag: ${info.tag}');
}
```

#### `addAffiliateTag(String url, String tag)`
Adds affiliate tag to URL.

```dart
final urlWithTag = AffiliateHandler.addAffiliateTag(url, 'my-tag-20');
```

### URL Builders

#### `buildProductUrl(...)`
Builds product URL with options.

```dart
final url = AmazonUrlBuilders.buildProductUrl(
  asin: 'B08N5WRWNW',
  domainOrUrl: 'amazon.com',
  affiliateTag: 'test-20',
  variants: {'size': 'large', 'color': 'black'},
);
```

### Domain Information

#### `getDomainInfo(String urlOrDomain)`
Gets domain information (country, currency, marketplace).

```dart
final domain = DomainMapper.getDomainInfo('https://www.amazon.in/dp/B08N5WRWNW');
print('Country: ${domain!.countryCode}'); // IN
print('Currency: ${domain.currency}'); // INR
print('Marketplace: ${domain.marketplace}');
```

### Cache Management

#### `clearCache()`
Clears the internal cache.

```dart
UrlExpansionCache.clear();
```

#### `getCacheSize()`
Gets current cache size.

```dart
final size = UrlExpansionCache.size;
print('Cache size: $size');
```

## Flutter Widgets

### Product Preview

```dart
AmazonProductPreview(
  imageUrl: 'https://example.com/image.jpg',
  title: 'Product Title',
  price: PriceInfo(formattedPrice: '\$29.99'),
  availability: AvailabilityInfo(status: AvailabilityStatus.inStock),
  asin: 'B08N5WRWNW',
  onTap: () {
    // Handle tap
  },
)
```

### Product Card

```dart
AmazonProductCard(
  imageUrl: 'https://example.com/image.jpg',
  title: 'Product Title',
  subtitle: 'Product Subtitle',
  price: PriceInfo(formattedPrice: '\$29.99'),
  availability: AvailabilityInfo(
    status: AvailabilityStatus.inStock,
    isPrimeEligible: true,
  ),
  reviewInfo: ReviewInfo(
    averageRating: 4.5,
    totalReviews: 1234,
  ),
  asin: 'B08N5WRWNW',
  onTap: () {
    // Handle tap
  },
)
```

## Supported URL Formats

This package supports multiple Amazon URL formats:

- **Product URLs**: `/dp/ASIN`, `/gp/product/ASIN`, `/product/ASIN`
- **Short URLs**: `amzn.to`, `amzn.eu`, `a.co`
- **Affiliate URLs**: URLs with `tag`, `AssociateTag`, `linkCode` parameters
- **Wishlist URLs**: `/gp/registry/wishlist/ID`
- **Search URLs**: `/s?k=query`
- **Store URLs**: `/stores/ID`
- **Review URLs**: `/review/ID`

## Supported Domains

- amazon.com (US)
- amazon.co.uk (UK)
- amazon.ca (Canada)
- amazon.de (Germany)
- amazon.fr (France)
- amazon.it (Italy)
- amazon.es (Spain)
- amazon.in (India)
- amazon.co.jp (Japan)
- amazon.com.au (Australia)
- amazon.com.mx (Mexico)
- amazon.com.br (Brazil)
- amazon.nl (Netherlands)
- amazon.se (Sweden)
- amazon.pl (Poland)
- amazon.sg (Singapore)
- amazon.ae (UAE)
- amazon.sa (Saudi Arabia)
- amazon.tr (Turkey)
- amazon.eg (Egypt)

## Error Handling

The package provides comprehensive error handling with custom exceptions:

```dart
try {
  final result = await extractor.extractProductInfo(url);
} on InvalidUrlException catch (e) {
  print('Invalid URL: ${e.message}');
} on UrlExpansionException catch (e) {
  print('URL expansion failed: ${e.message}');
} on AsinExtractionException catch (e) {
  print('ASIN extraction failed: ${e.message}');
} on UnsupportedDomainException catch (e) {
  print('Unsupported domain: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

### Exception Types

- `InvalidUrlException`: Invalid URL format
- `UrlExpansionException`: Short URL expansion failed
- `AsinExtractionException`: ASIN extraction failed
- `InvalidAsinException`: Invalid ASIN format
- `UnsupportedDomainException`: Unsupported Amazon domain
- `NetworkException`: Network-related errors
- `ApiException`: API-related errors

## Performance Features

### Caching
- **Automatic caching** of expanded URLs
- **LRU eviction policy** to manage memory usage
- **Configurable cache size** (default: 100 entries)
- **Cache management** methods for manual control

### Batch Processing
- **Efficient batch processing** for multiple URLs
- **Error isolation** - one failed URL doesn't affect others
- **Memory efficient** processing

## Amazon Product Advertising API (Optional)

For fetching detailed product information, you can integrate with Amazon PA-API. This package provides a placeholder interface. For full implementation, use AWS SDK or implement proper AWS Signature Version 4 signing.

```dart
final api = AmazonProductAdvertisingApi(
  accessKey: 'your-access-key',
  secretKey: 'your-secret-key',
  partnerTag: 'your-associate-tag',
);

// Note: Full implementation requires AWS Signature Version 4 signing
// See: https://webservices.amazon.com/paapi5/documentation/
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
