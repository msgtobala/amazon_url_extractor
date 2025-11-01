/// Custom exceptions for Amazon URL extraction
class AmazonUrlExtractorException implements Exception {
  final String message;
  AmazonUrlExtractorException(this.message);

  @override
  String toString() => message;
}

/// Thrown when an invalid URL is provided
class InvalidUrlException extends AmazonUrlExtractorException {
  InvalidUrlException(super.message);
}

/// Thrown when URL expansion fails
class UrlExpansionException extends AmazonUrlExtractorException {
  UrlExpansionException(super.message);
}

/// Thrown when ASIN extraction fails
class AsinExtractionException extends AmazonUrlExtractorException {
  AsinExtractionException(super.message);
}

/// Thrown when an invalid ASIN is provided
class InvalidAsinException extends AmazonUrlExtractorException {
  InvalidAsinException(super.message);
}

/// Thrown when network operations fail
class NetworkException extends AmazonUrlExtractorException {
  NetworkException(super.message);
}

/// Thrown when domain is not supported
class UnsupportedDomainException extends AmazonUrlExtractorException {
  UnsupportedDomainException(super.message);
}

/// Thrown when metadata extraction fails
class MetadataExtractionException extends AmazonUrlExtractorException {
  MetadataExtractionException(super.message);
}

/// Thrown when API operations fail
class ApiException extends AmazonUrlExtractorException {
  final int? statusCode;
  ApiException(super.message, [this.statusCode]);
}
