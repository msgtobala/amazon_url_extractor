import '../models/results.dart';
import 'supported_domains.dart';

/// Maps Amazon domains to country/currency/marketplace information
class DomainMapper {
  /// Get domain information from URL or domain string
  static AmazonDomain? getDomainInfo(String urlOrDomain) {
    String? domain = SupportedDomains.extractDomain(urlOrDomain);
    domain ??= SupportedDomains.normalizeDomain(urlOrDomain);

    if (!SupportedDomains.isSupported(domain)) {
      return null;
    }

    final mapping = SupportedDomains.domainMappings[domain];
    if (mapping == null) {
      return null;
    }

    return AmazonDomain(
      domain: domain,
      countryCode: mapping['countryCode']!,
      currency: mapping['currency']!,
      marketplace: mapping['marketplace']!,
    );
  }

  /// Get country code from domain
  static String? getCountryCode(String urlOrDomain) {
    return getDomainInfo(urlOrDomain)?.countryCode;
  }

  /// Get currency from domain
  static String? getCurrency(String urlOrDomain) {
    return getDomainInfo(urlOrDomain)?.currency;
  }

  /// Get marketplace ID from domain
  static String? getMarketplace(String urlOrDomain) {
    return getDomainInfo(urlOrDomain)?.marketplace;
  }

  /// Check if domain is supported
  static bool isDomainSupported(String urlOrDomain) {
    final domain = SupportedDomains.extractDomain(urlOrDomain) ??
        SupportedDomains.normalizeDomain(urlOrDomain);
    return SupportedDomains.isSupported(domain);
  }
}
