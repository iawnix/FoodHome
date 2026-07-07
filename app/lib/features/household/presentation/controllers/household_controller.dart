import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodhome_app/features/household/data/household_repository.dart';
import 'package:foodhome_app/features/household/domain/household_state.dart';
import 'package:foodhome_app/shared/models/order_status.dart';

final householdControllerProvider =
    NotifierProvider<HouseholdController, HouseholdState>(
      HouseholdController.new,
    );

class HouseholdController extends Notifier<HouseholdState> {
  HouseholdRepository get _repository => ref.read(householdRepositoryProvider);

  @override
  HouseholdState build() => _repository.initialState();

  void submitOrder({
    required String? dishId,
    required String rawText,
    required List<String> tasteNotes,
    required String? scheduledLabel,
  }) {
    state = _repository.submitOrder(
      state,
      SubmitOrderDraft(
        dishId: dishId,
        rawText: rawText,
        tasteNotes: tasteNotes,
        scheduledLabel: scheduledLabel,
      ),
    );
  }

  void transitionOrder({
    required String orderId,
    required OrderStatus targetStatus,
  }) {
    state = _repository.transitionOrder(
      state,
      OrderTransitionCommand(
        orderId: orderId,
        targetStatus: targetStatus,
      ),
    );
  }

  void upsertDish({
    required String name,
    required String category,
    required int estimatedMinutes,
    required List<String> tags,
    String? id,
  }) {
    state = _repository.upsertDish(
      state,
      DishFormInput(
        id: id,
        name: name,
        category: category,
        estimatedMinutes: estimatedMinutes,
        tags: tags,
      ),
    );
  }

  void toggleFavorite(String dishId) {
    state = _repository.toggleFavorite(state, dishId);
  }

  void toggleBlacklisted(String dishId) {
    state = _repository.toggleBlacklisted(state, dishId);
  }

  void removeDish(String dishId) {
    state = _repository.removeDish(state, dishId);
  }

  void addTasteNote(String value) {
    state = _repository.addTasteNote(state, value);
  }

  void removeTasteNote(String value) {
    state = _repository.removeTasteNote(state, value);
  }

  void addExcludedIngredient(String value) {
    state = _repository.addExcludedIngredient(state, value);
  }

  void removeExcludedIngredient(String value) {
    state = _repository.removeExcludedIngredient(state, value);
  }
}
