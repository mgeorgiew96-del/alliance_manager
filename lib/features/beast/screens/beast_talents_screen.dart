import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/am_spacing.dart';
import '../../../shared/widgets/am_module_header.dart';
import '../../../shared/widgets/am_page.dart';
import '../../../shared/widgets/am_save_cancel_bar.dart';
import '../definitions/beast_talent_definitions.dart';
import '../models/beast_state.dart';
import '../models/beast_type.dart';
import '../providers/beast_repository_provider.dart';
import '../widgets/beast_talent_card.dart';

class BeastTalentsScreen extends ConsumerStatefulWidget {
  const BeastTalentsScreen({
    super.key,
    required this.beastType,
  });

  final BeastType beastType;

  @override
  ConsumerState<BeastTalentsScreen> createState() =>
      _BeastTalentsScreenState();
}

class _BeastTalentsScreenState extends ConsumerState<BeastTalentsScreen> {
  BeastState _savedState = BeastState.initial();
  BeastState _draftState = BeastState.initial();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final repository = ref.read(beastRepositoryProvider);

    final loadedState = await repository.loadBeastState(
      amId: 'AM-1360-001',
    );

    if (!mounted) return;

    setState(() {
      _savedState = loadedState;
      _draftState = loadedState;
      _isLoading = false;
    });
  }

  int _levelFor(String talentId) {
    return _draftState.talentLevels[talentId] ?? 0;
  }

  double get _progress {
    final talents = talentDefinitionsForBeast(widget.beastType);

    var current = 0;
    var maximum = 0;

    for (final talent in talents) {
      current += _levelFor(talent.id);
      maximum += talent.maxLevel;
    }

    if (maximum == 0) return 0;

    return current / maximum;
  }

  String get _lastUpdatedText {
    final lastUpdated = _savedState.lastUpdated;

    if (lastUpdated == null) {
      return 'Never saved';
    }

    return '${lastUpdated.day.toString().padLeft(2, '0')}.'
        '${lastUpdated.month.toString().padLeft(2, '0')}.'
        '${lastUpdated.year} '
        '${lastUpdated.hour.toString().padLeft(2, '0')}:'
        '${lastUpdated.minute.toString().padLeft(2, '0')}';
  }

  void _increase(String talentId, int maxLevel) {
    final current = _levelFor(talentId);

    if (current >= maxLevel) return;

    final levels = Map<String, int>.from(_draftState.talentLevels);
    levels[talentId] = current + 1;

    setState(() {
      _draftState = _draftState.copyWith(
        talentLevels: levels,
        hasUnsavedChanges: true,
      );
    });
  }

  void _decrease(String talentId) {
    final current = _levelFor(talentId);

    if (current <= 0) return;

    final levels = Map<String, int>.from(_draftState.talentLevels);
    levels[talentId] = current - 1;

    setState(() {
      _draftState = _draftState.copyWith(
        talentLevels: levels,
        hasUnsavedChanges: true,
      );
    });
  }

  Future<void> _save() async {
    final repository = ref.read(beastRepositoryProvider);

    final newSavedState = _draftState.copyWith(
      hasUnsavedChanges: false,
      lastUpdated: DateTime.now(),
    );

    await repository.saveBeastState(
      amId: 'AM-1360-001',
      state: newSavedState,
    );

    setState(() {
      _savedState = newSavedState;
      _draftState = newSavedState;
    });
  }

  void _cancel() {
    setState(() {
      _draftState = _savedState.copyWith(
        hasUnsavedChanges: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final talents = talentDefinitionsForBeast(widget.beastType);

    if (_isLoading) {
      return const AMPage(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AMPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AMModuleHeader(
            title: '${widget.beastType.name.toUpperCase()} TALENTS',
            progress: _progress,
            lastUpdated: _lastUpdatedText,
            hasUnsavedChanges: _draftState.hasUnsavedChanges,
          ),

          if (_draftState.hasUnsavedChanges) ...[
            AMSaveCancelBar(
              onSave: _save,
              onCancel: _cancel,
            ),
            const SizedBox(height: AMSpacing.lg),
          ],

          for (final talent in talents)
            BeastTalentCard(
              talent: talent,
              level: _levelFor(talent.id),
              onIncrease: () => _increase(
                talent.id,
                talent.maxLevel,
              ),
              onDecrease: () => _decrease(
                talent.id,
              ),
            ),
        ],
      ),
    );
  }
}