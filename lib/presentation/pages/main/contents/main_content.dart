import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../../../../common/navigation_service.dart';
import '../../cart/cart_page.dart';
import '../../dashboard/contents/dashboard_content.dart';
import '../../favorites/favorites_page.dart';
import '../../orders/orders_page.dart';
import '../../products/products_page.dart';
import '../controllers/main_cubit.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Get current route to determine which content to show
          final currentRoute = NavigationService.getCurrentRoute(context);

          // // Map routes to navigation indices
          final routeToIndex = {
            '/': 0,
            '/dashboard': 0,
            '/products': 1,
            '/favorites': 2,
            '/cart': 3,
            '/orders': 4,
            '/more': 5,
          };

          final currentIndex = routeToIndex[currentRoute] ?? 0;

          // // Update the cubit state if it doesn't match the current route
          if (state.selectedNavigationIndex != currentIndex) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<MainCubit>().setSelectedNavigationIndex(
                currentIndex,
              );
            });
          }
        });
        // Switch content based on current route
        switch (state.selectedNavigationIndex) {
          case 0: // Dashboard
            return const DashboardContent();
          case 1: // Products
            return const ProductsPage();
          case 2: // Favorites
            return const FavoritesPage();
          case 3: // Cart
            return const CartPage();
          case 4: // Orders
            return const OrdersPage();
          case 5: // More
            return _buildMoreContent(context, state);
          default:
            return const DashboardContent();
        }
      },
    );
  }

  // Helper methods for navigation content
  Widget _buildMoreContent(BuildContext context, MainState state) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Options',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: kTextPrimaryColor,
          ),
        ),
        const SizedBox(height: 24),
        // Use grid layout for large screens, list for small screens
        size.width > 800
            ? GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildMoreOptionCard(
                    context,
                    icon: Icons.person_outline,
                    title: 'Profile',
                    onTap: () {
                      // Navigate to profile
                    },
                  ),
                  _buildMoreOptionCard(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      // Navigate to settings
                    },
                  ),
                  _buildMoreOptionCard(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      // Navigate to help
                    },
                  ),
                  _buildMoreOptionCard(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      // Navigate to about
                    },
                  ),
                  _buildMoreOptionCard(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      // Navigate to notifications
                    },
                  ),
                  _buildMoreOptionCard(
                    context,
                    icon: Icons.security_outlined,
                    title: 'Privacy',
                    onTap: () {
                      // Navigate to privacy
                    },
                  ),
                ],
              )
            : Column(
                children: [
                  _buildMoreOption(
                    context,
                    icon: Icons.person_outline,
                    title: 'Profile',
                    subtitle: 'Manage your account settings',
                    onTap: () {
                      // Navigate to profile
                    },
                  ),
                  _buildMoreOption(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'App preferences and configuration',
                    onTap: () {
                      // Navigate to settings
                    },
                  ),
                  _buildMoreOption(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () {
                      // Navigate to help
                    },
                  ),
                  _buildMoreOption(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and information',
                    onTap: () {
                      // Navigate to about
                    },
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildMoreOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: kPrimaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: kTextPrimaryColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kTextSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: kTextSecondaryColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: kPrimaryColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: kTextPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
