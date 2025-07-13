import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/colors.dart';
import '../../common/navigation_service.dart';
import '../pages/main/controllers/main_cubit.dart';

class TopNavigation extends StatefulWidget {
  const TopNavigation({super.key});

  @override
  State<TopNavigation> createState() => _TopNavigationState();
}

class _TopNavigationState extends State<TopNavigation> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _profileKey = GlobalKey();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showUserMenu() {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    _overlayEntry = OverlayEntry(builder: (context) => _buildOverlayMenu());

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildOverlayMenu() {
    final renderBox =
        _profileKey.currentContext?.findRenderObject() as RenderBox?;
    final buttonPosition = renderBox?.localToGlobal(Offset.zero);
    final buttonSize = renderBox?.size;

    final screenWidth = MediaQuery.of(context).size.width;

    const popupWidth = 200.0;

    double dx = buttonPosition?.dx ?? 0;
    double dy = (buttonPosition?.dy ?? 0) + (buttonSize?.height ?? 0);

    if (dx + popupWidth > screenWidth) {
      dx = screenWidth - popupWidth - 8;
    }
    if (dx < 0) dx = 8;

    return Positioned(
      width: popupWidth,
      left: dx,
      top: dy,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () {
                  _removeOverlay();
                  // Handle profile action
                },
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () {
                  _removeOverlay();
                  // Handle settings action
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                icon: Icons.logout,
                label: 'Logout',
                onTap: () {
                  _removeOverlay();
                  // Handle logout action
                },
                textColor: kErrorColor,
                iconColor: kErrorColor,
              ),
              _buildMenuItem(
                icon: Icons.login,
                label: 'Login',
                onTap: () {
                  _removeOverlay();
                  NavigationService.goToLogin(context);
                },
                textColor: kPrimaryColor,
                iconColor: kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? kTextSecondaryColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor ?? kTextPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          key: _profileKey,
          margin: const EdgeInsets.only(left: 8),
          child: InkWell(
            onTap: _showUserMenu,
            child: CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
