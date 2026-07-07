import 'package:flutter/material.dart';
import 'package:foodhome_app/shared/models/order_status.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(status);
    return Chip(
      avatar: Icon(_iconFor(status), size: 16, color: colors.$2),
      backgroundColor: colors.$1,
      side: BorderSide(color: colors.$2.withValues(alpha: 0.25)),
      label: Text(
        status.label,
        style: TextStyle(color: colors.$2, fontWeight: FontWeight.w700),
      ),
      visualDensity: VisualDensity.compact,
    );
  }

  (Color, Color) _colorsFor(OrderStatus status) {
    return switch (status) {
      OrderStatus.requested => (
          const Color(0xFFFFF1D8),
          const Color(0xFF8D5A00),
        ),
      OrderStatus.accepted => (
          const Color(0xFFE7F3FF),
          const Color(0xFF2266A8),
        ),
      OrderStatus.cooking => (
          const Color(0xFFFFECE7),
          const Color(0xFFB23B18),
        ),
      OrderStatus.blocked => (
          const Color(0xFFFFF3F3),
          const Color(0xFFB3261E),
        ),
      OrderStatus.served => (
          const Color(0xFFE7F5ED),
          const Color(0xFF287C5B),
        ),
      OrderStatus.cancelled => (
          const Color(0xFFF0EFED),
          const Color(0xFF6F6660),
        ),
    };
  }

  IconData _iconFor(OrderStatus status) {
    return switch (status) {
      OrderStatus.requested => Icons.room_service_outlined,
      OrderStatus.accepted => Icons.task_alt,
      OrderStatus.cooking => Icons.local_fire_department_outlined,
      OrderStatus.blocked => Icons.shopping_basket_outlined,
      OrderStatus.served => Icons.dining_outlined,
      OrderStatus.cancelled => Icons.cancel_outlined,
    };
  }
}
