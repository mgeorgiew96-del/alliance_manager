import 'package:flutter/material.dart';

class AMProgressBar extends StatelessWidget {
  const AMProgressBar({super.key, required this.progress, this.height = 10});

  final double progress;
  final double height;

  Color get _color {
    final percent = progress * 100;

    if (percent <= 20) {
      return Colors.red;
    } else if (percent <= 50) {
      return Colors.orange;
    } else if (percent <= 80) {
      return Colors.yellow;
    }

    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: height,
        backgroundColor: Colors.grey.shade800,
        valueColor: AlwaysStoppedAnimation(_color),
      ),
    );
  }
}
