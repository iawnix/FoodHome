// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demo_household_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DemoHouseholdState {

 String get householdName; String get inviteCode; List<HouseholdMember> get members; List<Dish> get dishes; List<FoodOrder> get orders; List<String> get tasteNotes; List<String> get excludedIngredients; String get todayCookName;
/// Create a copy of DemoHouseholdState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DemoHouseholdStateCopyWith<DemoHouseholdState> get copyWith => _$DemoHouseholdStateCopyWithImpl<DemoHouseholdState>(this as DemoHouseholdState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DemoHouseholdState&&(identical(other.householdName, householdName) || other.householdName == householdName)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.dishes, dishes)&&const DeepCollectionEquality().equals(other.orders, orders)&&const DeepCollectionEquality().equals(other.tasteNotes, tasteNotes)&&const DeepCollectionEquality().equals(other.excludedIngredients, excludedIngredients)&&(identical(other.todayCookName, todayCookName) || other.todayCookName == todayCookName));
}


@override
int get hashCode => Object.hash(runtimeType,householdName,inviteCode,const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(dishes),const DeepCollectionEquality().hash(orders),const DeepCollectionEquality().hash(tasteNotes),const DeepCollectionEquality().hash(excludedIngredients),todayCookName);

@override
String toString() {
  return 'DemoHouseholdState(householdName: $householdName, inviteCode: $inviteCode, members: $members, dishes: $dishes, orders: $orders, tasteNotes: $tasteNotes, excludedIngredients: $excludedIngredients, todayCookName: $todayCookName)';
}


}

/// @nodoc
abstract mixin class $DemoHouseholdStateCopyWith<$Res>  {
  factory $DemoHouseholdStateCopyWith(DemoHouseholdState value, $Res Function(DemoHouseholdState) _then) = _$DemoHouseholdStateCopyWithImpl;
@useResult
$Res call({
 String householdName, String inviteCode, List<HouseholdMember> members, List<Dish> dishes, List<FoodOrder> orders, List<String> tasteNotes, List<String> excludedIngredients, String todayCookName
});




}
/// @nodoc
class _$DemoHouseholdStateCopyWithImpl<$Res>
    implements $DemoHouseholdStateCopyWith<$Res> {
  _$DemoHouseholdStateCopyWithImpl(this._self, this._then);

  final DemoHouseholdState _self;
  final $Res Function(DemoHouseholdState) _then;

/// Create a copy of DemoHouseholdState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? householdName = null,Object? inviteCode = null,Object? members = null,Object? dishes = null,Object? orders = null,Object? tasteNotes = null,Object? excludedIngredients = null,Object? todayCookName = null,}) {
  return _then(_self.copyWith(
householdName: null == householdName ? _self.householdName : householdName // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<HouseholdMember>,dishes: null == dishes ? _self.dishes : dishes // ignore: cast_nullable_to_non_nullable
as List<Dish>,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<FoodOrder>,tasteNotes: null == tasteNotes ? _self.tasteNotes : tasteNotes // ignore: cast_nullable_to_non_nullable
as List<String>,excludedIngredients: null == excludedIngredients ? _self.excludedIngredients : excludedIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,todayCookName: null == todayCookName ? _self.todayCookName : todayCookName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DemoHouseholdState].
extension DemoHouseholdStatePatterns on DemoHouseholdState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DemoHouseholdState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DemoHouseholdState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DemoHouseholdState value)  $default,){
final _that = this;
switch (_that) {
case _DemoHouseholdState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DemoHouseholdState value)?  $default,){
final _that = this;
switch (_that) {
case _DemoHouseholdState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String householdName,  String inviteCode,  List<HouseholdMember> members,  List<Dish> dishes,  List<FoodOrder> orders,  List<String> tasteNotes,  List<String> excludedIngredients,  String todayCookName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DemoHouseholdState() when $default != null:
return $default(_that.householdName,_that.inviteCode,_that.members,_that.dishes,_that.orders,_that.tasteNotes,_that.excludedIngredients,_that.todayCookName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String householdName,  String inviteCode,  List<HouseholdMember> members,  List<Dish> dishes,  List<FoodOrder> orders,  List<String> tasteNotes,  List<String> excludedIngredients,  String todayCookName)  $default,) {final _that = this;
switch (_that) {
case _DemoHouseholdState():
return $default(_that.householdName,_that.inviteCode,_that.members,_that.dishes,_that.orders,_that.tasteNotes,_that.excludedIngredients,_that.todayCookName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String householdName,  String inviteCode,  List<HouseholdMember> members,  List<Dish> dishes,  List<FoodOrder> orders,  List<String> tasteNotes,  List<String> excludedIngredients,  String todayCookName)?  $default,) {final _that = this;
switch (_that) {
case _DemoHouseholdState() when $default != null:
return $default(_that.householdName,_that.inviteCode,_that.members,_that.dishes,_that.orders,_that.tasteNotes,_that.excludedIngredients,_that.todayCookName);case _:
  return null;

}
}

}

/// @nodoc


class _DemoHouseholdState extends DemoHouseholdState {
  const _DemoHouseholdState({required this.householdName, required this.inviteCode, required final  List<HouseholdMember> members, required final  List<Dish> dishes, required final  List<FoodOrder> orders, required final  List<String> tasteNotes, required final  List<String> excludedIngredients, required this.todayCookName}): _members = members,_dishes = dishes,_orders = orders,_tasteNotes = tasteNotes,_excludedIngredients = excludedIngredients,super._();


@override final  String householdName;
@override final  String inviteCode;
 final  List<HouseholdMember> _members;
@override List<HouseholdMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<Dish> _dishes;
@override List<Dish> get dishes {
  if (_dishes is EqualUnmodifiableListView) return _dishes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dishes);
}

 final  List<FoodOrder> _orders;
@override List<FoodOrder> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}

 final  List<String> _tasteNotes;
