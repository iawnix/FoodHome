import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodhome_app/features/household/data/local_household_repository.dart';
import 'package:foodhome_app/features/household/domain/household_state.dart';
import 'package:foodhome_app/shared/models/order_status.dart';

final householdRepositoryProvider = Provider<HouseholdRepository>(
  (ref) => const LocalHouseholdRepository(),
);

abstract interface class HouseholdRepository {
  HouseholdState initialState();

  HouseholdState submitOrder(
    HouseholdState state,
    SubmitOrderDraft draft,
  );

  HouseholdState transitionOrder(
    HouseholdState state,
    OrderTransitionCommand command,
  );

  HouseholdState upsertDish(
    HouseholdState state,
    DishFormInput input,
  );

  HouseholdState toggleFavorite(HouseholdState state, String dishId);

  HouseholdState toggleBlacklisted(HouseholdState state, String dishId);

  HouseholdState removeDish(HouseholdState state, String dishId);

  HouseholdState addTasteNote(HouseholdState state, String value);

  HouseholdState removeTasteNote(HouseholdState state, String value);

  HouseholdState addExcludedIngredient(HouseholdState state, String value);

  HouseholdState removeExcludedIngredient(HouseholdState state, String value);
}

final class SubmitOrderDraft {
  const SubmitOrderDraft({
    required this.rawText,
    required this.tasteNotes,
    this.dishId,
    this.scheduledLabel,
  });

  final String? dishId;
  final String rawText;
  final List<String> tasteNotes;
  final String? scheduledLabel;
}

final class OrderTransitionCommand {
  const OrderTransitionCommand({
    required this.orderId,
    required this.targetStatus,
  });

  final String orderId;
  final OrderStatus targetStatus;
}

final class DishFormInput {
  const DishFormInput({
    required this.name,
    required this.category,
    required this.estimatedMinutes,
    required this.tags,
    this.id,
  });

  final String? id;
  final String name;
  final String category;
  final int estimatedMinutes;
  final List<String> tags;
}
