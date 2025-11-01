import 'results.dart';

/// Represents an extracted Amazon product reference
class ProductRef {
  final String asin;
  final String? variantId;
  final Map<String, String>? variantParams;
  final String? sellerId;

  ProductRef({
    required this.asin,
    this.variantId,
    this.variantParams,
    this.sellerId,
  });

  bool get hasVariants => variantParams != null && variantParams!.isNotEmpty;
}

/// Represents an extracted entity from Amazon URL
class ExtractedEntity {
  final UrlType type;
  final ProductRef? product;
  final String? wishlistId;
  final String? searchQuery;
  final String? storeId;
  final String? reviewId;

  const ExtractedEntity._({
    required this.type,
    this.product,
    this.wishlistId,
    this.searchQuery,
    this.storeId,
    this.reviewId,
  });

  factory ExtractedEntity.product(ProductRef product) {
    return ExtractedEntity._(
      type: UrlType.product,
      product: product,
    );
  }

  factory ExtractedEntity.wishlist(String wishlistId) {
    return ExtractedEntity._(
      type: UrlType.wishlist,
      wishlistId: wishlistId,
    );
  }

  factory ExtractedEntity.search(String query) {
    return ExtractedEntity._(
      type: UrlType.search,
      searchQuery: query,
    );
  }

  factory ExtractedEntity.store(String storeId) {
    return ExtractedEntity._(
      type: UrlType.store,
      storeId: storeId,
    );
  }

  factory ExtractedEntity.review(String reviewId) {
    return ExtractedEntity._(
      type: UrlType.review,
      reviewId: reviewId,
    );
  }

  factory ExtractedEntity.unknown() {
    return const ExtractedEntity._(type: UrlType.unknown);
  }
}
