// Main export file for amazon_url_extractor package

// Core extractor
export 'src/extractor.dart';

// Models
export 'src/models/entities.dart';
export 'src/models/results.dart';
export 'src/models/errors.dart';

// Parsing
export 'src/parsing/url_patterns.dart';
export 'src/parsing/asin_extractor.dart';
export 'src/parsing/normalizer.dart';
export 'src/parsing/short_url_expander.dart';

// Domains
export 'src/domains/supported_domains.dart';
export 'src/domains/domain_mapper.dart';

// Affiliate
export 'src/affiliate/affiliate_handler.dart';

// Metadata
export 'src/metadata/metadata_extractor.dart';

// Utilities
export 'src/utils/sanitize.dart';
export 'src/utils/validators.dart';
export 'src/utils/builders.dart';

// Cache
export 'src/cache/cache_manager.dart';

// Flutter widgets
export 'src/flutter/product_preview.dart';
export 'src/flutter/product_card.dart';

// API (optional)
export 'src/api/amazon_pa_api.dart';
