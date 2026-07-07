import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodhome_app/core/theme/tokens.dart';
import 'package:foodhome_app/features/household/presentation/controllers/household_controller.dart';
import 'package:foodhome_app/shared/models/dish.dart';
import 'package:foodhome_app/shared/widgets/section_header.dart';

class TodayOrderPage extends ConsumerStatefulWidget {
  const TodayOrderPage({super.key});

  @override
  ConsumerState<TodayOrderPage> createState() => _TodayOrderPageState();
}

class _TodayOrderPageState extends ConsumerState<TodayOrderPage> {
  final _noteController = TextEditingController();
  final _selectedTasteNotes = <String>{'少油'};
  String? _selectedDishId = 'dish_tomato_egg';
  String _scheduledLabel = '今晚 19:00 前';

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(householdControllerProvider);
    final dishes = state.availableDishes;
    final selectedDish = _selectedDish(dishes);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        Text('今晚吃什么', style: Theme.of(context).textTheme.headlineSmall),
        const SectionHeader(title: '家里常吃'),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final dish in dishes)
              ChoiceChip(
                label: Text('${dish.name} · ${dish.estimatedMinutes}m'),
                selected: selectedDish?.id == dish.id,
                onSelected: (_) => setState(() => _selectedDishId = dish.id),
              ),
          ],
        ),
        const SectionHeader(title: '口味'),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final note in state.tasteNotes)
              FilterChip(
                label: Text(note),
                selected: _selectedTasteNotes.contains(note),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTasteNotes.add(note);
                    } else {
                      _selectedTasteNotes.remove(note);
                    }
                  });
                },
              ),
            for (final ingredient in state.excludedIngredients)
              FilterChip(
                label: Text('不要$ingredient'),
                selected: true,
                onSelected: (_) {},
              ),
          ],
        ),
        const SectionHeader(title: '时间'),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: '今晚 18:30 前',
              icon: Icon(Icons.schedule),
              label: Text('18:30'),
            ),
            ButtonSegment(
              value: '今晚 19:00 前',
              icon: Icon(Icons.schedule),
              label: Text('19:00'),
            ),
            ButtonSegment(
              value: '不着急',
              icon: Icon(Icons.self_improvement),
              label: Text('随时'),
            ),
          ],
          selected: {_scheduledLabel},
          onSelectionChanged: (value) {
            setState(() => _scheduledLabel = value.first);
          },
        ),
        const SectionHeader(title: '备注'),
        TextField(
          controller: _noteController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: '想吃暖一点，少放油',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: () => _submit(selectedDish),
          icon: const Icon(Icons.send_outlined),
          label: const Text('点菜'),
        ),
      ],
    );
  }

  Dish? _selectedDish(List<Dish> dishes) {
    for (final dish in dishes) {
      if (dish.id == _selectedDishId) {
        return dish;
      }
    }
    return dishes.isEmpty ? null : dishes.first;
  }

  void _submit(Dish? selectedDish) {
    ref.read(householdControllerProvider.notifier).submitOrder(
          dishId: selectedDish?.id,
          rawText: _noteController.text,
          tasteNotes: _selectedTasteNotes.toList(),
          scheduledLabel: _scheduledLabel,
        );
    _noteController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${selectedDish?.name ?? '这道菜'} 已发给厨房')),
    );
  }
}
