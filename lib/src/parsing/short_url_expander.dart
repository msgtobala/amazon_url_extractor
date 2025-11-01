import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/errors.dart';
import '../cache/cache_manager.dart';
import '../parsing/url_patterns.dart';

/// Expands shortened Amazon URLs (amzn.to, amzn.eu, etc.)
class ShortUrlExpander {
  /// Expand short URL with caching
  static Future<String> expandShortUrl(String shortUrl) async {
    // Check cache first
    if (UrlExpansionCache.containsKey(shortUrl)) {
      return UrlExpansionCache.get(shortUrl)!;
    }

    try {
      // Validate it's a short URL
      if (!AmazonUrlPatterns.shortUrlPattern.hasMatch(shortUrl)) {
        throw UrlExpansionException('Not a shortened Amazon URL: $shortUrl');
      }

      // Make HEAD request to get final URL
      final response = await http.head(Uri.parse(shortUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw UrlExpansionException('Request timeout');
        },
      );

      // Check for redirect location
      String? expandedUrl = response.headers['location'];
      if (expandedUrl == null) {
        // Try GET request as fallback
        final getResponse = await http.get(Uri.parse(shortUrl)).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw UrlExpansionException('Request timeout');
          },
        );

        if (getResponse.statusCode >= 300 && getResponse.statusCode < 400) {
          expandedUrl = getResponse.headers['location'];
        } else {
          // Check if URL in response body (for some redirects)
          final body = getResponse.body;
          final uriMatch = RegExp(r'https?://[^\s<>"]+').firstMatch(body);
          if (uriMatch != null) {
            expandedUrl = uriMatch.group(0);
          }
        }
      }

      if (expandedUrl == null) {
        throw UrlExpansionException(
          'Could not expand URL: ${response.statusCode}',
        );
      }

      // Handle relative URLs
      if (expandedUrl.startsWith('/')) {
        final uri = Uri.parse(shortUrl);
        expandedUrl = '${uri.scheme}://${uri.host}$expandedUrl';
      }

      // Cache the result
      UrlExpansionCache.put(shortUrl, expandedUrl);

      return expandedUrl;
    } on TimeoutException {
      throw UrlExpansionException('Request timeout while expanding URL');
    } catch (e) {
      if (e is UrlExpansionException) {
        rethrow;
      }
      throw NetworkException('Failed to expand URL: $e');
    }
  }

  /// Check if URL is a shortened URL
  static bool isShortUrl(String url) {
    return AmazonUrlPatterns.shortUrlPattern.hasMatch(url);
  }

  /// Expand multiple URLs in batch
  static Future<List<String?>> expandBatch(List<String> urls) async {
    final results = <String?>[];
    for (final url in urls) {
      try {
        final expanded = await expandShortUrl(url);
        results.add(expanded);
      } catch (_) {
        results.add(null);
      }
    }
    return results;
  }
}
