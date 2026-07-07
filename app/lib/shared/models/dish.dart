import 'package:freezed_annotation/freezed_annotation.dart';

part 'dish.freezed.dart';

@freezed
abstract class Dish with _$Dish {
  const factory Dish({
    required String id,
    required String name,
    required String category,
    required int estimatedMinutes,
    @Default(<String>[]) List<String> tags,
    @Default('easy') String difficulty,
    @Default(false) bool isFavorite,
    @Default(false) bool isBlacklisted,
    DateTime? lastCookedAt,
  }) = _Dish;

  const Dish._();

  bool get isAvailable => !isBlacklisted;
}
