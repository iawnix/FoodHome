import 'package:foodhome_app/shared/models/dish.dart';
import 'package:foodhome_app/shared/models/food_order.dart';
import 'package:foodhome_app/shared/models/household_member.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'household_state.freezed.dart';

@freezed
abstract class HouseholdState with _$HouseholdState {
  const factory HouseholdState({
    required String householdName,
    required String inviteCode,
    required List<HouseholdMember> members,
    required List<Dish> dishes,
    required List<FoodOrder> orders,
    required List<String> tasteNotes,
    required List<String> excludedIngredients,
    required String todayCookName,
  }) = _HouseholdState;

  const HouseholdState._();

  List<Dish> get availableDishes {
    return dishes.where((dish) => dish.isAvailable).toList();
  }

  List<FoodOrder> get activeOrders {
    return orders.where((order) => order.isOpen).toList();
  }

  List<FoodOrder> get completedOrders {
    return orders.where((order) => !order.isOpen).toList();
  }
}
