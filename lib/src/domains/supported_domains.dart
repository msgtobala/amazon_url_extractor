/// Supported Amazon domains and their mappings
class SupportedDomains {
  static const Map<String, Map<String, String>> domainMappings = {
    'amazon.com': {
      'countryCode': 'US',
      'currency': 'USD',
      'marketplace': 'ATVPDKIKX0DER',
    },
    'amazon.co.uk': {
      'countryCode': 'GB',
      'currency': 'GBP',
      'marketplace': 'A1F83G8C2ARO7P',
    },
    'amazon.ca': {
      'countryCode': 'CA',
      'currency': 'CAD',
      'marketplace': 'A2EUQ1WTGCTBG2',
    },
    'amazon.de': {
      'countryCode': 'DE',
      'currency': 'EUR',
      'marketplace': 'A1PA6795UKMFR9',
    },
    'amazon.fr': {
      'countryCode': 'FR',
      'currency': 'EUR',
      'marketplace': 'A13V1IB3VIYZZH',
    },
    'amazon.it': {
      'countryCode': 'IT',
      'currency': 'EUR',
      'marketplace': 'APJ6JRA9NG5V4',
    },
    'amazon.es': {
      'countryCode': 'ES',
      'currency': 'EUR',
      'marketplace': 'A1RKKUPIHCS9HS',
    },
    'amazon.in': {
      'countryCode': 'IN',
      'currency': 'INR',
      'marketplace': 'A21TJRUUN4KGV',
    },
    'amazon.co.jp': {
      'countryCode': 'JP',
      'currency': 'JPY',
      'marketplace': 'A1VC38T7YXB528',
    },
    'amazon.com.au': {
      'countryCode': 'AU',
      'currency': 'AUD',
      'marketplace': 'A39IBJ37TRX1C6',
    },
    'amazon.com.mx': {
      'countryCode': 'MX',
      'currency': 'MXN',
      'marketplace': 'A1AM78C64UM0Y8',
    },
    'amazon.com.br': {
      'countryCode': 'BR',
      'currency': 'BRL',
      'marketplace': 'A2Q3Y263D00KWC',
    },
    'amazon.nl': {
      'countryCode': 'NL',
      'currency': 'EUR',
      'marketplace': 'A1805IZSGTT6HS',
    },
    'amazon.se': {
      'countryCode': 'SE',
      'currency': 'SEK',
      'marketplace': 'A2NODRKZP88JJ9',
    },
    'amazon.pl': {
      'countryCode': 'PL',
      'currency': 'PLN',
      'marketplace': 'A1C3GMZRYGI4ZX',
    },
    'amazon.sg': {
      'countryCode': 'SG',
      'currency': 'SGD',
      'marketplace': 'A19VAU5U5O7RUS',
    },
    'amazon.ae': {
      'countryCode': 'AE',
      'currency': 'AED',
      'marketplace': 'A2VIGQ35RCS4UG',
    },
    'amazon.sa': {
      'countryCode': 'SA',
      'currency': 'SAR',
      'marketplace': 'A17E79C6D8DWNP',
    },
    'amazon.tr': {
      'countryCode': 'TR',
      'currency': 'TRY',
      'marketplace': 'A33AVAJ2PDY3EV',
    },
    'amazon.eg': {
      'countryCode': 'EG',
      'currency': 'EGP',
      'marketplace': 'ARB9HQDOCPFYN',
    },
  };

  /// Get all supported domain strings
  static List<String> get allDomains => domainMappings.keys.toList();

  /// Check if a domain is supported
  static bool isSupported(String domain) {
    final normalized = normalizeDomain(domain);
    return domainMappings.containsKey(normalized);
  }

  /// Normalize domain (remove www, protocol, etc.)
  static String normalizeDomain(String domain) {
    domain = domain.toLowerCase().trim();
    // Remove protocol
    domain = domain.replaceAll(RegExp(r'^https?://'), '');
    // Remove www
    domain = domain.replaceAll(RegExp(r'^www\.'), '');
    // Remove path
    domain = domain.split('/').first;
    // Remove port
    domain = domain.split(':').first;
    return domain;
  }

  /// Extract domain from URL
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return normalizeDomain(uri.host);
    } catch (_) {
      return null;
    }
  }
}

