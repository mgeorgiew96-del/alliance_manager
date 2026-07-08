import 'package:flutter/material.dart';

import '../models/beast_type.dart';
import '../../../shared/theme/am_spacing.dart';

class BeastSelector extends StatelessWidget {
  const BeastSelector({
    super.key,
    required this.selectedBeast,
    required this.onChanged,
  });

  final BeastType selectedBeast;
  final ValueChanged<BeastType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AMSpacing.sm,
      runSpacing: AMSpacing.sm,
      children: [
        for (final beast in BeastType.values)
          ChoiceChip(
            label: Text(beast.name.toUpperCase()),
            selected: selectedBeast == beast,
            onSelected: (_) => onChanged(beast),
          ),
      ],
    );
  }
}