import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/colors.dart';
import '../../common/navigation_service.dart';
import '../pages/main/controllers/main_cubit.dart';

class TopNavigation extends StatelessWidget {
  const TopNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: kSurfaceColor,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildLogoSection(context),
                const SizedBox(width: 24),
                Expanded(child: _buildNavigationItems(context, state)),
                _buildUserActions(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'Electronics Store',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationItems(BuildContext context, MainState state) {
    final navigationItems = [
      {'icon': Icons.dashboard_outlined, 'label': 'Dashboard', 'index': 0},
      {'icon': Icons.category_outlined, 'label': 'Products', 'index': 1},
      {'icon': Icons.favorite_outline, 'label': 'Favorites', 'index': 2},
      {'icon': Icons.shopping_cart_outlined, 'label': 'Cart', 'index': 3},
      {'icon': Icons.history, 'label': 'Orders', 'index': 4},
      {'icon': Icons.more_horiz, 'label': 'More', 'index': 5},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: navigationItems.map((item) {
          final isSelected =
              state.selectedNavigationIndex == item['index'] as int;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => context.read<MainCubit>().navigateToRoute(
                item['index'] as int,
                context,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? kPrimaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: kPrimaryColor, width: 1)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color: isSelected ? kPrimaryColor : kTextSecondaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['label'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? kPrimaryColor : kTextPrimaryColor,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUserActions(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        IconButton(icon: const Icon(Icons.support_agent), onPressed: () {}),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: PopupMenuButton<String>(
            child: CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: kErrorColor),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: kErrorColor)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'login',
                child: Row(
                  children: [
                    Icon(Icons.login, color: kPrimaryColor),
                    SizedBox(width: 8),
                    Text('Login', style: TextStyle(color: kPrimaryColor)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'login':
                  NavigationService.goToLogin(context);
                  break;
              }
            },
          ),
        ),
      ],
    );
  }
}
