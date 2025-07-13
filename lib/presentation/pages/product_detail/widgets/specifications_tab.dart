import 'package:flutter/material.dart';

import '../../../../common/colors.dart';
import '../../../../domain/entities/product_entity.dart';

class SpecificationsTab extends StatelessWidget {
  final ProductEntity product;

  const SpecificationsTab({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final specifications = product.specifications;

    if (specifications.isEmpty) {
      return const Center(child: Text('No specifications available'));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Specifications',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
          ),
          const SizedBox(height: 24),
          ...specifications.entries.map(
            (entry) => _buildSpecificationItem(context, entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationItem(
    BuildContext context,
    String key,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kTextPrimaryColor,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kTextSecondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
