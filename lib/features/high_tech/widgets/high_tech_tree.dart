import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/high_tech_controller.dart';
import '../definitions/high_tech_definitions.dart';
import '../dialogs/high_tech_node_dialog.dart';
import '../models/high_tech_state.dart';
import '../models/high_tech_tree_layout.dart';
import 'high_tech_connection_painter.dart';
import 'high_tech_node.dart';

class HighTechTree extends ConsumerStatefulWidget {
  const HighTechTree({
    super.key,
    required this.state,
  });

  final HighTechState state;

  @override
  ConsumerState<HighTechTree> createState() => _HighTechTreeState();
}

class _HighTechTreeState extends ConsumerState<HighTechTree> {
  final TransformationController _transformationController =
      TransformationController();

  String? _selectedNodeId;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _openNodeEditor(String nodeId) async {
    final definition = highTechDefinitionFor(nodeId);

    setState(() {
      _selectedNodeId = nodeId;
    });

    final updatedLevel = await HighTechNodeDialog.show(
      context: context,
      definition: definition,
      currentLevel: widget.state.levelFor(nodeId),
    );

    if (!mounted || updatedLevel == null) {
      return;
    }

    ref.read(highTechControllerProvider.notifier).setLevel(
          nodeId: nodeId,
          level: updatedLevel,
        );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: InteractiveViewer(
        transformationController: _transformationController,
        constrained: false,
        boundaryMargin: const EdgeInsets.all(180),
        minScale: 0.32,
        maxScale: 1.8,
        panEnabled: true,
        scaleEnabled: true,
        child: SizedBox(
          width: highTechTreeLayout.canvasSize.width,
          height: highTechTreeLayout.canvasSize.height,
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.1,
                      colors: [
                        Color(0xFF241C12),
                        Color(0xFF100D0A),
                        Color(0xFF080706),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned.fill(
                child: CustomPaint(
                  painter: HighTechConnectionPainter(
                    layout: highTechTreeLayout,
                  ),
                ),
              ),
              for (final position in highTechTreeLayout.nodes)
                Positioned(
                  left: position.center.dx - (highTechNodeWidth / 2),
                  top: position.center.dy - (highTechNodeHeight / 2),
                  child: HighTechNode(
                    definition: highTechDefinitionFor(position.nodeId),
                    level: widget.state.levelFor(position.nodeId),
                    isSelected: _selectedNodeId == position.nodeId,
                    onTap: () => _openNodeEditor(position.nodeId),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
