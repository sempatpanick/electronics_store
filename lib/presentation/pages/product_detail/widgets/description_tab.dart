import 'package:flutter/material.dart';

import '../../../../common/colors.dart';
import '../../../../domain/entities/product_entity.dart';

class DescriptionTab extends StatelessWidget {
  final ProductEntity product;

  const DescriptionTab({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Description',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: kTextPrimaryColor,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 24),

          // Key Features
          Text(
            'Key Features',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
          ),
          const SizedBox(height: 16),
          _buildFeatureList(context),
        ],
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    final features = _getKeyFeatures();

    return Column(
      children: features
          .map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kTextPrimaryColor,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  List<String> _getKeyFeatures() {
    // Generate key features based on product category
    final category = product.category;

    switch (category.toLowerCase()) {
      case 'smartphones':
        return [
          'Advanced camera system with professional photography capabilities',
          'Powerful processor for smooth performance and multitasking',
          'All-day battery life with fast charging technology',
          'Premium design with durable materials',
          'Latest operating system with regular updates',
          '5G connectivity for ultra-fast internet speeds',
        ];
      case 'laptops':
        return [
          'High-performance processor for demanding tasks',
          'Stunning display with accurate color reproduction',
          'Long battery life for productivity on the go',
          'Fast storage for quick boot times and file access',
          'Multiple connectivity options for versatile use',
          'Premium build quality with reliable components',
        ];
      case 'audio':
        return [
          'High-quality sound with advanced audio processing',
          'Active noise cancellation for immersive listening',
          'Long battery life for extended use',
          'Comfortable design for extended wear',
          'Wireless connectivity with stable connection',
          'Durable construction for long-term reliability',
        ];
      default:
        return [
          'Premium quality materials and construction',
          'Advanced technology and features',
          'Reliable performance and durability',
          'User-friendly design and interface',
          'Comprehensive warranty and support',
          'Excellent value for money',
        ];
    }
  }
}
