import 'package:foodhome_app/shared/models/order_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_order.freezed.dart';

@freezed
abstract class FoodOrder with _$FoodOrder {
  const factory FoodOrder({
    required String id,
    required String dishName,
    required String requesterName,
    required OrderStatus status,
    required DateTime createdAt,
    String? dishId,
    String? cookName,
    String? rawText,
    String? note,
    String? scheduledLabel,
    DateTime? completedAt,
  }) = _FoodOrder;

  const FoodOrder._();

  bool get isOpen => !status.isTerminal;
}
