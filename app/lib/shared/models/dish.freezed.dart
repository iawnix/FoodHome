// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dish.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Dish {

 String get id; String get name; String get category; int get estimatedMinutes; List<String> get tags; String get difficulty; bool get isFavorite; bool get isBlacklisted; DateTime? get lastCookedAt;
/// Create a copy of Dish
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DishCopyWith<Dish> get copyWith => _$DishCopyWithImpl<Dish>(this as Dish, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dish&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isBlacklisted, isBlacklisted) || other.isBlacklisted == isBlacklisted)&&(identical(other.lastCookedAt, lastCookedAt) || other.lastCookedAt == lastCookedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,estimatedMinutes,const DeepCollectionEquality().hash(tags),difficulty,isFavorite,isBlacklisted,lastCookedAt);

@override
String toString() {
  return 'Dish(id: $id, name: $name, category: $category, estimatedMinutes: $estimatedMinutes, tags: $tags, difficulty: $difficulty, isFavorite: $isFavorite, isBlacklisted: $isBlacklisted, lastCookedAt: $lastCookedAt)';
}


}

/// @nodoc
abstract mixin class $DishCopyWith<$Res>  {
  factory $DishCopyWith(Dish value, $Res Function(Dish) _then) = _$DishCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, int estimatedMinutes, List<String> tags, String difficulty, bool isFavorite, bool isBlacklisted, DateTime? lastCookedAt
});




}
/// @nodoc
class _$DishCopyWithImpl<$Res>
    implements $DishCopyWith<$Res> {
  _$DishCopyWithImpl(this._self, this._then);

  final Dish _self;
  final $Res Function(Dish) _then;

/// Create a copy of Dish
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? estimatedMinutes = null,Object? tags = null,Object? difficulty = null,Object? isFavorite = null,Object? isBlacklisted = null,Object? lastCookedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isBlacklisted: null == isBlacklisted ? _self.isBlacklisted : isBlacklisted // ignore: cast_nullable_to_non_nullable
as bool,lastCookedAt: freezed == lastCookedAt ? _self.lastCookedAt : lastCookedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Dish].
extension DishPatterns on Dish {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dish value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dish() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dish value)  $default,){
final _that = this;
switch (_that) {
case _Dish():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dish value)?  $default,){
final _that = this;
switch (_that) {
case _Dish() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  int estimatedMinutes,  List<String> tags,  String difficulty,  bool isFavorite,  bool isBlacklisted,  DateTime? lastCookedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dish() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.estimatedMinutes,_that.tags,_that.difficulty,_that.isFavorite,_that.isBlacklisted,_that.lastCookedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  int estimatedMinutes,  List<String> tags,  String difficulty,  bool isFavorite,  bool isBlacklisted,  DateTime? lastCookedAt)  $default,) {final _that = this;
switch (_that) {
case _Dish():
return $default(_that.id,_that.name,_that.category,_that.estimatedMinutes,_that.tags,_that.difficulty,_that.isFavorite,_that.isBlacklisted,_that.lastCookedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  int estimatedMinutes,  List<String> tags,  String difficulty,  bool isFavorite,  bool isBlacklisted,  DateTime? lastCookedAt)?  $default,) {final _that = this;
switch (_that) {
case _Dish() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.estimatedMinutes,_that.tags,_that.difficulty,_that.isFavorite,_that.isBlacklisted,_that.lastCookedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Dish extends Dish {
  const _Dish({required this.id, required this.name, required this.category, required this.estimatedMinutes, final  List<String> tags = const <String>[], this.difficulty = 'easy', this.isFavorite = false, this.isBlacklisted = false, this.lastCookedAt}): _tags = tags,super._();


@override final  String id;
@override final  String name;
@override final  String category;
@override final  int estimatedMinutes;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  String difficulty;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  bool isBlacklisted;
@override final  DateTime? lastCookedAt;

/// Create a copy of Dish
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DishCopyWith<_Dish> get copyWith => __$DishCopyWithImpl<_Dish>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dish&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isBlacklisted, isBlacklisted) || other.isBlacklisted == isBlacklisted)&&(identical(other.lastCookedAt, lastCookedAt) || other.lastCookedAt == lastCookedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,estimatedMinutes,const DeepCollectionEquality().hash(_tags),difficulty,isFavorite,isBlacklisted,lastCookedAt);

@override
String toString() {
  return 'Dish(id: $id, name: $name, category: $category, estimatedMinutes: $estimatedMinutes, tags: $tags, difficulty: $difficulty, isFavorite: $isFavorite, isBlacklisted: $isBlacklisted, lastCookedAt: $lastCookedAt)';
}


}

/// @nodoc
abstract mixin class _$DishCopyWith<$Res> implements $DishCopyWith<$Res> {
  factory _$DishCopyWith(_Dish value, $Res Function(_Dish) _then) = __$DishCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, int estimatedMinutes, List<String> tags, String difficulty, bool isFavorite, bool isBlacklisted, DateTime? lastCookedAt
});




}
/// @nodoc
class __$DishCopyWithImpl<$Res>
    implements _$DishCopyWith<$Res> {
  __$DishCopyWithImpl(this._self, this._then);

  final _Dish _self;
  final $Res Function(_Dish) _then;

/// Create a copy of Dish
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? estimatedMinutes = null,Object? tags = null,Object? difficulty = null,Object? isFavorite = null,Object? isBlacklisted = null,Object? lastCookedAt = freezed,}) {
  return _then(_Dish(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isBlacklisted: null == isBlacklisted ? _self.isBlacklisted : isBlacklisted // ignore: cast_nullable_to_non_nullable
as bool,lastCookedAt: freezed == lastCookedAt ? _self.lastCookedAt : lastCookedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
