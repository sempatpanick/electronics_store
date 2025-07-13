import 'package:flutter/material.dart';

import '../../../../common/colors.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;

  const ProductImageGallery({super.key, required this.images});

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Image with Zoom
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return _buildImageWidget(widget.images[index]);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Thumbnail Images
        if (widget.images.length > 1)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _currentIndex == index
                            ? kPrimaryColor
                            : Colors.grey.shade300,
                        width: _currentIndex == index ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildImageWidget(
                        widget.images[index],
                        isSmall: true,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildImageWidget(String imageUrl, {bool isSmall = false}) {
    // For demo purposes, show placeholder images
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: kSecondaryColor.withValues(alpha: 0.1)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 48,
              color: kSecondaryColor.withValues(alpha: 0.5),
            ),
            if (!isSmall)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Product Image',
                    style: TextStyle(
                      color: kSecondaryColor.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap to zoom',
                    style: TextStyle(
                      fontSize: 12,
                      color: kSecondaryColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
