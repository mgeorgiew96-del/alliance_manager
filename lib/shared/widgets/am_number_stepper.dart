import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/am_colors.dart';
import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';

/// A reusable number editor for Alliance Manager.
///
/// Players can change the value by:
/// - tapping the minus or plus buttons;
/// - holding either button for continuous adjustment;
/// - tapping the value and entering a number directly.
///
/// Use [decimalPlaces] to control whether the field accepts whole numbers or
/// decimal values. For example, use `0` for a Totem level and `1` for a weight
/// such as `1.5`.
class AMNumberStepper extends StatefulWidget {
  const AMNumberStepper({
    super.key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.step,
    required this.onChanged,
    this.label,
    this.decimalPlaces = 0,
    this.enabled = true,
    this.compact = false,
    this.semanticLabel,
  }) : assert(maxValue >= minValue),
       assert(step > 0),
       assert(decimalPlaces >= 0),
       assert(decimalPlaces <= 6);

  final double value;
  final double minValue;
  final double maxValue;
  final double step;
  final ValueChanged<double> onChanged;

  final String? label;
  final int decimalPlaces;
  final bool enabled;
  final bool compact;
  final String? semanticLabel;

  @override
  State<AMNumberStepper> createState() => _AMNumberStepperState();
}

class _AMNumberStepperState extends State<AMNumberStepper> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  double _lastCommittedValue = 0;

  @override
  void initState() {
    super.initState();

    _lastCommittedValue = _normalise(widget.value);
    _controller = TextEditingController(text: _format(_lastCommittedValue));
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant AMNumberStepper oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextValue = _normalise(widget.value);
    _lastCommittedValue = nextValue;

    if (!_focusNode.hasFocus) {
      _setControllerText(_format(nextValue));
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  bool get _canDecrease =>
      widget.enabled && _normalise(widget.value) > widget.minValue;

  bool get _canIncrease =>
      widget.enabled && _normalise(widget.value) < widget.maxValue;

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _commitTypedValue();
    }
  }

  void _decrease() {
    if (!_canDecrease) {
      return;
    }

    _commitValue(widget.value - widget.step);
  }

  void _increase() {
    if (!_canIncrease) {
      return;
    }

    _commitValue(widget.value + widget.step);
  }

  void _commitTypedValue() {
    final rawText = _controller.text.trim().replaceAll(',', '.');
    final parsedValue = double.tryParse(rawText);

    if (parsedValue == null) {
      _setControllerText(_format(_lastCommittedValue));
      return;
    }

    _commitValue(parsedValue);
  }

  void _commitValue(double value) {
    final nextValue = _normalise(value);
    _lastCommittedValue = nextValue;
    _setControllerText(_format(nextValue));

    if ((nextValue - _normalise(widget.value)).abs() > _epsilon) {
      widget.onChanged(nextValue);
    }
  }

  double _normalise(double value) {
    final clampedValue = value.clamp(widget.minValue, widget.maxValue);
    final precision = _precisionMultiplier;

    return (clampedValue * precision).round() / precision;
  }

  double get _precisionMultiplier {
    var multiplier = 1.0;
    for (var index = 0; index < widget.decimalPlaces; index++) {
      multiplier *= 10;
    }
    return multiplier;
  }

  double get _epsilon => 0.5 / _precisionMultiplier;

  String _format(double value) {
    if (widget.decimalPlaces == 0) {
      return value.round().toString();
    }

    var text = value.toStringAsFixed(widget.decimalPlaces);

    while (text.contains('.') && text.endsWith('0')) {
      text = text.substring(0, text.length - 1);
    }
    if (text.endsWith('.')) {
      text = text.substring(0, text.length - 1);
    }

    return text;
  }

  void _setControllerText(String text) {
    if (_controller.text == text) {
      return;
    }

    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _selectAll() {
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RepeatButton(
          icon: Icons.remove,
          tooltip: 'Decrease',
          enabled: _canDecrease,
          compact: widget.compact,
          onPressed: _decrease,
        ),
        SizedBox(width: widget.compact ? AMSpacing.xs : AMSpacing.sm),
        _buildValueField(),
        SizedBox(width: widget.compact ? AMSpacing.xs : AMSpacing.sm),
        _RepeatButton(
          icon: Icons.add,
          tooltip: 'Increase',
          enabled: _canIncrease,
          compact: widget.compact,
          onPressed: _increase,
        ),
      ],
    );

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      value: _format(widget.value),
      enabled: widget.enabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(widget.label!, style: AMTextStyles.muted),
            const SizedBox(height: AMSpacing.xs),
          ],
          content,
        ],
      ),
    );
  }

  Widget _buildValueField() {
    final fieldHeight = widget.compact ? 38.0 : 44.0;
    final fieldWidth = widget.compact ? 72.0 : 88.0;

    return SizedBox(
      width: fieldWidth,
      height: fieldHeight,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        keyboardType: TextInputType.numberWithOptions(
          decimal: widget.decimalPlaces > 0,
          signed: widget.minValue < 0,
        ),
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        style: AMTextStyles.body.copyWith(
          color: widget.enabled
              ? AMColors.goldLight
              : AMColors.textMuted,
          fontSize: widget.compact ? 14 : 16,
          fontWeight: FontWeight.w700,
        ),
        inputFormatters: [
          _DecimalNumberInputFormatter(
            decimalPlaces: widget.decimalPlaces,
            allowNegative: widget.minValue < 0,
          ),
        ],
        onTap: _selectAll,
        onSubmitted: (_) {
          _commitTypedValue();
          _focusNode.unfocus();
        },
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AMSpacing.sm,
            vertical: AMSpacing.sm,
          ),
          filled: true,
          fillColor: AMColors.panelLight,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AMColors.gold.withValues(alpha: 0.55),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AMColors.goldLight,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AMColors.textMuted.withValues(alpha: 0.35),
            ),
          ),
        ),
      ),
    );
  }
}

