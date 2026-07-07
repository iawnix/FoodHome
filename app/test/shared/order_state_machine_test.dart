import 'package:flutter_test/flutter_test.dart';
import 'package:foodhome_app/shared/models/order_state_machine.dart';
import 'package:foodhome_app/shared/models/order_status.dart';

void main() {
  group('order state machine', () {
    test('allows the requested to served happy path', () {
      expect(
        canTransitionOrder(
          from: OrderStatus.requested,
          to: OrderStatus.accepted,
        ),
        isTrue,
      );
      expect(
        canTransitionOrder(
          from: OrderStatus.accepted,
          to: OrderStatus.cooking,
        ),
        isTrue,
      );
      expect(
        canTransitionOrder(
          from: OrderStatus.cooking,
          to: OrderStatus.served,
        ),
        isTrue,
      );
    });

    test('blocks terminal status changes', () {
      expect(
        canTransitionOrder(
          from: OrderStatus.served,
          to: OrderStatus.cancelled,
        ),
        isFalse,
      );
      expect(nextOrderStatuses(OrderStatus.cancelled), isEmpty);
    });
  });
}
