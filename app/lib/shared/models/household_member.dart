import 'package:freezed_annotation/freezed_annotation.dart';

part 'household_member.freezed.dart';

@freezed
abstract class HouseholdMember with _$HouseholdMember {
  const factory HouseholdMember({
    required String id,
    required String displayName,
    required String roleLabel,
  }) = _HouseholdMember;
}
