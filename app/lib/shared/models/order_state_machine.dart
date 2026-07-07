import 'package:foodhome_app/shared/models/order_status.dart';

bool canTransitionOrder({
  required OrderStatus from,
  required OrderStatus to,
}) {
  return nextOrderStatuses(from).contains(to);
}

List<OrderStatus> nextOrderStatuses(OrderStatus status) {
  return switch (status) {
    OrderStatus.requested => [
      OrderStatus.accepted,
      OrderStatus.cancelled,
    ],
    OrderStatus.accepted => [
      OrderStatus.cooking,
      OrderStatus.blocked,
      OrderStatus.cancelled,
    ],
    OrderStatus.cooking => [
      OrderStatus.blocked,
      OrderStatus.served,
    ],
    OrderStatus.blocked => [
      OrderStatus.accepted,
      OrderStatus.cooking,
      OrderStatus.cancelled,
    ],
    OrderStatus.served || OrderStatus.cancelled => const [],
  };
}