@override List<String> get tasteNotes {
  if (_tasteNotes is EqualUnmodifiableListView) return _tasteNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasteNotes);
}

 final  List<String> _excludedIngredients;
@override List<String> get excludedIngredients {
  if (_excludedIngredients is EqualUnmodifiableListView) return _excludedIngredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excludedIngredients);
}

@override final  String todayCookName;

/// Create a copy of DemoHouseholdState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DemoHouseholdStateCopyWith<_DemoHouseholdState> get copyWith => __$DemoHouseholdStateCopyWithImpl<_DemoHouseholdState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemoHouseholdState&&(identical(other.householdName, householdName) || other.householdName == householdName)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._dishes, _dishes)&&const DeepCollectionEquality().equals(other._orders, _orders)&&const DeepCollectionEquality().equals(other._tasteNotes, _tasteNotes)&&const DeepCollectionEquality().equals(other._excludedIngredients, _excludedIngredients)&&(identical(other.todayCookName, todayCookName) || other.todayCookName == todayCookName));
}


@override
int get hashCode => Object.hash(runtimeType,householdName,inviteCode,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_dishes),const DeepCollectionEquality().hash(_orders),const DeepCollectionEquality().hash(_tasteNotes),const DeepCollectionEquality().hash(_excludedIngredients),todayCookName);

@override
String toString() {
  return 'DemoHouseholdState(householdName: $householdName, inviteCode: $inviteCode, members: $members, dishes: $dishes, orders: $orders, tasteNotes: $tasteNotes, excludedIngredients: $excludedIngredients, todayCookName: $todayCookName)';
}


}

/// @nodoc
abstract mixin class _$DemoHouseholdStateCopyWith<$Res> implements $DemoHouseholdStateCopyWith<$Res> {
  factory _$DemoHouseholdStateCopyWith(_DemoHouseholdState value, $Res Function(_DemoHouseholdState) _then) = __$DemoHouseholdStateCopyWithImpl;
@override @useResult
$Res call({
 String householdName, String inviteCode, List<HouseholdMember> members, List<Dish> dishes, List<FoodOrder> orders, List<String> tasteNotes, List<String> excludedIngredients, String todayCookName
});




}
/// @nodoc
class __$DemoHouseholdStateCopyWithImpl<$Res>
    implements _$DemoHouseholdStateCopyWith<$Res> {
  __$DemoHouseholdStateCopyWithImpl(this._self, this._then);

  final _DemoHouseholdState _self;
  final $Res Function(_DemoHouseholdState) _then;

/// Create a copy of DemoHouseholdState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? householdName = null,Object? inviteCode = null,Object? members = null,Object? dishes = null,Object? orders = null,Object? tasteNotes = null,Object? excludedIngredients = null,Object? todayCookName = null,}) {
  return _then(_DemoHouseholdState(
householdName: null == householdName ? _self.householdName : householdName // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<HouseholdMember>,dishes: null == dishes ? _self._dishes : dishes // ignore: cast_nullable_to_non_nullable
as List<Dish>,orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<FoodOrder>,tasteNotes: null == tasteNotes ? _self._tasteNotes : tasteNotes // ignore: cast_nullable_to_non_nullable
as List<String>,excludedIngredients: null == excludedIngredients ? _self._excludedIngredients : excludedIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,todayCookName: null == todayCookName ? _self.todayCookName : todayCookName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
