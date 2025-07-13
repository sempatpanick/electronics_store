import 'package:flutter/material.dart';

import '../../../../common/colors.dart';
import '../../../../domain/entities/product_entity.dart';

class ProductReviews extends StatefulWidget {
  final List<ProductReviewEntity> reviews;

  const ProductReviews({super.key, required this.reviews});

  @override
  State<ProductReviews> createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  int _displayCount = 5;
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Star',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredReviews = _getFilteredReviews();
    final displayedReviews = filteredReviews.take(_displayCount).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Reviews',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kTextPrimaryColor,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.reviews.length} reviews',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kTextSecondaryColor,
                          ),
                    ),
                  ],
                ),
                if (widget.reviews.length > 5)
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to reviews detail page
                    },
                    icon: const Icon(Icons.rate_review),
                    label: const Text('View All'),
                    style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
                  ),
              ],
            ),
          ),

          // Filter
          if (widget.reviews.length > 5)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    'Filter by:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kTextPrimaryColor,
                        ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filterOptions
                            .map(
                              (filter) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(filter),
                                  selected: _selectedFilter == filter,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedFilter = filter;
                                      _displayCount = 5;
                                    });
                                  },
                                  backgroundColor: Colors.grey.shade100,
                                  selectedColor:
                                      kPrimaryColor.withValues(alpha: 0.1),
                                  labelStyle: TextStyle(
                                    color: _selectedFilter == filter
                                        ? kPrimaryColor
                                        : kTextPrimaryColor,
                                    fontWeight: _selectedFilter == filter
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  side: BorderSide(
                                    color: _selectedFilter == filter
                                        ? kPrimaryColor
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Reviews List
          if (displayedReviews.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reviews found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: displayedReviews
                  .map((review) => _buildReviewItem(context, review))
                  .toList(),
            ),

          // Load More Button
          if (filteredReviews.length > _displayCount)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _displayCount += 5;
                    });
                  },
                  icon: const Icon(Icons.expand_more),
                  label: Text(
                    'Show ${filteredReviews.length - _displayCount} more reviews',
                  ),
                  style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<ProductReviewEntity> _getFilteredReviews() {
    if (_selectedFilter == 'All') {
      return widget.reviews;
    }

    final rating = int.parse(_selectedFilter.split(' ')[0]);
    return widget.reviews.where((review) => review.rating == rating).toList();
  }

  Widget _buildReviewItem(BuildContext context, ProductReviewEntity review) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: kPrimaryColor.withValues(alpha: 0.1),
                child: Text(
                  review.user.isNotEmpty ? review.user[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: kTextPrimaryColor,
                          ),
                    ),
                    Text(
                      review.date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kTextSecondaryColor,
                          ),
                    ),
                  ],
                ),
              ),
              _buildRatingStars(review.rating),
            ],
          ),
          const SizedBox(height: 12),
          // Review Title
          if (review.title.isNotEmpty) ...[
            Text(
              review.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kTextPrimaryColor,
                  ),
            ),
            const SizedBox(height: 8),
          ],
          // Review Content
          Text(
            review.comment,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: kTextPrimaryColor,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }
}
