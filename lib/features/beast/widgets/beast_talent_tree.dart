import 'package:flutter/material.dart';

import '../../../shared/constants/am_assets.dart';
import '../models/beast_type.dart';
import '../models/definitions/beast_talent_definition.dart';
import 'beast_talent_node.dart';

class BeastTalentTree extends StatelessWidget {
  const BeastTalentTree({
    super.key,
    required this.beastType,
    required this.talents,
    required this.selectedTalentId,
    required this.levelForTalent,
    required this.onTalentSelected,
  });

  final BeastType beastType;
  final List<BeastTalentDefinition> talents;
  final String selectedTalentId;

  final int Function(String talentId) levelForTalent;

  final ValueChanged<BeastTalentDefinition> onTalentSelected;

  static const double _minimumCanvasWidth = 390;
  static const double _maximumCanvasWidth = 560;

  static const double _nodeWidth = 138;
  static const double _nodeHeight = 116;
  static const double _topPadding = 24;
  static const double _bottomPadding = 24;
  static const double _rowSpacing = 144;

  @override
  Widget build(BuildContext context) {
    if (talents.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        final canvasWidth = availableWidth
            .clamp(_minimumCanvasWidth, _maximumCanvasWidth)
            .toDouble();

        final nodeRects = _buildNodeRects(canvasWidth: canvasWidth);

        final connections = _buildConnections();

        var maximumRow = 0.0;

        for (final talent in talents) {
          final row = talent.positionY.toDouble();

          if (row > maximumRow) {
            maximumRow = row;
          }
        }

        final canvasHeight =
            _topPadding +
            (maximumRow * _rowSpacing) +
            _nodeHeight +
            _bottomPadding;

        return Center(
          child: SizedBox(
            width: canvasWidth,
            height: canvasHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BeastTalentConnectionPainter(
                      nodeRects: nodeRects,
                      connections: connections,
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveColor: Theme.of(context).dividerColor,
                      selectedTalentId: selectedTalentId,
                    ),
                  ),
                ),
                for (final talent in talents)
                  _buildNode(talent: talent, rect: nodeRects[talent.id]!),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, Rect> _buildNodeRects({required double canvasWidth}) {
    final nodeRects = <String, Rect>{};

    final centerX = canvasWidth / 2;

    final horizontalOffset = (canvasWidth - _nodeWidth) / 2.15;

    for (final talent in talents) {
      final positionX = talent.positionX.toDouble();
      final positionY = talent.positionY.toDouble();

      final nodeCenterX = centerX + (positionX * horizontalOffset);

      final nodeTop = _topPadding + (positionY * _rowSpacing);

      nodeRects[talent.id] = Rect.fromLTWH(
        nodeCenterX - (_nodeWidth / 2),
        nodeTop,
        _nodeWidth,
        _nodeHeight,
      );
    }

    return nodeRects;
  }

  Widget _buildNode({
    required BeastTalentDefinition talent,
    required Rect rect,
  }) {
    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      child: BeastTalentNode(
        name: talent.name,
        iconPath: AMAssets.beast.talent(
          beastType: beastType,
          talentId: talent.id,
        ),
        level: levelForTalent(talent.id),
        maximumLevel: talent.maxLevel,
        isSelected: talent.id == selectedTalentId,
        onTap: () {
          onTalentSelected(talent);
        },
      ),
    );
  }

  List<_TalentConnection> _buildConnections() {
    final talentsByRow = <double, List<BeastTalentDefinition>>{};

    for (final talent in talents) {
      final row = talent.positionY.toDouble();

      talentsByRow
          .putIfAbsent(row, () => <BeastTalentDefinition>[])
          .add(talent);
    }

    final sortedRows = talentsByRow.keys.toList()..sort();

    final connections = <_TalentConnection>[];

    for (var rowIndex = 1; rowIndex < sortedRows.length; rowIndex++) {
      final previousRow =
          talentsByRow[sortedRows[rowIndex - 1]] ??
          const <BeastTalentDefinition>[];

      final currentRow =
          talentsByRow[sortedRows[rowIndex]] ?? const <BeastTalentDefinition>[];

      if (previousRow.isEmpty || currentRow.isEmpty) {
        continue;
      }

      for (final child in currentRow) {
        final childX = child.positionX.toDouble();

        var closestDistance = double.infinity;

        for (final parent in previousRow) {
          final distance = (childX - parent.positionX.toDouble()).abs();

          if (distance < closestDistance) {
            closestDistance = distance;
          }
        }

        for (final parent in previousRow) {
          final distance = (childX - parent.positionX.toDouble()).abs();

          if ((distance - closestDistance).abs() > 0.001) {
            continue;
          }

          connections.add(
            _TalentConnection(parentId: parent.id, childId: child.id),
          );
        }
      }
    }

    return connections;
  }
}

class _BeastTalentConnectionPainter extends CustomPainter {
  const _BeastTalentConnectionPainter({
    required this.nodeRects,
    required this.connections,
    required this.activeColor,
    required this.inactiveColor,
    required this.selectedTalentId,
  });

  final Map<String, Rect> nodeRects;
  final List<_TalentConnection> connections;

  final Color activeColor;
  final Color inactiveColor;

  final String selectedTalentId;

  @override
  void paint(Canvas canvas, Size size) {
    for (final connection in connections) {
      final parentRect = nodeRects[connection.parentId];
      final childRect = nodeRects[connection.childId];

      if (parentRect == null || childRect == null) {
        continue;
      }

      final isActive =
          connection.parentId == selectedTalentId ||
          connection.childId == selectedTalentId;

      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.7)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final linePaint = Paint()
        ..color = isActive ? activeColor : inactiveColor
        ..strokeWidth = isActive ? 3 : 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final start = Offset(parentRect.center.dx, parentRect.bottom);

      final end = Offset(childRect.center.dx, childRect.top);

      final middleY = start.dy + ((end.dy - start.dy) / 2);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(start.dx, middleY)
        ..lineTo(end.dx, middleY)
        ..lineTo(end.dx, end.dy);

      canvas.drawPath(path, shadowPaint);
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BeastTalentConnectionPainter oldDelegate) {
    return oldDelegate.nodeRects != nodeRects ||
        oldDelegate.connections != connections ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.selectedTalentId != selectedTalentId;
  }
}

class _TalentConnection {
  const _TalentConnection({required this.parentId, required this.childId});

  final String parentId;
  final String childId;
}
