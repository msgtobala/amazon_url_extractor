import 'dart:collection';

/// LRU Cache manager for storing expanded URLs and extracted data
class CacheManager {
  final LinkedHashMap<String, String> _cache;
  final int maxSize;

  CacheManager({this.maxSize = 100}) : _cache = LinkedHashMap();

  /// Get value from cache
  String? get(String key) {
    if (!_cache.containsKey(key)) {
      return null;
    }

    // Move to end (most recently used)
    final value = _cache.remove(key);
    _cache[key] = value!;
    return value;
  }

  /// Put value in cache
  void put(String key, String value) {
    if (_cache.containsKey(key)) {
      // Update existing
      _cache.remove(key);
    } else if (_cache.length >= maxSize) {
      // Remove least recently used (first item)
      _cache.remove(_cache.keys.first);
    }

    _cache[key] = value;
  }

  /// Check if key exists in cache
  bool containsKey(String key) {
    return _cache.containsKey(key);
  }

  /// Clear cache
  void clear() {
    _cache.clear();
  }

  /// Get cache size
  int get size => _cache.length;

  /// Remove specific key
  void remove(String key) {
    _cache.remove(key);
  }
}

/// Global cache instance for URL expansion
class UrlExpansionCache {
  static final CacheManager _instance = CacheManager(maxSize: 100);

  static CacheManager get instance => _instance;

  static String? get(String key) => _instance.get(key);

  static void put(String key, String value) => _instance.put(key, value);

  static bool containsKey(String key) => _instance.containsKey(key);

  static void clear() => _instance.clear();

  static int get size => _instance.size;
}
