import 'package:flutter/material.dart';

import '../../../../common/colors.dart';
import '../../../../domain/entities/product_entity.dart';
import 'description_tab.dart';
import 'specifications_tab.dart';

class ProductDescription extends StatefulWidget {
  final ProductEntity product;

  const ProductDescription({super.key, required this.product});

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _isExpanded = false;
  final double _collapsedHeight = 200.0;
  double? _expandedDescriptionHeight;
  double? _expandedSpecificationsHeight;
  bool _showDescriptionExpandToggle = false;
  bool _showSpecificationsExpandToggle = false;
  int _selectedTabIndex = 0; // 0 for description, 1 for specifications
  final GlobalKey _descriptionKey = GlobalKey();
  final GlobalKey _specificationsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _checkIfWidgetOverflows(),
    );
  }

  void _checkIfWidgetOverflows() {
    final descriptionRenderBox =
        _descriptionKey.currentContext?.findRenderObject() as RenderBox?;
    final specificationsRenderBox =
        _specificationsKey.currentContext?.findRenderObject() as RenderBox?;
    if (descriptionRenderBox != null &&
        (_expandedDescriptionHeight ?? 0) < _collapsedHeight) {
      final fullHeight = descriptionRenderBox.size.height;
      setState(() {
        _showDescriptionExpandToggle = fullHeight > _collapsedHeight;
        _expandedDescriptionHeight = fullHeight;
      });
    }
    if (specificationsRenderBox != null &&
        (_expandedSpecificationsHeight ?? 0) < _collapsedHeight) {
      final fullHeight = specificationsRenderBox.size.height;
      setState(() {
        _showSpecificationsExpandToggle = fullHeight > _collapsedHeight;
        _expandedSpecificationsHeight = fullHeight;
      });
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
      // _isExpanded = false;
    });
    // Recalculate height when tab changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfWidgetOverflows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                _buildTabButton(
                  context,
                  index: 0,
                  icon: Icons.description_outlined,
                  label: 'Description',
                ),
                _buildTabButton(
                  context,
                  index: 1,
                  icon: Icons.info_outline,
                  label: 'Specifications',
                ),
              ],
            ),
          ),
          // Tab Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isExpanded
                ? (_selectedTabIndex == 0
                        ? _expandedDescriptionHeight
                        : _expandedSpecificationsHeight) ??
                    300
                : _collapsedHeight,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: double.infinity,
                child: _selectedTabIndex == 0
                    ? _buildDescriptionTab(context)
                    : _buildSpecificationsTab(context),
              ),
            ),
          ),
          // Expand/Collapse Toggle
          if ((_selectedTabIndex == 0 && _showDescriptionExpandToggle) ||
              (_selectedTabIndex == 1 && _showSpecificationsExpandToggle))
            _buildExpandToggle(context),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? kPrimaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? kPrimaryColor : kTextSecondaryColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? kPrimaryColor : kTextSecondaryColor,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandToggle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isExpanded ? 'Show Less' : 'Show More',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: kPrimaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionTab(BuildContext context) {
    return DescriptionTab(key: _descriptionKey, product: widget.product);
  }

  Widget _buildSpecificationsTab(BuildContext context) {
    return SpecificationsTab(key: _specificationsKey, product: widget.product);
  }
}
