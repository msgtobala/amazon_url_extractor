/// Result wrapper for parse/extraction operations
class ParseResult<T> {
  final T? value;
  final bool isSuccess;
  final String? errorMessage;

  const ParseResult._({
    required this.value,
    required this.isSuccess,
    this.errorMessage,
  });

  factory ParseResult.ok(T value) {
    return ParseResult._(value: value, isSuccess: true);
  }

  factory ParseResult.fail(String message) {
    return ParseResult._(
      value: null,
      isSuccess: false,
      errorMessage: message,
    );
  }
}

/// Extraction result containing all product information
class ExtractionResult {
  final String? asin;
  final String? title;
  final PriceInfo? price;
  final AvailabilityInfo? availability;
  final ProductMetadata? metadata;
  final AffiliateInfo? affiliateInfo;
  final String? canonicalUrl;
  final AmazonDomain domain;
  final UrlType urlType;
  final Map<String, dynamic> additionalData;

  ExtractionResult({
    this.asin,
    this.title,
    this.price,
    this.availability,
    this.metadata,
    this.affiliateInfo,
    this.canonicalUrl,
    required this.domain,
    required this.urlType,
    Map<String, dynamic>? additionalData,
  }) : additionalData = additionalData ?? {};

  bool get hasValidAsin => asin != null && _isValidAsin(asin!);

  static bool _isValidAsin(String asin) {
    return asin.length == 10 && RegExp(r'^[A-Z0-9]{10}$').hasMatch(asin);
  }
}

/// Price information
class PriceInfo {
  final double? amount;
  final String? currency;
  final String? formattedPrice;
  final PriceType? type;

  PriceInfo({
    this.amount,
    this.currency,
    this.formattedPrice,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        'formattedPrice': formattedPrice,
        'type': type?.toString(),
      };
}

enum PriceType {
  regular,
  sale,
  range,
  unavailable,
}

/// Availability information
class AvailabilityInfo {
  final AvailabilityStatus status;
  final String? message;
  final bool isPrimeEligible;
  final String? fulfillmentMethod; // FBA, FBM, etc.

  AvailabilityInfo({
    required this.status,
    this.message,
    this.isPrimeEligible = false,
    this.fulfillmentMethod,
  });

  Map<String, dynamic> toJson() => {
        'status': status.toString(),
        'message': message,
        'isPrimeEligible': isPrimeEligible,
        'fulfillmentMethod': fulfillmentMethod,
      };
}

enum AvailabilityStatus {
  inStock,
  outOfStock,
  preOrder,
  availableSoon,
  limitedStock,
  unknown,
}

/// Product metadata
class ProductMetadata {
  final String? brand;
  final String? modelNumber;
  final String? category;
  final List<String>? categories;
  final Map<String, String>? variants; // size, color, etc.
  final String? productType;
  final SellerInfo? sellerInfo;
  final ReviewInfo? reviewInfo;

  ProductMetadata({
    this.brand,
    this.modelNumber,
    this.category,
    this.categories,
    this.variants,
    this.productType,
    this.sellerInfo,
    this.reviewInfo,
  });

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'modelNumber': modelNumber,
        'category': category,
        'categories': categories,
        'variants': variants,
        'productType': productType,
        'sellerInfo': sellerInfo?.toJson(),
        'reviewInfo': reviewInfo?.toJson(),
      };
}

/// Seller information
class SellerInfo {
  final String? sellerId;
  final String? sellerName;
  final String? marketplace;
  final String? fulfillmentMethod;

  SellerInfo({
    this.sellerId,
    this.sellerName,
    this.marketplace,
    this.fulfillmentMethod,
  });

  Map<String, dynamic> toJson() => {
        'sellerId': sellerId,
        'sellerName': sellerName,
        'marketplace': marketplace,
        'fulfillmentMethod': fulfillmentMethod,
      };
}

/// Review information
class ReviewInfo {
  final double? averageRating;
  final int? totalReviews;
  final String? reviewPageUrl;

  ReviewInfo({
    this.averageRating,
    this.totalReviews,
    this.reviewPageUrl,
  });

  Map<String, dynamic> toJson() => {
        'averageRating': averageRating,
        'totalReviews': totalReviews,
        'reviewPageUrl': reviewPageUrl,
      };
}

/// Affiliate information
class AffiliateInfo {
  final String? tag;
  final String? linkCode;
  final String? associateTag;

  AffiliateInfo({
    this.tag,
    this.linkCode,
    this.associateTag,
  });

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'linkCode': linkCode,
        'associateTag': associateTag,
      };

  bool get hasAffiliateTag => tag != null || linkCode != null || associateTag != null;
}

/// Amazon domain information
class AmazonDomain {
  final String domain;
  final String countryCode;
  final String currency;
  final String marketplace;

  const AmazonDomain({
    required this.domain,
    required this.countryCode,
    required this.currency,
    required this.marketplace,
  });

  String get baseUrl => 'https://$domain';
}

/// URL type enumeration
enum UrlType {
  product,
  wishlist,
  search,
  store,
  review,
  cart,
  unknown,
}

