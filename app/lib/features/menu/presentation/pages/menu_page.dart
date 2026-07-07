import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodhome_app/core/demo/demo_household_controller.dart';
import 'package:foodhome_app/core/theme/tokens.dart';
import 'package:foodhome_app/shared/models/dish.dart';
import 'package:foodhome_app/shared/widgets/empty_state.dart';
import 'package:foodhome_app/shared/widgets/section_header.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(demoHouseholdControllerProvider);
    final favoriteCount = state.dishes.where((dish) => dish.isFavorite).length;
    final blockedCount = state.dishes
        .where((dish) => dish.isBlacklisted)
        .length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        Text('家庭菜单', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            Chip(label: Text('常做 ${state.dishes.length}')),
            Chip(label: Text('收藏 $favoriteCount')),
            Chip(label: Text('黑名单 $blockedCount')),
          ],
        ),
        SectionHeader(
          title: '菜品',
          trailing: IconButton.filledTonal(
            tooltip: '新增菜品',
            onPressed: () => showDishSheet(context, ref),
            icon: const Icon(Icons.add),
          ),
        ),
        if (state.dishes.isEmpty)
          const EmptyState(icon: Icons.menu_book_outlined, title: '还没有菜')
        else
          for (final dish in state.dishes) _DishTile(dish: dish),
      ],
    );
  }
}

class _DishTile extends ConsumerWidget {
  const _DishTile({required this.dish});

  final Dish dish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(demoHouseholdControllerProvider.notifier);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          dish.isBlacklisted ? Icons.block : Icons.ramen_dining_outlined,
        ),
        title: Text(dish.name),
        subtitle: Text('${dish.estimatedMinutes} 分钟 · ${dish.tags.join(' ')}'),
        trailing: Wrap(
          spacing: AppSpacing.xs,
          children: [
            IconButton(
              tooltip: '收藏',
              onPressed: () => controller.toggleFavorite(dish.id),
              icon: Icon(
                dish.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
            IconButton(
              tooltip: '黑名单',
              onPressed: () => controller.toggleBlacklisted(dish.id),
              icon: Icon(dish.isBlacklisted ? Icons.visibility : Icons.block),
            ),
            IconButton(
              tooltip: '编辑',
              onPressed: () => showDishSheet(context, ref, dish: dish),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: '删除',
              onPressed: () => controller.removeDish(dish.id),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showDishSheet(
  BuildContext context,
  WidgetRef ref, {
  Dish? dish,
}) async {
  final nameController = TextEditingController(text: dish?.name ?? '');
  final categoryController = TextEditingController(
    text: dish?.category ?? 'home',
  );
  final minutesController = TextEditingController(
    text: '${dish?.estimatedMinutes ?? 20}',
  );
  final tagsController = TextEditingController(
    text: dish?.tags.join(' ') ?? '',
  );

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom:
              MediaQuery.of(sheetContext).viewInsets.bottom + AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              dish == null ? '新增菜品' : '编辑菜品',
              style: Theme.of(sheetContext).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '菜名'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: '分类'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '分钟'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: tagsController,
              decoration: const InputDecoration(labelText: '标签'),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () {
                final minutes = int.tryParse(minutesController.text) ?? 20;
                ref.read(demoHouseholdControllerProvider.notifier).upsertDish(
                      id: dish?.id,
                      name: nameController.text,
                      category: categoryController.text,
                      estimatedMinutes: minutes,
                      tags: tagsController.text
                          .split(RegExp(r'\s+'))
                          .where((tag) => tag.isNotEmpty)
                          .toList(),
                    );
                Navigator.of(sheetContext).pop();
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('保存'),
            ),
          ],
        ),
      );
    },
  );

  nameController.dispose();
  categoryController.dispose();
  minutesController.dispose();
  tagsController.dispose();
}
