import 'package:flutter/material.dart';
import '../models/results.dart';

/// Rich product card widget for Amazon products
class AmazonProductCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final PriceInfo? price;
  final AvailabilityInfo? availability;
  final ReviewInfo? reviewInfo;
  final VoidCallback? onTap;
  final String? asin;
  final Widget? trailing;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;

  const AmazonProductCard({
    super.key,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.price,
    this.availability,
    this.reviewInfo,
    this.onTap,
    this.asin,
    this.trailing,
    this.padding,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: padding ?? const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: decoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and Title Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.shopping_bag),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.shopping_bag, size: 48),
                    ),
                  const SizedBox(width: 16),
                  // Title and Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                        if (reviewInfo != null) ...[
                          const SizedBox(height: 8),
                          _buildRating(reviewInfo!),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 12),
              // Price and Availability
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (price != null && price!.formattedPrice != null)
                    Text(
                      price!.formattedPrice!,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  else
                    const SizedBox(),
                  if (availability != null)
                    _buildAvailabilityChip(availability!),
                ],
              ),
              if (asin != null) ...[
                const SizedBox(height: 8),
                Text(
                  'ASIN: $asin',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRating(ReviewInfo reviewInfo) {
    if (reviewInfo.averageRating == null && reviewInfo.totalReviews == null) {
      return const SizedBox();
    }

    return Row(
      children: [
        if (reviewInfo.averageRating != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final rating = reviewInfo.averageRating!;
              return Icon(
                index < rating.floor()
                    ? Icons.star
                    : (index < rating ? Icons.star_half : Icons.star_border),
                size: 16,
                color: Colors.amber,
              );
            }),
          ),
          const SizedBox(width: 4),
          Text(
            reviewInfo.averageRating!.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12),
          ),
        ],
        if (reviewInfo.totalReviews != null) ...[
          if (reviewInfo.averageRating != null) const SizedBox(width: 4),
          Text(
            '(${reviewInfo.totalReviews})',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildAvailabilityChip(AvailabilityInfo availability) {
    Color color;
    String text;

    switch (availability.status) {
      case AvailabilityStatus.inStock:
        color = Colors.green;
        text = 'In Stock';
        break;
      case AvailabilityStatus.outOfStock:
        color = Colors.red;
        text = 'Out of Stock';
        break;
      case AvailabilityStatus.preOrder:
        color = Colors.orange;
        text = 'Pre-order';
        break;
      case AvailabilityStatus.availableSoon:
        color = Colors.blue;
        text = 'Available Soon';
        break;
      case AvailabilityStatus.limitedStock:
        color = Colors.orange;
        text = 'Limited Stock';
        break;
      default:
        color = Colors.grey;
        text = availability.message ?? 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 12),
          ),
          if (availability.isPrimeEligible) ...[
            const SizedBox(width: 4),
            Icon(Icons.local_shipping, size: 12, color: color),
          ],
        ],
      ),
    );
  }
}
