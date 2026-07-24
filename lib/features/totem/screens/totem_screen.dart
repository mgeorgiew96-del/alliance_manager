import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/theme/am_colors.dart';
import '../../../shared/theme/am_spacing.dart';
import '../../../shared/theme/am_text_styles.dart';
import '../../../shared/widgets/am_asset_image.dart';
import '../../../shared/widgets/am_card.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_progress_bar.dart';
import '../definitions/totem_definitions.dart';
import '../models/totem_definition.dart';
import '../models/totem_progress_config.dart';
import '../models/totem_rarity.dart';
import '../models/totem_state.dart';
import '../models/totem_type.dart';
import '../providers/totem_repository_provider.dart';
import '../services/totem_progress_service.dart';
import '../widgets/totem_card.dart';
import '../widgets/totem_primary_card.dart';
import '../widgets/totem_secondary_card.dart';

class TotemScreen extends ConsumerStatefulWidget {
  const TotemScreen({
    super.key,
    required this.amId,
  });

  final String amId;

  @override
  ConsumerState<TotemScreen> createState() => _TotemScreenState();
}

class _TotemScreenState extends ConsumerState<TotemScreen> {
  TotemState _state = TotemState.initial();
  final TotemProgressConfig _progressConfig = TotemProgressConfig.defaults();

  bool _isLoading = true;
  bool _isSaving = false;
  Object? _loadError;

  TotemDefinition get _primaryDefinition {
    return TotemDefinitions.forType(_state.primaryType);
  }

  TotemDefinition get _secondaryDefinition {
    return TotemDefinitions.forType(_state.secondaryType);
  }

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_loadState);
  }

  Future<void> _loadState() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final repository = ref.read(totemRepositoryProvider);
      final loadedState = await repository.loadTotemState(
        amId: widget.amId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _state = loadedState;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  void _updateLevel(TotemType type, int level) {
    setState(() {
      _state = _state.setLevel(
        type: type,
        level: level,
      );
    });
  }

  void _updateSkillLevel(TotemType type, int skillLevel) {
    setState(() {
      _state = _state.setSkillLevel(
        type: type,
        skillLevel: skillLevel,
      );
    });
  }

  void _setPrimary(TotemType type) {
    setState(() {
      _state = _state.setPrimary(type);
    });
  }

  void _setSecondary(TotemType type) {
    setState(() {
      _state = _state.setSecondary(type);
    });
  }

  Future<void> _save() async {
    if (_isSaving || !_state.hasUnsavedChanges) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final savedState = _state.saveSnapshot();

    try {
      final repository = ref.read(totemRepositoryProvider);

      await repository.saveTotemState(
        amId: widget.amId,
        state: savedState,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _state = savedState;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Totem progress saved.'),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to save Totem progress: $error',
          ),
        ),
      );
    }
  }

  void _cancel() {
    if (_isSaving) {
      return;
    }

    setState(() {
      _state = _state.cancelChanges();
    });
  }

  double get _overallProgress {
    return TotemProgressService.calculateOverallProgress(
      state: _state,
      config: _progressConfig,
    );
  }

  Color _rarityColor(TotemRarity rarity) {
    switch (rarity) {
      case TotemRarity.gold:
        return AMColors.gold;
      case TotemRarity.purple:
        return const Color(0xFFB875FF);
      case TotemRarity.blue:
        return const Color(0xFF4AA3FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AMPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TotemBanner(
            onBack: () => context.go('/member/${widget.amId}'),
          ),
          const SizedBox(height: AMSpacing.lg),
          if (_isLoading)
            const _TotemLoadingCard()
          else if (_loadError != null)
            _TotemErrorCard(
              message: _loadError.toString(),
              onRetry: _loadState,
            )
          else ...[
            _OverallProgressCard(
              progress: _overallProgress,
            ),
            const SizedBox(height: AMSpacing.lg),
            TotemPrimaryCard(
              definition: _primaryDefinition,
              data: _state.primaryTotem,
              onLevelChanged: (value) {
                _updateLevel(
                  _state.primaryType,
                  value,
                );
              },
              onSkillLevelChanged: (value) {
                _updateSkillLevel(
                  _state.primaryType,
                  value,
                );
              },
            ),
            const SizedBox(height: AMSpacing.lg),
            TotemSecondaryCard(
              definition: _secondaryDefinition,
              data: _state.secondaryTotem,
              onLevelChanged: (value) {
                _updateLevel(
                  _state.secondaryType,
                  value,
                );
              },
              onSkillLevelChanged: (value) {
                _updateSkillLevel(
                  _state.secondaryType,
                  value,
                );
              },
            ),
            const SizedBox(height: AMSpacing.lg),
            _SaveCancelBar(
              hasChanges: _state.hasUnsavedChanges,
              isSaving: _isSaving,
              onSave: _save,
              onCancel: _cancel,
            ),
            const SizedBox(height: AMSpacing.xl),
            for (final rarity in <TotemRarity>[
              TotemRarity.gold,
              TotemRarity.purple,
              TotemRarity.blue,
            ]) ...[
              _RarityHeader(
                rarity: rarity,
                color: _rarityColor(rarity),
              ),
              const SizedBox(height: AMSpacing.md),
              for (final definition
                  in TotemDefinitions.forRarity(rarity)) ...[
                TotemCard(
                  definition: definition,
                  data: _state.dataFor(definition.type),
                  isPrimary: _state.isPrimary(definition.type),
                  isSecondary: _state.isSecondary(definition.type),
                  accentColor: _rarityColor(rarity),
                  onLevelChanged: (value) {
                    _updateLevel(
                      definition.type,
                      value,
                    );
                  },
                  onSkillLevelChanged: (value) {
                    _updateSkillLevel(
                      definition.type,
                      value,
                    );
                  },
                  onSetPrimary: () {
                    _setPrimary(definition.type);
                  },
                  onSetSecondary: () {
                    _setSecondary(definition.type);
                  },
                ),
                const SizedBox(height: AMSpacing.md),
              ],
              const SizedBox(height: AMSpacing.lg),
            ],
          ],
        ],
      ),
    );
  }
}

