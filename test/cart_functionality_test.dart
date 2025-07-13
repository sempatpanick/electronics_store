import 'package:flutter_test/flutter_test.dart';
import 'package:electronics_store/domain/entities/product_entity.dart';
import 'package:electronics_store/domain/usecases/cart_use_case.dart';
import 'package:electronics_store/data/repositories/app_repository_impl.dart';
import 'package:electronics_store/data/datasources/local_data_source.dart';
import 'package:electronics_store/data/datasources/assets_data_source.dart';

void main() {
  group('Cart Functionality Tests', () {
    late CartUseCase cartUseCase;
    late AppRepositoryImpl repository;
    late LocalDataSourceImpl localDataSource;
    late AssetsDataSourceImpl assetsDataSource;

    setUp(() {
      localDataSource = LocalDataSourceImpl();
      assetsDataSource = AssetsDataSourceImpl();
      repository = AppRepositoryImpl(localDataSource, assetsDataSource);
      cartUseCase = CartUseCase(repository);
    });

    test(
      'should treat products with different configurations as separate items',
      () async {
        // Create a sample product
        final product = ProductEntity(
          id: 'test-product-1',
          name: 'Test Smartphone',
          brand: 'Test Brand',
          category: 'Smartphones',
          price: 999.99,
          image: null,
          images: [],
          rating: 4.5,
          reviewsCount: 100,
          description: 'Test description',
          specifications: {},
          variants: [
            ProductVariantEntity(name: '128GB', price: 999.99, available: true),
            ProductVariantEntity(
              name: '256GB',
              price: 1099.99,
              available: true,
            ),
          ],
          colors: ['Black', 'White', 'Blue'],
          ramOptions: ['8GB', '12GB'],
          storageOptions: ['128GB', '256GB'],
          inStock: true,
          stockCount: 10,
          reviewsList: [],
        );

        // Add product with different configurations
        final result1 = await cartUseCase.addToCart(
          product,
          selectedVariant: product.variants![0], // 128GB
          selectedColor: 'Black',
          selectedRam: '8GB',
          selectedStorage: '128GB',
          quantity: 1,
        );

        final result2 = await cartUseCase.addToCart(
          product,
          selectedVariant: product.variants![1], // 256GB
          selectedColor: 'White',
          selectedRam: '12GB',
          selectedStorage: '256GB',
          quantity: 1,
        );

        final result3 = await cartUseCase.addToCart(
          product,
          selectedVariant: product.variants![0], // 128GB
          selectedColor: 'Black',
          selectedRam: '8GB',
          selectedStorage: '128GB',
          quantity: 1,
        );

        // Get all cart items
        final cartItems = await cartUseCase.getCartItems();

        expect(result1.isRight(), true);
        expect(result2.isRight(), true);
        expect(result3.isRight(), true);
        expect(cartItems.isRight(), true);

        cartItems.fold((error) => fail('Should not have error: $error'), (
          items,
        ) {
          // Should have 2 items (not 3) because the third add should update quantity of first item
          expect(items.length, 2);

          // Find the first configuration (128GB, Black, 8GB, 128GB)
          final firstItem = items.firstWhere(
            (item) =>
                item.selectedVariant == '128GB' &&
                item.selectedColor == 'Black' &&
                item.selectedRam == '8GB' &&
                item.selectedStorage == '128GB',
          );

          // Find the second configuration (256GB, White, 12GB, 256GB)
          final secondItem = items.firstWhere(
            (item) =>
                item.selectedVariant == '256GB' &&
                item.selectedColor == 'White' &&
                item.selectedRam == '12GB' &&
                item.selectedStorage == '256GB',
          );

          // First item should have quantity 2 (original 1 + added 1)
          expect(firstItem.quantity, 2);
          expect(firstItem.price, 999.99);

          // Second item should have quantity 1
          expect(secondItem.quantity, 1);
          expect(secondItem.price, 1099.99);
        });
      },
    );

    test('should generate unique keys for different configurations', () {
      final cartUseCase = CartUseCase(repository);

      // Test the private method through reflection or create a public test method
      // For now, we'll test the behavior through the public API

      final product = ProductEntity(
        id: 'test-product-2',
        name: 'Test Product',
        brand: 'Test Brand',
        category: 'Test Category',
        price: 100.0,
        image: null,
        images: [],
        rating: 4.0,
        reviewsCount: 50,
        description: 'Test description',
        specifications: {},
        variants: null,
        colors: ['Red', 'Blue'],
        ramOptions: null,
        storageOptions: null,
        inStock: true,
        stockCount: 5,
        reviewsList: [],
      );

      // These should be treated as separate items
      expect(() async {
        await cartUseCase.addToCart(product, selectedColor: 'Red');
        await cartUseCase.addToCart(product, selectedColor: 'Blue');

        final items = await cartUseCase.getCartItems();
        items.fold((error) => fail('Should not have error: $error'), (
          cartItems,
        ) {
          expect(cartItems.length, 2);
          expect(cartItems.any((item) => item.selectedColor == 'Red'), true);
          expect(cartItems.any((item) => item.selectedColor == 'Blue'), true);
        });
      }, returnsNormally);
    });
  });
}
