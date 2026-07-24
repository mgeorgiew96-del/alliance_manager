import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../../../shared/widgets/am_unsaved_changes_banner.dart';
import '../definitions/high_tech_definitions.dart';
import '../models/high_tech_progress_config.dart';

class HighTechPrioritiesScreen extends ConsumerWidget {
  const HighTechPrioritiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prioritiesState = ref.watch(highTechPrioritiesProvider);
    final controller = ref.read(highTechPrioritiesProvider.notifier);

    final trackedCount = prioritiesState.draft.items.values
        .where((config) => config.isTracked)
        .length;
    final priorityCount = prioritiesState.draft.items.values
        .where((config) => config.isPriority)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFF090807),
      appBar: AppBar(
        backgroundColor: const Color(0xFF11100E),
        foregroundColor: const Color(0xFFF3E4C1),
        title: const Text('High Tech Priorities'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _SummaryHeader(
              trackedCount: trackedCount,
              priorityCount: priorityCount,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Column(
                children: [
                  AMUnsavedChangesBanner(
                    visible: prioritiesState.hasUnsavedChanges,
                    message:
                        'High Tech priority settings have unsaved changes.',
                  ),
                  if (prioritiesState.hasUnsavedChanges) ...[
                    const SizedBox(height: 10),
                    AMSaveCancelBar(
                      onSave: controller.save,
                      onCancel: controller.cancel,
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 24),
                itemCount: highTechDefinitions.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  final node = highTechDefinitions[index];
                  final nodeConfig =
                      prioritiesState.draft.configFor(node.id);

                  return _PriorityCard(
                    title: node.name,
                    description: node.description,
                    assetPath: node.assetPath,
                    isTracked: nodeConfig.isTracked,
                    isPriority: nodeConfig.isPriority,
                    onTrackedChanged: (value) {
                      controller.setTracked(
                        nodeId: node.id,
                        value: value,
                      );
                    },
                    onPriorityChanged: (value) {
                      controller.setPriority(
                        nodeId: node.id,
                        value: value,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({
    required this.trackedCount,
    required this.priorityCount,
  });

  final int trackedCount;
  final int priorityCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17130F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF795E31),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ALLIANCE PROGRESS SETTINGS',
            style: TextStyle(
              color: Color(0xFFFFE8AE),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tracked technologies count toward High Tech progress. '
            'Priority is an independent marker for important research.',
            style: TextStyle(
              color: Color(0xFFCDBF9C),
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _CountBadge(
                icon: Icons.check_circle_outline,
                label: '$trackedCount tracked',
              ),
              _CountBadge(
                icon: Icons.star_outline_rounded,
                label: '$priorityCount priority',
              ),
              _CountBadge(
                icon: Icons.account_tree_outlined,
                label: '${highTechDefinitions.length} total',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF221C14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF5F4A2A),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: const Color(0xFFC89B4A),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE5D5B1),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityCard extends StatelessWidget {
  const _PriorityCard({
    required this.title,
    required this.description,
    required this.assetPath,
    required this.isTracked,
    required this.isPriority,
    required this.onTrackedChanged,
    required this.onPriorityChanged,
  });

  final String title;
  final String description;
  final String assetPath;
  final bool isTracked;
  final bool isPriority;
  final ValueChanged<bool> onTrackedChanged;
  final ValueChanged<bool> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF15120F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPriority
              ? const Color(0xFFC89B4A)
              : const Color(0xFF4F4029),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  assetPath,
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 58,
                      height: 58,
                      alignment: Alignment.center,
                      color: const Color(0xFF282017),
                      child: const Icon(
                        Icons.science_outlined,
                        color: Color(0xFFC89B4A),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFFFE8AE),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFFC7B997),
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (isPriority)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.star_rounded,
                    color: Color(0xFFC89B4A),
                    size: 22,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(
            height: 1,
            color: Color(0xFF3C3224),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _SettingSwitch(
                  icon: Icons.check_circle_outline,
                  label: 'Track progress',
                  value: isTracked,
                  onChanged: onTrackedChanged,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SettingSwitch(
                  icon: Icons.star_outline_rounded,
                  label: 'Priority',
                  value: isPriority,
                  onChanged: onPriorityChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  const _SettingSwitch({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
        decoration: BoxDecoration(
          color: const Color(0xFF211B14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? const Color(0xFF8A6B35)
                : const Color(0xFF443827),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: value
                  ? const Color(0xFFC89B4A)
                  : const Color(0xFF8F846D),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: value
                      ? const Color(0xFFFFE8AE)
                      : const Color(0xFFB6AA90),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class HighTechPrioritiesState {
  const HighTechPrioritiesState({
    required this.saved,
    required this.draft,
  });

  final HighTechProgressConfig saved;
  final HighTechProgressConfig draft;

  bool get hasUnsavedChanges => !_configsEqual(saved, draft);

  HighTechPrioritiesState copyWith({
    HighTechProgressConfig? saved,
    HighTechProgressConfig? draft,
  }) {
    return HighTechPrioritiesState(
      saved: saved ?? this.saved,
      draft: draft ?? this.draft,
    );
  }

  static bool _configsEqual(
    HighTechProgressConfig first,
    HighTechProgressConfig second,
  ) {
    if (first.items.length != second.items.length) {
      return false;
    }

    for (final entry in first.items.entries) {
      final other = second.items[entry.key];

      if (other == null ||
          entry.value.isTracked != other.isTracked ||
          entry.value.isPriority != other.isPriority) {
        return false;
      }
    }

    return true;
  }
}

class HighTechPrioritiesController
    extends Notifier<HighTechPrioritiesState> {
  @override
  HighTechPrioritiesState build() {
    final initial = HighTechProgressConfig.initial();

    return HighTechPrioritiesState(
      saved: initial,
      draft: initial,
    );
  }

  void setTracked({
    required String nodeId,
    required bool value,
  }) {
    final current = state.draft.configFor(nodeId);

    state = state.copyWith(
      draft: state.draft.copyWithItem(
        nodeId: nodeId,
        config: current.copyWith(
          isTracked: value,
        ),
      ),
    );
  }

  void setPriority({
    required String nodeId,
    required bool value,
  }) {
    final current = state.draft.configFor(nodeId);

    state = state.copyWith(
      draft: state.draft.copyWithItem(
        nodeId: nodeId,
        config: current.copyWith(
          isPriority: value,
        ),
      ),
    );
  }

  Future<void> save() async {
    state = state.copyWith(
      saved: state.draft,
    );
  }

  Future<void> cancel() async {
    state = state.copyWith(
      draft: state.saved,
    );
  }
}

final highTechPrioritiesProvider = NotifierProvider<
    HighTechPrioritiesController,
    HighTechPrioritiesState>(
  HighTechPrioritiesController.new,
);