class _TotemBanner extends StatelessWidget {
  const _TotemBanner({
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 16 / 6,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AMAssetImage(
              path: 'assets/images/banners/totem_banner.png',
              fit: BoxFit.cover,
              fallbackIcon: Icons.account_balance_rounded,
              fallbackIconSize: 72,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.12),
                    Color.fromRGBO(0, 0, 0, 0.22),
                    Color.fromRGBO(0, 0, 0, 0.70),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AMSpacing.sm,
              top: AMSpacing.sm,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AMColors.gold.withValues(alpha: 0.7),
                  ),
                ),
                child: IconButton(
                  tooltip: 'Back to My Castle',
                  onPressed: onBack,
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: AMColors.goldLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallProgressCard extends StatelessWidget {
  const _OverallProgressCard({
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AMColors.gold.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AMColors.gold,
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AMColors.goldLight,
                ),
              ),
              const SizedBox(width: AMSpacing.md),
              Expanded(
                child: Text(
                  'OVERALL TOTEM PROGRESS',
                  style: AMTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: AMTextStyles.title.copyWith(
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: AMSpacing.lg),
          AMProgressBar(progress: progress),
          const SizedBox(height: AMSpacing.sm),
          Text(
            'Only the Primary and Secondary Totems contribute. '
            'Rarity and Level/Skill weights are applied.',
            style: AMTextStyles.muted,
          ),
        ],
      ),
    );
  }
}

class _SaveCancelBar extends StatelessWidget {
  const _SaveCancelBar({
    required this.hasChanges,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  final bool hasChanges;
  final bool isSaving;
  final Future<void> Function() onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final controlsEnabled = hasChanges && !isSaving;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: hasChanges ? 1 : 0.55,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controlsEnabled ? onCancel : null,
              child: const Text('CANCEL'),
            ),
          ),
          const SizedBox(width: AMSpacing.md),
          Expanded(
            child: FilledButton(
              onPressed: controlsEnabled ? onSave : null,
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('SAVE'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RarityHeader extends StatelessWidget {
  const _RarityHeader({
    required this.rarity,
    required this.color,
  });

  final TotemRarity rarity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color.withValues(alpha: 0.45),
          ),
        ),
        const SizedBox(width: AMSpacing.sm),
        Icon(
          Icons.diamond_outlined,
          color: color,
          size: 19,
        ),
        const SizedBox(width: AMSpacing.xs),
        Text(
          '${rarity.displayName.toUpperCase()} TOTEMS',
          style: AMTextStyles.subtitle.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: AMSpacing.sm),
        Expanded(
          child: Divider(
            color: color.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _TotemLoadingCard extends StatelessWidget {
  const _TotemLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const AMCard(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AMSpacing.xl,
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _TotemErrorCard extends StatelessWidget {
  const _TotemErrorCard({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return AMCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unable to load Totem progress',
            style: AMTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AMSpacing.sm),
          Text(
            message,
            style: AMTextStyles.muted,
          ),
          const SizedBox(height: AMSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('RETRY'),
            ),
          ),
        ],
      ),
    );
  }
}
