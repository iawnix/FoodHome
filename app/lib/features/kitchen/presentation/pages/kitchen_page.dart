import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodhome_app/core/demo/demo_household_controller.dart';
import 'package:foodhome_app/core/theme/tokens.dart';
import 'package:foodhome_app/shared/models/food_order.dart';
import 'package:foodhome_app/shared/models/order_status.dart';
import 'package:foodhome_app/shared/widgets/empty_state.dart';
import 'package:foodhome_app/shared/widgets/section_header.dart';
import 'package:foodhome_app/shared/widgets/status_pill.dart';

class KitchenPage extends ConsumerWidget {
  const KitchenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(demoHouseholdControllerProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        Text('厨房接单', style: Theme.of(context).textTheme.headlineSmall),
        const SectionHeader(title: '待处理'),
        if (state.activeOrders.isEmpty)
          const EmptyState(icon: Icons.soup_kitchen_outlined, title: '今晚还没点')
        else
          for (final order in state.activeOrders)
            _KitchenOrderCard(order: order),
        const SectionHeader(title: '最近完成'),
        if (state.completedOrders.isEmpty)
          const EmptyState(icon: Icons.history_outlined, title: '还没有完成记录')
        else
          for (final order in state.completedOrders.take(3))
            _CompactOrderTile(order: order),
      ],
    );
  }
}

class _KitchenOrderCard extends ConsumerWidget {
  const _KitchenOrderCard({required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    order.dishName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                StatusPill(status: order.status),
              ],
            ),
            if (order.note != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(order.note!),
            ],
            if (order.scheduledLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Text(order.scheduledLabel!),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final action in _actionsFor(order.status))
                  FilledButton.tonalIcon(
                    onPressed: () => ref
                        .read(demoHouseholdControllerProvider.notifier)
                        .transitionOrder(
                          orderId: order.id,
                          targetStatus: action.target,
                        ),
                    icon: Icon(action.icon),
                    label: Text(action.label),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<_KitchenAction> _actionsFor(OrderStatus status) {
    return switch (status) {
      OrderStatus.requested => const [
        _KitchenAction('接单', Icons.task_alt, OrderStatus.accepted),
        _KitchenAction('取消', Icons.cancel_outlined, OrderStatus.cancelled),
      ],
      OrderStatus.accepted => const [
        _KitchenAction(
          '开始做了',
          Icons.local_fire_department_outlined,
          OrderStatus.cooking,
        ),
        _KitchenAction(
          '缺食材',
          Icons.shopping_basket_outlined,
          OrderStatus.blocked,
        ),
      ],
      OrderStatus.cooking => const [
        _KitchenAction('可以开饭', Icons.dining_outlined, OrderStatus.served),
        _KitchenAction(
          '缺食材',
          Icons.shopping_basket_outlined,
          OrderStatus.blocked,
        ),
      ],
      OrderStatus.blocked => const [
        _KitchenAction(
          '继续做',
          Icons.local_fire_department_outlined,
          OrderStatus.cooking,
        ),
        _KitchenAction('取消', Icons.cancel_outlined, OrderStatus.cancelled),
      ],
      OrderStatus.served || OrderStatus.cancelled => const [],
    };
  }
}

class _KitchenAction {
  const _KitchenAction(this.label, this.icon, this.target);

  final String label;
  final IconData icon;
  final OrderStatus target;
}

class _CompactOrderTile extends StatelessWidget {
  const _CompactOrderTile({required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.dining_outlined),
      title: Text(order.dishName),
      subtitle: Text(order.note ?? order.requesterName),
      trailing: StatusPill(status: order.status),
    );
  }
}
