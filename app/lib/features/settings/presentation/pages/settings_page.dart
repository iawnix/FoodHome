import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodhome_app/core/theme/tokens.dart';
import 'package:foodhome_app/features/household/presentation/controllers/household_controller.dart';
import 'package:foodhome_app/shared/widgets/section_header.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(householdControllerProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        Text('设置', style: Theme.of(context).textTheme.headlineSmall),
        const SectionHeader(title: '家庭空间'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.householdName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                SelectableText('邀请码 ${state.inviteCode}'),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final member in state.members)
                      Chip(
                        avatar: const Icon(Icons.person_outline, size: 18),
                        label: Text(
                          '${member.displayName} · ${member.roleLabel}',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SectionHeader(
          title: '口味偏好',
          trailing: IconButton.filledTonal(
            tooltip: '添加口味',
            onPressed: () => _showPreferenceDialog(
              context: context,
              title: '添加口味',
              onSave: ref
                  .read(householdControllerProvider.notifier)
                  .addTasteNote,
            ),
            icon: const Icon(Icons.add),
          ),
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final note in state.tasteNotes)
              InputChip(
                label: Text(note),
                onDeleted: () => ref
                    .read(householdControllerProvider.notifier)
                    .removeTasteNote(note),
              ),
          ],
        ),
        SectionHeader(
          title: '忌口',
          trailing: IconButton.filledTonal(
            tooltip: '添加忌口',
            onPressed: () => _showPreferenceDialog(
              context: context,
              title: '添加忌口',
              onSave: ref
                  .read(householdControllerProvider.notifier)
                  .addExcludedIngredient,
            ),
            icon: const Icon(Icons.add),
          ),
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final ingredient in state.excludedIngredients)
              InputChip(
                label: Text('不要$ingredient'),
                onDeleted: () => ref
                    .read(householdControllerProvider.notifier)
                    .removeExcludedIngredient(ingredient),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _showPreferenceDialog({
    required BuildContext context,
    required String title,
    required ValueChanged<String> onSave,
  }) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: '少油 / 香菜'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    controller.dispose();
  }
}
