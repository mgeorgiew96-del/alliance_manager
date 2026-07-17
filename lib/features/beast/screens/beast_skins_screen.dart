import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/am_assets.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_asset_image.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_module_header.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../controllers/beast_controller.dart';
import '../models/beast_state.dart';
import '../models/beast_type.dart';

class BeastSkinsScreen extends ConsumerWidget {
  const BeastSkinsScreen({super.key, required this.amId});

  final String amId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beastState = ref.watch(beastControllerProvider);

    return beastState.when(
      loading: () =>
          const AMPage(child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AMPage(
        child: Center(
          child: Text('Failed to load Beast skins.', style: AMTextStyles.body),
        ),
      ),
      data: (state) {
        return _BeastSkinsView(state: state, amId: amId);
      },
    );
  }
}

class _BeastSkinsView extends ConsumerWidget {
  const _BeastSkinsView({required this.state, required this.amId});

  final BeastState state;
  final String amId;

  double get _progress {
    var current = 0;
    var maximum = 0;

    for (final skin in _skinDefinitions) {
      current += state.skinLevels[skin.id] ?? 0;
      maximum += skin.maxLevel;
    }

    if (maximum == 0) {
      return 0;
    }

    return current / maximum;
  }

  String get _lastUpdatedText {
    final lastUpdated = state.lastUpdated;

    if (lastUpdated == null) {
      return 'Not saved yet';
    }

    return '${lastUpdated.day.toString().padLeft(2, '0')}.'
        '${lastUpdated.month.toString().padLeft(2, '0')}.'
        '${lastUpdated.year} '
        '${lastUpdated.hour.toString().padLeft(2, '0')}:'
        '${lastUpdated.minute.toString().padLeft(2, '0')}';
  }

  String get _beastName {
    switch (state.selectedBeast) {
      case BeastType.panda:
        return 'Panda';
      case BeastType.dragon:
        return 'Dragon';
      case BeastType.pegasus:
        return 'Pegasus';
      case BeastType.phoenix:
        return 'Phoenix';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(beastControllerProvider.notifier);

    return AMPage(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BackButton(
              onPressed: () {
                context.go('/member/$amId/beast');
              },
            ),
            const SizedBox(height: AMSpacing.md),
            AMModuleHeader(
              title: '$_beastName SKINS',
              progress: _progress,
              lastUpdated: _lastUpdatedText,
              hasUnsavedChanges: state.hasUnsavedChanges,
            ),
            const SizedBox(height: AMSpacing.sm),
            Text(
              'All six skins contribute together. Upgrade and save '
              'their levels below.',
              style: AMTextStyles.body,
            ),
            if (state.hasUnsavedChanges) ...[
              const SizedBox(height: AMSpacing.lg),
              AMSaveCancelBar(
                onSave: controller.save,
                onCancel: controller.cancel,
              ),
            ],
            const SizedBox(height: AMSpacing.lg),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = _columnCountForWidth(constraints.maxWidth);

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _skinDefinitions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: AMSpacing.md,
                    mainAxisSpacing: AMSpacing.md,
                    childAspectRatio: columns == 1 ? 0.92 : 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final skin = _skinDefinitions[index];

                    final level = state.skinLevels[skin.id] ?? 0;

                    return _SkinCard(
                      beastType: state.selectedBeast,
                      skin: skin,
                      level: level,
                      onIncrease: () {
                        controller.increaseSkin(
                          skinId: skin.id,
                          maxLevel: skin.maxLevel,
                        );
                      },
                      onDecrease: () {
                        controller.decreaseSkin(skinId: skin.id);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  int _columnCountForWidth(double width) {
    if (width >= 1100) {
      return 3;
    }

    if (width >= 700) {
      return 2;
    }

    return 1;
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back to Beast',
          onPressed: onPressed,
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: AMSpacing.xs),
        Text('Back to Beast', style: AMTextStyles.body),
      ],
    );
  }
}

class _SkinCard extends StatelessWidget {
  const _SkinCard({
    required this.beastType,
    required this.skin,
    required this.level,
    required this.onIncrease,
    required this.onDecrease,
  });

  final BeastType beastType;
  final _SkinDefinition skin;
  final int level;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  double get _progress {
    if (skin.maxLevel == 0) {
      return 0;
    }

    return level / skin.maxLevel;
  }

  bool get _isMaxed {
    return level >= skin.maxLevel;
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = AMAssets.beast.skin(
      beastType: beastType,
      skinId: skin.id,
    );

    final colorScheme = Theme.of(context).colorScheme;

    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isMaxed ? Colors.green : colorScheme.primary,
                  width: _isMaxed ? 2 : 1.2,
                ),
                boxShadow: [
                  if (_isMaxed)
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.22),
                      blurRadius: 14,
                    ),
                ],
              ),
              child: AMAssetImage(
                path: imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                borderRadius: BorderRadius.circular(13),
                fallbackIcon: Icons.pets,
                fallbackIconSize: 72,
              ),
            ),
          ),
          const SizedBox(height: AMSpacing.md),
          Row(
            children: [
              Expanded(child: Text(skin.name, style: AMTextStyles.subtitle)),
              if (_isMaxed)
                const Text(
                  'MAX',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AMSpacing.xs),
          Text('Lv. $level / ${skin.maxLevel}', style: AMTextStyles.body),
          const SizedBox(height: AMSpacing.md),
          AMProgressBar(progress: _progress),
          const SizedBox(height: AMSpacing.sm),
          Text(
            '${(_progress * 100).toStringAsFixed(1)}%',
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: level > 0 ? onDecrease : null,
                  icon: const Icon(Icons.remove),
                  label: const Text('LEVEL'),
                ),
              ),
              const SizedBox(width: AMSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: level < skin.maxLevel ? onIncrease : null,
                  icon: const Icon(Icons.add),
                  label: const Text('LEVEL'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkinDefinition {
  const _SkinDefinition({
    required this.id,
    required this.name,
    required this.maxLevel,
  });

  final String id;
  final String name;
  final int maxLevel;
}

const _skinDefinitions = [
  _SkinDefinition(id: 'regular', name: 'Regular', maxLevel: 20),
  _SkinDefinition(id: 'ice', name: 'Ice', maxLevel: 20),
  _SkinDefinition(id: 'dark', name: 'Dark', maxLevel: 16),
  _SkinDefinition(id: 'desert', name: 'Desert', maxLevel: 16),
  _SkinDefinition(id: 'mecha', name: 'Mecha', maxLevel: 16),
  _SkinDefinition(id: 'dracula', name: 'Dracula', maxLevel: 16),
];
