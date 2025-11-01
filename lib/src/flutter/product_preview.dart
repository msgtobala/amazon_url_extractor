import 'package:flutter/material.dart';
import '../models/results.dart';

/// Widget for displaying Amazon product link preview
class AmazonProductPreview extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final PriceInfo? price;
  final AvailabilityInfo? availability;
  final VoidCallback? onTap;
  final String? asin;

  const AmazonProductPreview({
    super.key,
    this.imageUrl,
    this.title,
    this.price,
    this.availability,
    this.onTap,
    this.asin,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  imageUrl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              )
            else
              Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade200,
                child: const Icon(Icons.shopping_bag),
              ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (title != null) const SizedBox(height: 8),
                  if (price != null && price!.formattedPrice != null)
                    Text(
                      price!.formattedPrice!,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  if (availability != null) ...[
                    const SizedBox(height: 4),
                    _buildAvailabilityChip(availability!),
                  ],
                  if (asin != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'ASIN: $asin',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
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
            const SizedBox(width: 2),
            Text(
              'Prime',
              style: TextStyle(color: color, fontSize: 10),
            ),
          ],
        ],
      ),
    );
  }
}

