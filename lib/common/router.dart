import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/login/login_page.dart';
import '../presentation/pages/main/main_page.dart';
import '../presentation/pages/product_detail/product_detail_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Login route
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const LoginPage()),
    ),

    // Main app route with nested routes
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const MainPage()),
    ),

    // Products route
    GoRoute(
      path: '/products',
      name: 'products',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const MainPage()),
    ),

    // Favorites route
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const MainPage()),
    ),

    // Cart route
    GoRoute(
      path: '/cart',
      name: 'cart',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const MainPage()),
    ),

    // Orders route
    GoRoute(
      path: '/orders',
      name: 'orders',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const MainPage()),
    ),

    // More route
    GoRoute(
      path: '/more',
      name: 'more',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const MainPage()),
    ),

    // Product detail route - no transition
    GoRoute(
      path: '/product/:id',
      name: 'product-detail',
      pageBuilder: (context, state) {
        final productId = state.pathParameters['id']!;
        return NoTransitionPage(child: ProductDetailPage(productId: productId));
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'The page you are looking for does not exist.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);

// Custom page with no transition
class NoTransitionPage extends CustomTransitionPage<void> {
  NoTransitionPage({required Widget child})
    : super(
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      );
}
