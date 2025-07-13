import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/colors.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/top_navigation.dart';
import 'contents/product_detail_content.dart';
import 'controllers/product_detail_cubit.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductDetailCubit()..loadProduct(productId),
        ),
      ],
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: size.width >= 600
            ? const ProductDetailLargePage()
            : const ProductDetailSmallPage(),
      ),
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
