# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2025-11-01

### Fixed

- Formatting issues with Dart formatting.

## [0.1.1] - 2025-11-01

### Fixed

- Deprecation warnings by replacing `withOpacity()` with `withValues(alpha:)` in Flutter widgets
- Search URL detection in URL type detection
- Wishlist pattern matching to be case-insensitive

## [0.1.0] - 2024-12-19

### Added

- Initial release of the Amazon URL Extractor package.
- `AmazonUrlExtractor` class with comprehensive URL processing:
  - `extractAsin`: Extracts ASIN from various Amazon URL formats
  - `extractProductInfo`: Extracts comprehensive product information
  - `extract`: Extracts entity from URL (product, wishlist, search, etc.)
  - `processAmazonUrl`: Processes any Amazon URL (expands if needed, then extracts)
  - `processBatch`: Batch processing for multiple URLs
- **ASIN extraction** from multiple URL formats:
  - `/dp/ASIN`, `/gp/product/ASIN`, `/product/ASIN`
  - ASIN in query parameters
  - Direct ASIN patterns
- **Multi-domain support** for 20+ Amazon domains:
  - amazon.com, amazon.co.uk, amazon.ca, amazon.de, amazon.fr, amazon.it, amazon.es
  - amazon.in, amazon.co.jp, amazon.com.au, amazon.com.mx, amazon.com.br
  - amazon.nl, amazon.se, amazon.pl, amazon.sg, amazon.ae, amazon.sa, amazon.tr, amazon.eg
- **Domain mapping** with country code, currency, and marketplace information
- **URL normalization** to canonical product URL format
- **URL sanitization** to remove tracking parameters
- **Affiliate link handling**:
  - Extract affiliate tags (`tag`, `AssociateTag`, `linkCode`)
  - Add/remove affiliate tags from URLs
  - Detect affiliate links
- **Short URL expansion** for amzn.to, amzn.eu, a.co with intelligent caching
- **Metadata extraction**:
  - Product titles from URLs
  - Price information from URL parameters
  - Product variants (size, color, style, etc.)
  - Seller information
- **URL builders**:
  - Build canonical product URLs
  - Build affiliate URLs
  - Build variant-specific URLs
  - Build shareable URLs
- **Batch processing** for efficient handling of multiple URLs
- **Intelligent caching system** with LRU eviction policy (default: 100 entries)
- **Cache management** utilities (clear, get size)
- **Comprehensive error handling** with custom exception classes:
  - `InvalidUrlException`
  - `UrlExpansionException`
  - `AsinExtractionException`
  - `InvalidAsinException`
  - `UnsupportedDomainException`
  - `NetworkException`
  - `MetadataExtractionException`
  - `ApiException`
- **Validation utilities**:
  - URL validation
  - ASIN format validation
  - Domain validation
- **Flutter widgets**:
  - `AmazonProductPreview`: Product link preview widget
  - `AmazonProductCard`: Rich product card component
- **Optional Amazon Product Advertising API integration** (placeholder for future implementation)
- **Comprehensive test suite** covering all core functionalities
- **Detailed README** with usage examples and complete API reference
- **Example Flutter app** demonstrating package usage

### Changed

- N/A

### Deprecated

- N/A

### Removed

- N/A

### Fixed

- N/A

### Security

- Input validation to prevent potential security issues
- URL sanitization to remove tracking and analytics parameters
