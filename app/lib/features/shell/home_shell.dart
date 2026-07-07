import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhome_app/core/theme/tokens.dart';
import 'package:foodhome_app/features/household/presentation/controllers/household_controller.dart';
import 'package:foodhome_app/features/kitchen/presentation/pages/kitchen_page.dart';
import 'package:foodhome_app/features/menu/presentation/pages/menu_page.dart';
import 'package:foodhome_app/features/settings/presentation/pages/settings_page.dart';
import 'package:foodhome_app/features/today/presentation/pages/today_order_page.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  var _selectedIndex = 0;

  static const List<Widget> _pages = [
    TodayOrderPage(),
    KitchenPage(),
    MenuPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(householdControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: SvgPicture.asset('assets/branding/logo-concept-mini.svg'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FoodHome'),
            Text(
              '${state.householdName} · 今日主厨 ${state.todayCookName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: '今晚',
          ),
          NavigationDestination(
            icon: Icon(Icons.soup_kitchen_outlined),
            selectedIcon: Icon(Icons.soup_kitchen),
            label: '厨房',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: '菜单',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
