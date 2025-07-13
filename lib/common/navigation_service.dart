import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static void goToHome(BuildContext context) {
    context.replace('/');
  }

  static void goToLogin(BuildContext context) {
    context.replace('/login');
  }

  static void goToDashboard(BuildContext context) {
    context.replace('/');
  }

  static void goToProducts(BuildContext context) {
    context.replace('/products');
  }

  static void goToFavorites(BuildContext context) {
    context.replace('/favorites');
  }

  static void goToCart(BuildContext context) {
    context.replace('/cart');
  }

  static void goToOrders(BuildContext context) {
    context.replace('/orders');
  }

  static void goToMore(BuildContext context) {
    context.replace('/more');
  }

  static void goToProductDetail(BuildContext context, String productId) {
    context.replace('/product/$productId');
  }

  static void goBack(BuildContext context) {
    context.pop();
  }

  static void goToRoute(
    BuildContext context,
    String route, {
    bool isReplace = false,
  }) {
    if (isReplace) {
      context.replace(route);
    } else {
      context.go(route);
    }
  }

  static void pushRoute(BuildContext context, String route) {
    context.push(route);
  }

  // Helper method to get current route
  static String getCurrentRoute(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  // Helper method to check if current route matches
  static bool isCurrentRoute(BuildContext context, String route) {
    return getCurrentRoute(context) == route;
  }

  // Helper method to get route parameters
  static Map<String, String> getRouteParameters(BuildContext context) {
    return GoRouterState.of(context).pathParameters;
  }

  // Helper method to get query parameters
  static Map<String, String> getQueryParameters(BuildContext context) {
    return GoRouterState.of(context).uri.queryParameters;
  }
}
