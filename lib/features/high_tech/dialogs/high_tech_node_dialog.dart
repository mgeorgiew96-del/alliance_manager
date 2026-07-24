import 'package:flutter/material.dart';

import '../../../shared/widgets/game/game_level_stepper.dart';
import '../models/high_tech_node_definition.dart';

class HighTechNodeDialog extends StatefulWidget {
  const HighTechNodeDialog({
    super.key,
    required this.definition,
    required this.currentLevel,
  });

  final HighTechNodeDefinition definition;
  final int currentLevel;

  static Future<int?> show({
    required BuildContext context,
    required HighTechNodeDefinition definition,
    required int currentLevel,
  }) {
    return showDialog<int>(
      context: context,
      builder: (context) {
        return HighTechNodeDialog(
          definition: definition,
          currentLevel: currentLevel,
        );
      },
    );
  }

  @override
  State<HighTechNodeDialog> createState() => _HighTechNodeDialogState();
}

class _HighTechNodeDialogState extends State<HighTechNodeDialog> {
  late int _level;

  @override
  void initState() {
    super.initState();
    _level = widget.currentLevel.clamp(
      widget.definition.minLevel,
      widget.definition.maxLevel,
    );
  }

  void _decreaseLevel() {
    if (_level <= widget.definition.minLevel) {
      return;
    }

    setState(() {
      _level -= 1;
    });
  }

  void _increaseLevel() {
    if (_level >= widget.definition.maxLevel) {
      return;
    }

    setState(() {
      _level += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final definition = widget.definition;
    final hasChanged = _level != widget.currentLevel;

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 22, 16, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      title: Row(
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: Image.asset(
              definition.assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.hub_outlined, size: 38);
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              definition.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(definition.description),
            ),
            const SizedBox(height: 24),
            GameLevelStepper(
              level: _level,
              minLevel: definition.minLevel,
              maxLevel: definition.maxLevel,
              onDecrease: _decreaseLevel,
              onIncrease: _increaseLevel,
            ),
            const SizedBox(height: 8),
            Text(
              'Minimum ${definition.minLevel} • Maximum ${definition.maxLevel}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        FilledButton.icon(
          onPressed: hasChanged
              ? () => Navigator.of(context).pop(_level)
              : null,
          icon: const Icon(Icons.check),
          label: const Text('APPLY'),
        ),
      ],
    );
  }
}
