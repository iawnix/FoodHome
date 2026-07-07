import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodhome_app/core/demo/demo_household_state.dart';
import 'package:foodhome_app/shared/models/dish.dart';
import 'package:foodhome_app/shared/models/food_order.dart';
import 'package:foodhome_app/shared/models/household_member.dart';
import 'package:foodhome_app/shared/models/order_state_machine.dart';
import 'package:foodhome_app/shared/models/order_status.dart';
import 'package:uuid/uuid.dart';

final demoHouseholdControllerProvider =
    NotifierProvider<DemoHouseholdController, DemoHouseholdState>(
      DemoHouseholdController.new,
    );

class DemoHouseholdController extends Notifier<DemoHouseholdState> {
  static const _uuid = Uuid();

  @override
  DemoHouseholdState build() => _seedState();

  void submitOrder({
    required String? dishId,
    required String rawText,
    required List<String> tasteNotes,
    required String? scheduledLabel,
  }) {
    final selectedDish = _findDish(dishId);
    final dishName = selectedDish?.name ?? _fallbackDishName(rawText);
    final noteParts = [
      ...tasteNotes,
      rawText.trim(),
      ...state.excludedIngredients.map((item) => '不要$item'),
    ].where((part) => part.isNotEmpty).toList();

    final order = FoodOrder(
      id: _uuid.v4(),
      dishId: selectedDish?.id,
      dishName: dishName,
      requesterName: '小雨',
      status: OrderStatus.requested,
      rawText: rawText.trim().isEmpty ? null : rawText.trim(),
      note: noteParts.isEmpty ? null : noteParts.join(' · '),
      scheduledLabel: scheduledLabel,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(orders: [order, ...state.orders]);
  }

  void transitionOrder({
    required String orderId,
    required OrderStatus targetStatus,
  }) {
    final updatedOrders = state.orders.map((order) {
      if (order.id != orderId) {
        return order;
      }
      if (!canTransitionOrder(from: order.status, to: targetStatus)) {
        return order;
      }
      final now = DateTime.now();
      return order.copyWith(
        status: targetStatus,
        cookName: targetStatus == OrderStatus.accepted
            ? state.todayCookName
            : order.cookName,
        completedAt: targetStatus.isTerminal ? now : order.completedAt,
      );
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }

  void upsertDish({
    required String name,
    required String category,
    required int estimatedMinutes,
    required List<String> tags,
    String? id,
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return;
    }

    final existingIndex = state.dishes.indexWhere((dish) => dish.id == id);
    final existingDish =
        existingIndex >= 0 ? state.dishes[existingIndex] : null;
    final dish = Dish(
      id: id ?? _uuid.v4(),
      name: trimmedName,
      category: category.trim().isEmpty ? 'home' : category.trim(),
      estimatedMinutes: estimatedMinutes.clamp(5, 180),
      tags: tags,
      difficulty: existingDish?.difficulty ?? 'easy',
      isFavorite: existingDish?.isFavorite ?? false,
      isBlacklisted: existingDish?.isBlacklisted ?? false,
      lastCookedAt: existingDish?.lastCookedAt,
    );

    if (existingIndex < 0) {
      state = state.copyWith(dishes: [dish, ...state.dishes]);
      return;
    }

    final dishes = [...state.dishes]..[existingIndex] = dish;
    state = state.copyWith(dishes: dishes);
  }

  void toggleFavorite(String dishId) {
    state = state.copyWith(
      dishes: [
        for (final dish in state.dishes)
          if (dish.id == dishId)
            dish.copyWith(isFavorite: !dish.isFavorite)
          else
            dish,
      ],
    );
  }

  void toggleBlacklisted(String dishId) {
    state = state.copyWith(
      dishes: [
        for (final dish in state.dishes)
          if (dish.id == dishId)
            dish.copyWith(isBlacklisted: !dish.isBlacklisted)
          else
            dish,
      ],
    );
  }

  void removeDish(String dishId) {
    state = state.copyWith(
      dishes: state.dishes.where((dish) => dish.id != dishId).toList(),
    );
  }

  void addTasteNote(String value) {
    final note = value.trim();
    if (note.isEmpty || state.tasteNotes.contains(note)) {
      return;
    }
    state = state.copyWith(tasteNotes: [...state.tasteNotes, note]);
  }

  void removeTasteNote(String value) {
    state = state.copyWith(
      tasteNotes: state.tasteNotes.where((note) => note != value).toList(),
    );
  }

  void addExcludedIngredient(String value) {
    final ingredient = value.trim();
    if (ingredient.isEmpty ||
        state.excludedIngredients.contains(ingredient)) {
      return;
    }
    state = state.copyWith(
      excludedIngredients: [...state.excludedIngredients, ingredient],
    );
  }

  void removeExcludedIngredient(String value) {
    state = state.copyWith(
      excludedIngredients: state.excludedIngredients
          .where((ingredient) => ingredient != value)
          .toList(),
    );
  }

  Dish? _findDish(String? dishId) {
    if (dishId == null) {
      return null;
    }
    for (final dish in state.dishes) {
      if (dish.id == dishId) {
        return dish;
      }
    }
    return null;
  }

  String _fallbackDishName(String rawText) {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      return '临时点菜';
    }
    return trimmed.length > 12 ? trimmed.substring(0, 12) : trimmed;
  }
}

DemoHouseholdState _seedState() {
  final now = DateTime.now();
  return DemoHouseholdState(
    householdName: '我们家',
    inviteCode: '425816',
    todayCookName: '阿哲',
    members: const [
      HouseholdMember(id: 'u_xiaoyu', displayName: '小雨', roleLabel: '点菜'),
      HouseholdMember(id: 'u_azhe', displayName: '阿哲', roleLabel: '主厨'),
    ],
    tasteNotes: const ['少油', '微辣', '清淡'],
    excludedIngredients: const ['香菜'],
    dishes: [
      Dish(
        id: 'dish_tomato_egg',
        name: '番茄鸡蛋',
        category: 'home',
        estimatedMinutes: 15,
        tags: const ['快手', '清淡'],
        isFavorite: true,
        lastCookedAt: now.subtract(const Duration(days: 2)),
      ),
      Dish(
        id: 'dish_beef',
        name: '番茄牛腩',
        category: 'favorite',
        estimatedMinutes: 60,
        tags: const ['暖胃', '周末'],
        isFavorite: true,
        lastCookedAt: now.subtract(const Duration(days: 9)),
      ),
      const Dish(
        id: 'dish_egg_custard',
        name: '虾仁蒸蛋',
        category: 'home',
        estimatedMinutes: 20,
        tags: ['少油', '蛋白质'],
      ),
      const Dish(
        id: 'dish_tofu_soup',
        name: '青菜豆腐汤',
        category: 'home',
        estimatedMinutes: 18,
        tags: ['清淡', '汤'],
      ),
      const Dish(
        id: 'dish_cilantro',
        name: '香菜拌牛肉',
        category: 'blocked',
        estimatedMinutes: 15,
        tags: ['凉菜'],
        isBlacklisted: true,
      ),
    ],
    orders: [
      FoodOrder(
        id: 'order_seed_1',
        dishId: 'dish_beef',
        dishName: '番茄牛腩',
        requesterName: '小雨',
        cookName: '阿哲',
        status: OrderStatus.accepted,
        note: '少油 · 不要香菜 · 19:00 前',
        scheduledLabel: '今晚 19:00 前',
        createdAt: now.subtract(const Duration(minutes: 12)),
      ),
    ],
  );
}