class _RepeatButton extends StatefulWidget {
  const _RepeatButton({
    required this.icon,
    required this.tooltip,
    required this.enabled,
    required this.compact,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool enabled;
  final bool compact;
  final VoidCallback onPressed;

  @override
  State<_RepeatButton> createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<_RepeatButton> {
  Timer? _repeatTimer;
  DateTime? _holdStartedAt;

  @override
  void didUpdateWidget(covariant _RepeatButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.enabled) {
      _stopRepeating();
    }
  }

  @override
  void dispose() {
    _stopRepeating();
    super.dispose();
  }

  void _startRepeating() {
    if (!widget.enabled) {
      return;
    }

    _stopRepeating();
    _holdStartedAt = DateTime.now();
    widget.onPressed();
    _scheduleNextRepeat();
  }

  void _scheduleNextRepeat() {
    if (!widget.enabled || _holdStartedAt == null) {
      return;
    }

    final heldFor = DateTime.now().difference(_holdStartedAt!);
    final delay = heldFor >= const Duration(seconds: 2)
        ? const Duration(milliseconds: 70)
        : const Duration(milliseconds: 150);

    _repeatTimer = Timer(delay, () {
      if (!mounted || !widget.enabled || _holdStartedAt == null) {
        _stopRepeating();
        return;
      }

      widget.onPressed();
      _scheduleNextRepeat();
    });
  }

  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
    _holdStartedAt = null;
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.compact ? 38.0 : 44.0;

    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onLongPressStart: widget.enabled ? (_) => _startRepeating() : null,
        onLongPressEnd: widget.enabled ? (_) => _stopRepeating() : null,
        onLongPressCancel: widget.enabled ? _stopRepeating : null,
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: IconButton(
            onPressed: widget.enabled ? widget.onPressed : null,
            padding: EdgeInsets.zero,
            splashRadius: buttonSize / 2,
            style: IconButton.styleFrom(
              foregroundColor: AMColors.goldLight,
              disabledForegroundColor: AMColors.textMuted,
              backgroundColor: AMColors.panelLight,
              disabledBackgroundColor:
                  AMColors.panelLight.withValues(alpha: 0.45),
              side: BorderSide(
                color: widget.enabled
                    ? AMColors.gold.withValues(alpha: 0.55)
                    : AMColors.textMuted.withValues(alpha: 0.25),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(widget.icon, size: widget.compact ? 18 : 20),
          ),
        ),
      ),
    );
  }
}

class _DecimalNumberInputFormatter extends TextInputFormatter {
  _DecimalNumberInputFormatter({
    required this.decimalPlaces,
    required this.allowNegative,
  });

  final int decimalPlaces;
  final bool allowNegative;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty || (allowNegative && text == '-')) {
      return newValue;
    }

    final signPattern = allowNegative ? r'-?' : '';
    final decimalPattern = decimalPlaces == 0
        ? ''
        : r'([.,]\d{0,' + decimalPlaces.toString() + r'})?';
    final expression = RegExp(
      '^$signPattern\\d*$decimalPattern\$',
    );

    return expression.hasMatch(text) ? newValue : oldValue;
  }
}
