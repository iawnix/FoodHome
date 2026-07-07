// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoodOrder {

 String get id; String get dishName; String get requesterName; OrderStatus get status; DateTime get createdAt; String? get dishId; String? get cookName; String? get rawText; String? get note; String? get scheduledLabel; DateTime? get completedAt;
/// Create a copy of FoodOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodOrderCopyWith<FoodOrder> get copyWith => _$FoodOrderCopyWithImpl<FoodOrder>(this as FoodOrder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.dishName, dishName) || other.dishName == dishName)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dishId, dishId) || other.dishId == dishId)&&(identical(other.cookName, cookName) || other.cookName == cookName)&&(identical(other.rawText, rawText) || other.rawText == rawText)&&(identical(other.note, note) || other.note == note)&&(identical(other.scheduledLabel, scheduledLabel) || other.scheduledLabel == scheduledLabel)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,dishName,requesterName,status,createdAt,dishId,cookName,rawText,note,scheduledLabel,completedAt);

@override
String toString() {
  return 'FoodOrder(id: $id, dishName: $dishName, requesterName: $requesterName, status: $status, createdAt: $createdAt, dishId: $dishId, cookName: $cookName, rawText: $rawText, note: $note, scheduledLabel: $scheduledLabel, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $FoodOrderCopyWith<$Res>  {
  factory $FoodOrderCopyWith(FoodOrder value, $Res Function(FoodOrder) _then) = _$FoodOrderCopyWithImpl;
@useResult
$Res call({
 String id, String dishName, String requesterName, OrderStatus status, DateTime createdAt, String? dishId, String? cookName, String? rawText, String? note, String? scheduledLabel, DateTime? completedAt
});




}
/// @nodoc
class _$FoodOrderCopyWithImpl<$Res>
    implements $FoodOrderCopyWith<$Res> {
  _$FoodOrderCopyWithImpl(this._self, this._then);

  final FoodOrder _self;
  final $Res Function(FoodOrder) _then;

/// Create a copy of FoodOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dishName = null,Object? requesterName = null,Object? status = null,Object? createdAt = null,Object? dishId = freezed,Object? cookName = freezed,Object? rawText = freezed,Object? note = freezed,Object? scheduledLabel = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dishName: null == dishName ? _self.dishName : dishName // ignore: cast_nullable_to_non_nullable
as String,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dishId: freezed == dishId ? _self.dishId : dishId // ignore: cast_nullable_to_non_nullable
as String?,cookName: freezed == cookName ? _self.cookName : cookName // ignore: cast_nullable_to_non_nullable
as String?,rawText: freezed == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,scheduledLabel: freezed == scheduledLabel ? _self.scheduledLabel : scheduledLabel // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodOrder].
extension FoodOrderPatterns on FoodOrder {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodOrder() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodOrder value)  $default,){
final _that = this;
switch (_that) {
case _FoodOrder():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodOrder value)?  $default,){
final _that = this;
switch (_that) {
case _FoodOrder() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dishName,  String requesterName,  OrderStatus status,  DateTime createdAt,  String? dishId,  String? cookName,  String? rawText,  String? note,  String? scheduledLabel,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodOrder() when $default != null:
return $default(_that.id,_that.dishName,_that.requesterName,_that.status,_that.createdAt,_that.dishId,_that.cookName,_that.rawText,_that.note,_that.scheduledLabel,_that.completedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dishName,  String requesterName,  OrderStatus status,  DateTime createdAt,  String? dishId,  String? cookName,  String? rawText,  String? note,  String? scheduledLabel,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _FoodOrder():
return $default(_that.id,_that.dishName,_that.requesterName,_that.status,_that.createdAt,_that.dishId,_that.cookName,_that.rawText,_that.note,_that.scheduledLabel,_that.completedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dishName,  String requesterName,  OrderStatus status,  DateTime createdAt,  String? dishId,  String? cookName,  String? rawText,  String? note,  String? scheduledLabel,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _FoodOrder() when $default != null:
return $default(_that.id,_that.dishName,_that.requesterName,_that.status,_that.createdAt,_that.dishId,_that.cookName,_that.rawText,_that.note,_that.scheduledLabel,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FoodOrder extends FoodOrder {
  const _FoodOrder({required this.id, required this.dishName, required this.requesterName, required this.status, required this.createdAt, this.dishId, this.cookName, this.rawText, this.note, this.scheduledLabel, this.completedAt}): super._();


@override final  String id;
@override final  String dishName;
@override final  String requesterName;
@override final  OrderStatus status;
@override final  DateTime createdAt;
@override final  String? dishId;
@override final  String? cookName;
@override final  String? rawText;
@override final  String? note;
@override final  String? scheduledLabel;
@override final  DateTime? completedAt;

/// Create a copy of FoodOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodOrderCopyWith<_FoodOrder> get copyWith => __$FoodOrderCopyWithImpl<_FoodOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.dishName, dishName) || other.dishName == dishName)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dishId, dishId) || other.dishId == dishId)&&(identical(other.cookName, cookName) || other.cookName == cookName)&&(identical(other.rawText, rawText) || other.rawText == rawText)&&(identical(other.note, note) || other.note == note)&&(identical(other.scheduledLabel, scheduledLabel) || other.scheduledLabel == scheduledLabel)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,dishName,requesterName,status,createdAt,dishId,cookName,rawText,note,scheduledLabel,completedAt);

@override
String toString() {
  return 'FoodOrder(id: $id, dishName: $dishName, requesterName: $requesterName, status: $status, createdAt: $createdAt, dishId: $dishId, cookName: $cookName, rawText: $rawText, note: $note, scheduledLabel: $scheduledLabel, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$FoodOrderCopyWith<$Res> implements $FoodOrderCopyWith<$Res> {
  factory _$FoodOrderCopyWith(_FoodOrder value, $Res Function(_FoodOrder) _then) = __$FoodOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String dishName, String requesterName, OrderStatus status, DateTime createdAt, String? dishId, String? cookName, String? rawText, String? note, String? scheduledLabel, DateTime? completedAt
});




}
/// @nodoc
class __$FoodOrderCopyWithImpl<$Res>
    implements _$FoodOrderCopyWith<$Res> {
  __$FoodOrderCopyWithImpl(this._self, this._then);

  final _FoodOrder _self;
  final $Res Function(_FoodOrder) _then;

/// Create a copy of FoodOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dishName = null,Object? requesterName = null,Object? status = null,Object? createdAt = null,Object? dishId = freezed,Object? cookName = freezed,Object? rawText = freezed,Object? note = freezed,Object? scheduledLabel = freezed,Object? completedAt = freezed,}) {
  return _then(_FoodOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dishName: null == dishName ? _self.dishName : dishName // ignore: cast_nullable_to_non_nullable
as String,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dishId: freezed == dishId ? _self.dishId : dishId // ignore: cast_nullable_to_non_nullable
as String?,cookName: freezed == cookName ? _self.cookName : cookName // ignore: cast_nullable_to_non_nullable
as String?,rawText: freezed == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,scheduledLabel: freezed == scheduledLabel ? _self.scheduledLabel : scheduledLabel // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
