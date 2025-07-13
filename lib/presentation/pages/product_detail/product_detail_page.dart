import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/colors.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/top_navigation.dart';
import 'contents/product_detail_content.dart';
import 'controllers/product_detail_cubit.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? _initializedProductId;

  @override
  void initState() {
    super.initState();
    // Initialize with current product ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productId = GoRouterState.of(context).pathParameters['id'];
      if (productId != null && productId != _initializedProductId) {
        _initializedProductId = productId;
        context.read<ProductDetailCubit>().initialize(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          body: constraints.maxWidth >= 600
              ? const ProductDetailLargePage()
              : const ProductDetailSmallPage(),
        );
      },
    );
  }
}

class ProductDetailLargePage extends StatelessWidget {
  const ProductDetailLargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopNavigation(),
          Expanded(
            child: Container(
              color: kBackgroundColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: const ProductDetailContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailSmallPage extends StatelessWidget {
  const ProductDetailSmallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const ProductDetailContent(),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text('Product Details'),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            // Toggle favorite
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // Share product
          },
        ),
      ],
    );
  }
}
